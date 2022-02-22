#!/bin/bash






exec 3>&1 4>&2
exec 1>SpackTestCI.out 2>SpackTestCI.err

echo "Test"

exec 1>SpackTestCI.status

echo "Status"
