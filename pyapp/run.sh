set -x

source .venv/bin/activate

fastapi run --host 0.0.0.0 --port 80
