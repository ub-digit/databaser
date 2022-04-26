#!/bin/bash

echo 'Content-type: application/json'
echo 'Access-Control-Allow-Origin: *'
echo 'Access-Control-Allow-Headers: *'
echo ''
echo '{'
echo '"backend_url": "'"${DB_LIST_BACKEND_URL}"'",'
echo '"alert_url": "'"${DB_LIST_ALERT_URL}"'"'
echo '}'
