---
alwaysApply: true
---

NEVER use `edit_existing_file` or `create_new_file` to modify files. These tools cause content corruption and require manual Accept/Reject in the editor.

ALWAYS use `run_terminal_command` with `cat << EOF > filepath` to write file content. This is the ONLY permitted way to modify files.
