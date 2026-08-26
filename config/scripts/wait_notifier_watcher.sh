#!/usr/bin/env sh

until busctl --user status org.kde.StatusNotifierWatcher >/dev/null 2>&1; do
    sleep 0.1
done

exec "$@"
