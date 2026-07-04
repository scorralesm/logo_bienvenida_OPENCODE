# Rules for logo_bienvenida_OPENCODE

- **Automatic Engram CLI Fallback:** If the native `mem_save` or `mem_session_summary` tools are not available in the agent's active tool list, the agent MUST automatically run the `engram save` command in PowerShell/Bash when a project phase, major task, or session is completed. Do not wait for the user to prompt or remind you.
