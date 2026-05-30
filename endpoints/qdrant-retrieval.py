import json
import logging
from typing import Mapping

import httpx
from dify_plugin import Endpoint
from werkzeug import Request, Response

logger = logging.getLogger(__name__)


def embed(text: str, ollama_url: str, embed_model: str) -> list[float]:
    resp = httpx.post(
        f"{ollama_url}/api/embed",
        json={"model": embed_model, "input": text, "keep_alive": -1},
        timeout=60,
    )
    resp.raise_for_status()
    return resp.json()["embeddings"][0]


def search(
    vector: list[float],
    top_k: int,
    score_threshold: float,
    qdrant_url: str,
    qdrant_api_key: str,
    collection: str,
) -> list[dict]:
    resp = httpx.post(
        f"{qdrant_url}/collections/{collection}/points/search",
        headers={"api-key": qdrant_api_key, "Content-Type": "application/json"},
        json={
            "vector": vector,
            "limit": top_k,
            "score_threshold": score_threshold,
            "with_payload": True,
        },
        timeout=30,
    )
    resp.raise_for_status()
    return resp.json().get("result", [])


class QdrantRetrievalEndpoint(Endpoint):
    def _invoke(self, r: Request, values: Mapping, settings: Mapping) -> Response:
        try:
            body = r.get_json(force=True, silent=True) or {}
        except Exception:
            return Response(
                json.dumps({"error": "invalid JSON"}),
                status=400,
                content_type="application/json",
            )

        query = next((v for k, v in body.items() if k.lower() == "query"), "").strip()
        retrieval_setting = body.get("retrieval_setting", {})
        top_k = int(retrieval_setting.get("top_k", 5))
        score_threshold = float(retrieval_setting.get("score_threshold", 0.3))

        qdrant_url = settings.get("qdrant_url", "").rstrip("/")
        qdrant_api_key = settings.get("qdrant_api_key", "")
        collection = body.get("knowledge_id") or settings.get("collection", "")
        ollama_url = settings.get("ollama_url", "").rstrip("/")
        embed_model = settings.get("embed_model", "")

        if not query:
            return Response(
                json.dumps({"records": []}), status=200, content_type="application/json"
            )

        try:
            vector = embed(query, ollama_url, embed_model)
            hits = search(vector, top_k, score_threshold, qdrant_url, qdrant_api_key, collection)
        except Exception as e:
            logger.error("embed/search failed: %s", e)
            return Response(
                json.dumps({"error": str(e)}),
                status=500,
                content_type="application/json",
            )

        records = []
        for hit in hits:
            payload = hit.get("payload", {})
            content = payload.get("content", "")

            space_key = payload.get("space_key", "")
            confluence_page_id = payload.get("confluence_page_id", "")
            confluence_url = (
                f"https://brpdigital.atlassian.net/wiki/spaces/{space_key}/pages/{confluence_page_id}"
                if space_key and confluence_page_id else ""
            )
            source_path = confluence_url or payload.get("pdf_url", "")

            category = payload.get("category", "")
            folder_path = payload.get("folder_path", "")
            title = payload.get("title", "")

            meta_parts = []
            if confluence_url:
                meta_parts.append(f"URL: {confluence_url}")
            if space_key:
                meta_parts.append(f"Space: {space_key}")
            if category:
                meta_parts.append(f"Category: {category}")
            if folder_path:
                meta_parts.append(f"Path: {folder_path}")
            if title:
                meta_parts.append(f"Document: {title}")
            enriched_content = ("[" + " | ".join(meta_parts) + "]\n" + content) if meta_parts else content

            records.append(
                {
                    "metadata": {
                        "path": source_path,
                        "page_num": payload.get("page_num", 0),
                        "doc_id": payload.get("doc_id", ""),
                        "chunk_type": payload.get("chunk_type", "text"),
                        "tenant": payload.get("tenant", ""),
                        "project": payload.get("project", ""),
                        "domain": payload.get("domain", ""),
                        "section": payload.get("section", ""),
                        "type": payload.get("type", ""),
                        "hierarchy": payload.get("hierarchy", []),
                        "category": category,
                        "page_id_chain": payload.get("page_id_chain", []),
                        "tree_depth": payload.get("tree_depth", 0),
                        "space_key": space_key,
                        "confluence_page_id": confluence_page_id,
                        "confluence_parent_id": payload.get("confluence_parent_id", ""),
                        "folder_path": folder_path,
                    },
                    "score": hit.get("score", 0.0),
                    "title": title,
                    "content": enriched_content,
                }
            )

        return Response(
            json.dumps({"records": records}),
            status=200,
            content_type="application/json",
        )
