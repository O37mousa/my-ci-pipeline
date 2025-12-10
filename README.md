
# Simple Jenkins Pipeline with Code Check (Checkpoint Demo)

## How it works
- After checkout, the pipeline runs a `code-check` stage.
- If `package.json` exists (Node.js project), it runs:
  npm install && npm run lint
- Otherwise, it prints a placeholder: `lint check`.

## Customize for other languages (optional)
- Python: change in Jenkinsfile to `def cmd = 'flake8 .'`
- Java (Maven): change to `def cmd = 'mvn checkstyle:check'`

## What to expect
- On lint failure: pipeline stops with a clear message.
- On success: pipeline continues to Build and Test placeholders.
