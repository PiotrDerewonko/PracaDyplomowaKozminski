#!/usr/bin/env sh
set -e

# Czekaj na DB (prosto, bez dodatkowych paczek)
python - <<'PY'
import os, time, socket
host = os.getenv("POSTGRES_HOST", "postgres")
port = int(os.getenv("POSTGRES_PORT", "5432"))
for _ in range(60):
    try:
        with socket.create_connection((host, port), timeout=1):
            print("DB is up")
            break
    except OSError:
        time.sleep(1)
else:
    raise SystemExit("DB not reachable")
PY

python manage.py migrate --noinput

# DEV: utwórz superusera jeśli nie istnieje (kontrolowane envami)
python manage.py shell -c "
import os
from django.contrib.auth import get_user_model

username = os.getenv('DJANGO_SUPERUSER_USERNAME')
email    = os.getenv('DJANGO_SUPERUSER_EMAIL','')
password = os.getenv('DJANGO_SUPERUSER_PASSWORD')

if username and password:
    User = get_user_model()
    if not User.objects.filter(username=username).exists():
        User.objects.create_superuser(username=username, email=email, password=password)
        print('Superuser created')
    else:
        print('Superuser already exists')
else:
    print('No superuser envs set; skipping')
"


exec "$@"
