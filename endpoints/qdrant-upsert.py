import json
import logging
import uuid
from typing import Mapping

import httpx
from dify_plugin import Endpoint
from werkzeug import Request, Response

from version import __version__

logger = logging.getLogger(__name__)

_NS = uuid.UUID("6ba7b810-9dad-11d1-80b4-00c04fd430c8")


def _to_qdrant_id(doc_id: str) -> str:
    return str(uuid.uuid5(_NS, doc_id))


def embed(text: str, ollama_url: str, embed_model: str) -> list[float]:
    resp = httpx.post(
        f"{ollama_url}/api/embed",
        json={"model": embed_model, "input": text, "keep_alive": -1},
        timeout=60,
    )
    resp.raise_for_status()
    return resp.json()["embeddings"][0]


def create_collection(vector_size: int, qdrant_url: str, qdrant_api_key: str, collection: str) -> None:
    resp = httpx.put(
        f"{qdrant_url}/collections/{collection}",
        headers={"api-key": qdrant_api_key, "Content-Type": "application/json"},
        json={"vectors": {"size": vector_size, "distance": "Cosine"}},
        timeout=30,
    )
    resp.raise_for_status()


def upsert_points(points: list[dict], qdrant_url: str, qdrant_api_key: str, collection: str) -> None:
    resp = httpx.put(
        f"{qdrant_url}/collections/{collection}/points",
        params={"wait": "true"},
        headers={"api-key": qdrant_api_key, "Content-Type": "application/json"},
        json={"points": points},
        timeout=60,
    )
    if resp.status_code == 404:
        vector_size = len(points[0]["vector"])
        create_collection(vector_size, qdrant_url, qdrant_api_key, collection)
        resp = httpx.put(
            f"{qdrant_url}/collections/{collection}/points",
            params={"wait": "true"},
            headers={"api-key": qdrant_api_key, "Content-Type": "application/json"},
            json={"points": points},
            timeout=60,
        )
    resp.raise_for_status()


class QdrantUpsertEndpoint(Endpoint):
    def _invoke(self, r: Request, values: Mapping, settings: Mapping) -> Response:
        try:
            body = r.get_json(force=True, silent=True) or {}
        except Exception:
            return Response(
                json.dumps({"error": "invalid JSON"}),
                status=400,
                content_type="application/json",
            )

        qdrant_url = settings.get("qdrant_url", "").rstrip("/")
        qdrant_api_key = settings.get("qdrant_api_key", "")
        collection = body.get("collection") or settings.get("collection", "")
        ollama_url = settings.get("ollama_url", "").rstrip("/")
        embed_model = settings.get("embed_model", "")

        # Support both single-doc and batch payloads.
        if "documents" in body:
            docs = body["documents"]
        elif "content" in body:
            docs = [body]
        else:
            return Response(
                json.dumps({"error": "missing 'content' or 'documents'"}),
                status=400,
                content_type="application/json",
            )

        if not isinstance(docs, list) or not docs:
            return Response(
                json.dumps({"error": "'documents' must be a non-empty list"}),
                status=400,
                content_type="application/json",
            )

        points = []
        returned_ids = []
        try:
            for doc in docs:
                content = doc.get("content", "")
                if not content:
                    return Response(
                        json.dumps({"error": "each document must have 'content'"}),
                        status=400,
                        content_type="application/json",
                    )
                raw_id = doc.get("id")
                if raw_id:
                    point_id = _to_qdrant_id(str(raw_id))
                    returned_ids.append(str(raw_id))
                else:
                    point_id = str(uuid.uuid4())
                    returned_ids.append(point_id)

                metadata = doc.get("metadata") or {}
                payload = {"content": content, **metadata}

                vector = embed(content, ollama_url, embed_model)
                points.append({"id": point_id, "vector": vector, "payload": payload})
        except Exception as e:
            logger.error("embed failed: %s", e)
            return Response(
                json.dumps({"error": str(e)}),
                status=500,
                content_type="application/json",
            )

        try:
            upsert_points(points, qdrant_url, qdrant_api_key, collection)
        except httpx.HTTPStatusError as e:
            status = e.response.status_code if e.response.status_code >= 500 else 400
            logger.error("upsert failed: %s", e)
            return Response(
                json.dumps({"error": str(e)}),
                status=status,
                content_type="application/json",
            )
        except Exception as e:
            logger.error("upsert failed: %s", e)
            return Response(
                json.dumps({"error": str(e)}),
                status=500,
                content_type="application/json",
            )

        return Response(
            json.dumps({"upserted": len(points), "ids": returned_ids, "plugin_version": __version__}),
            status=200,
            content_type="application/json",
        )
