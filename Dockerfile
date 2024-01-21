# syntax=docker/dockerfile:1


ARG PYTHON_VERSION=3.10
FROM python:${PYTHON_VERSION}-slim as base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.cache/pip to speed up subsequent builds.
# Leverage a bind mount to requirements.txt to avoid having to copy them into
# into this layer.
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt



# Copy the source code into the container.
COPY . /app

RUN rm -f core/store.sqlite3
RUN FLASK_APP=core/server.py flask db upgrade -d core/migrations/

# Test the application.
RUN python -m pytest -vvv -s tests/

# Expose the port that the application listens on.
EXPOSE 7755

# Run the application.
CMD gunicorn -c gunicorn_config.py core.server:app
