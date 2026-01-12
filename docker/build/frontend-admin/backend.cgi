#!/bin/bash

echo 'Content-type: application/json'
echo 'Access-Control-Allow-Origin: *'
echo 'Access-Control-Allow-Headers: *'
echo ''
echo '{'
echo '"backend_url": "'"${DATABASER_BACKEND_ADMIN_URL}"'"'
echo '}'
