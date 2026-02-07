FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies for common Python packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requriments.txt /app/
RUN pip install --no-cache-dir -r requriments.txt

# Copy project code
COPY . /app

# Default command can be overridden by docker-compose
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
