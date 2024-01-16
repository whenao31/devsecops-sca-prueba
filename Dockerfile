FROM python:3.10.12-slim-bookworm

# Create a non-root user
RUN useradd -ms /bin/bash appuser

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements/requirements-dev.txt /app/

RUN pip install --upgrade pip
RUN pip install -r requirements-dev.txt

COPY . /app/

# Switch to non-root user
USER appuser