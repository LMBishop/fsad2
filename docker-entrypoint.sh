echo "==> Starting postgres..."
pg_ctlcluster 13 main start

echo "==> Executing SQL file at /app/file.sql as user 'fsad'..."
su fsad -c "psql -c \"\i /app/file.sql\""

if [ "$NO_INTERACTIVE" = 1 ]; then
    echo "==> Done."
else
    echo "==> Done. A psql shell will be started as user 'fsad' on database 'fsad'." 
    su fsad -c "psql"
fi
