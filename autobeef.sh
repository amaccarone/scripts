#!/bin/bash

get_token="$(curl -H "Content-Type: application/json" -X POST -d '{"username":"beef", "password":"beef"}' http://127.0.0.1:3000/api/admin/login)"

token="$(echo "$get_token" | awk -F '["]' '{print $6}')"

get_sessions="$(curl http://127.0.0.1:3000/api/hooks?token=$token | json_pp)"

echo "$get_sessions"

echo -n "Enter a Session: "

read session 

curl http://127.0.0.1:3000/api/hooks/${session}?token=${token} | json_pp
