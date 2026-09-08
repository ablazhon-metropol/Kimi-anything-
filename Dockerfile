FROM python:3.12-slim AS unpacker
WORKDIR /source
COPY Agent_Metropol_v4.0.3.zip /tmp/agent.zip
RUN python -m zipfile -e /tmp/agent.zip /source

FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
WORKDIR /app
COPY --from=unpacker /source/metropol-agent-v4.0.3/ /app/
RUN pip install --no-cache-dir -r requirements.txt \
    && useradd --create-home --uid 10001 agent \
    && mkdir -p /app/data \
    && chown -R agent:agent /app/data
USER agent
EXPOSE 8080
CMD ["python", "-m", "metropol_agent"]
