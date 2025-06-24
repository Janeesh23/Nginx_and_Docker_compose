FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim
WORKDIR /app
COPY uv.lock pyproject.toml ./
RUN uv sync --locked
COPY . .
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*
EXPOSE 8002
CMD ["uv", "run", "app.py"]
