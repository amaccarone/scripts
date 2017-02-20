#!/bin/bash

get_token="$(curl -H "Content-Type: application/json" -X POST -d '{"username":"beef", "password":"beef"}' http://127.0.0.1:3000/api/admin/login)"

token="$(echo "$get_token" | awk -F '["]' '{print $6}')"

function select_target {
	get_sessions="$(curl http://127.0.0.1:3000/api/hooks?token=$token | json_pp)"
	echo "$get_sessions"
	echo -n "Enter a Session: "
	read session 
}

function about_browser {
	curl http://127.0.0.1:3000/api/hooks/${session}?token=${token} | json_pp
	read -n1 -r -p "Press space to continue..." key	
}

while :
do
    clear
    cat<<EOF
    ==============================
    autoBeEF v1.0
    ------------------------------
    Please enter your choice:

    Select Target     (1)
    About Target      (2)
    Persistance       (3)
    Attack            (4)
                      (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "1")  select_target             ;;
    "2")  about_browser             ;;
    "3")  echo "you chose choice 3" ;;
    "Q")  exit                      ;;
    "q")  exit                      ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
