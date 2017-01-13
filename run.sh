#!/bin/bash

cd /opt/graphite
if [ ! -f /opt/graphite/storage/graphite.db ]; then
  echo "Creating database..."
  PYTHONPATH=$GRAPHITE_ROOT/webapp django-admin.py migrate --settings=graphite.settings --run-syncdb
  chown nginx:nginx /opt/graphite/storage/graphite.db
fi

exec supervisord -c /etc/supervisord.conf
