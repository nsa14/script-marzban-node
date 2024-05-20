#!/bin/bash -e

echo
echo " 
███╗░░░███╗░█████╗░██████╗░███████╗██████╗░░█████╗░███╗░░██╗  ███╗░░██╗░█████╗░██████╗░███████╗
████╗░████║██╔══██╗██╔══██╗╚════██║██╔══██╗██╔══██╗████╗░██║  ████╗░██║██╔══██╗██╔══██╗██╔════╝
██╔████╔██║███████║██████╔╝░░███╔═╝██████╦╝███████║██╔██╗██║  ██╔██╗██║██║░░██║██║░░██║█████╗░░
██║╚██╔╝██║██╔══██║██╔══██╗██╔══╝░░██╔══██╗██╔══██║██║╚████║  ██║╚████║██║░░██║██║░░██║██╔══╝░░
██║░╚═╝░██║██║░░██║██║░░██║███████╗██████╦╝██║░░██║██║░╚███║  ██║░╚███║╚█████╔╝██████╔╝███████╗
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚══╝  ╚═╝░░╚══╝░╚════╝░╚═════╝░╚══════╝ "
echo "***** https://github.com/nsa14/script-marzban-node *****"
echo "***** write by Naser.Zare *****"
echo
sleep 1

function exit_badly {
echo "$1"
exit 1
}

error() {
    echo -e " \n $red Something Bad Happen $none \n "
}

if [ "$EUID" -ne 0 ]
then echo "Please run as root."
exit
fi


DISTRO="$(awk -F= '/^NAME/{print tolower($2)}' /etc/os-release|awk 'gsub(/[" ]/,x) + 1')"
DISTROVER="$(awk -F= '/^VERSION_ID/{print tolower($2)}' /etc/os-release|awk 'gsub(/[" ]/,x) + 1')"

valid_os()
{
    case "$DISTRO" in
    "debiangnu/linux"|"ubuntu")
        return 0;;
    *)
        echo "OS $DISTRO is not supported"
        return 1;;
    esac
}
if ! valid_os "$DISTRO"; then
    echo "Bye."
    exit 1
else
[[ $(id -u) -eq 0 ]] || exit_badly "Please re-run as root (e.g. sudo ./path/to/this/script)"
fi

update_os() {
apt-get -o Acquire::ForceIPv4=true update
apt-get -o Acquire::ForceIPv4=true install -y software-properties-common
add-apt-repository --yes universe
add-apt-repository --yes restricted
add-apt-repository --yes multiverse
apt-get -o Acquire::ForceIPv4=true install -y moreutils dnsutils tmux screen nano wget curl socat jq qrencode unzip lsof
}

export RED=$(tput setaf 1 :-"" 2>/dev/null)
export GREEN=$(tput setaf 2 :-"" 2>/dev/null)
export YELLOW=$(tput setaf 3 :-"" 2>/dev/null)
export BLUE=$(tput setaf 4 :-"" 2>/dev/null)
export RESET=$(tput sgr0 :-"" 2>/dev/null)

rtt_instller() {
    echo " 🆂🆃🅰🆁🆃 installer "
    sleep 1
    wget  "https://raw.githubusercontent.com/nsa14/script-marzban-node/master/install.sh" -O install.sh && chmod +x install.sh && bash install.sh 
    exit 1;
}

update_upgrade_server() {
    echo "
▄█
░█ 🆂🆃🅰🆁🆃 checked update and upgrade OS"
        echo "  "
    echo "  "
    updates=$(apt list upgradeable |& grep -Ev '^(Listing|WARNING)') 
        if [${updates} ]; then
            echo "updates available"
            apt-get update; apt-get upgrade -y; apt-get install curl socat git -y; apt-get install curl socat git -y & spinner3
            reboot
            else
            echo "no updates!"
            echo $GREEN; printf -- "-%.0s" $(seq $(tput cols)); echo $RESET
            check_docker
        fi

}

check_docker(){
    echo "

▀█
█▄ 🆂🆃🅰🆁🆃 checked docker"
    echo "   "
    echo "  "
    if [[ $(docker -v) == *" 26.1."* ]]; then
        echo "docker is OK" & spinner3
        echo $GREEN; printf -- "-%.0s" $(seq $(tput cols)); echo $RESET
    else 
        install_docker
    fi
}

install_docker(){
	echo "  "
    echo "  🆂🆃🅰🆁🆃 install docker "
    echo "  "
    echo " please do not reboot or close. please wait ..."
    # curl -fsSL https://get.docker.com | sh & spinner3 || { echo "Something went wrong! did you interupt the docker update? then no problem - Are you trying to install Docker on an IR server? try setting DNS."; }
    var_install_docker=$(curl -fsSL https://get.docker.com | sh) & spinner3

    if echo $var_install_docker | grep -q "Syntax OK"; then
        echo " 🅳🅾🅲🅺🅴🆁 🅸🆂 🅾🅺 .continue ..."
        echo ""
        echo ""
    else
        echo "【﻿ｅｒｒｏｒ】 Install docker. i can't continue"
        echo "please you fixed error."
	        read -rp "Do you want to run again? (Y/n): " consent
	        case "$consent" in
		    [Yy]* ) 
		        echo "Proceeding run again the script..."
		        rtt_instller
		        ;;
		    [Nn]* ) 
		        echo "Script terminated by the user."
		        exit 0
		        ;;
		    * ) 
		        echo "Invalid input. Script will exit."
		        exit 1
		        ;;
			esac

        
    fi
    exit 1;
}

initial_node(){
    echo "

█▀▀█ 
──▀▄ 
█▄▄█ 🆂🆃🅰🆁🆃 initial node"
    echo "   "
    # if  Marzban-node exist only remove docker
        # [ ! -d "/etc/" ] && echo "Not Found" || echo "Found."
        if [ ! -d /root/Marzban-node ]; then
            echo "niiiiiistt mazrban-node"
            git clone https://github.com/Gozargah/Marzban-node
            mkdir /var/lib/marzban-node
            # mkdir /root/Marzban-node
            # rm docker-compose.yml
        else 
             if [ -d /root/Marzban-node/docker-compose.yml ]; then 
                rm /root/Marzban-node/docker-compose.yml
            else
                touch /root/Marzban-node/docker-compose.yml
             fi
        fi

        echo "initial is OK"
        echo $GREEN; printf -- "-%.0s" $(seq $(tput cols)); echo $RESET

}

make_docker_compose(){
    echo " 

█░█
▀▀█ 🆂🆃🅰🆁🆃 docker compose generate "
    # $ printf "This overwrites your file" > /Marzban-node/docker-compose.yml
# echo -e "line1\nline2" > /root/Marzban-node/docker-compose.yml
echo -e "services:
  marzban-node:
    # build: .
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host

    environment:
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"

    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node" > /root/Marzban-node/docker-compose.yml
      echo ""
      echo "docker compose is OK"
      echo $GREEN; printf -- "-%.0s" $(seq $(tput cols)); echo $RESET

}

get_client_ssl_user(){
    echo "

█▀
▄█  🆂🆃🅰🆁🆃 get certificate from user"

    echo ""
    # echo " please paste certificate code from marzban panel: "
    # read certificate_code
    # read -p "please paste certificate code from marzban panel: " certificate_code
    read -rp 'please paste certificate code from marzban panel(CTRL + C) AND after press CTRL + D:' -d $'\04' certificate_code
    # declare -p certificate_code 
    # sed '{/pattern/|/regexp/|n}{i|a|c}<$certificate_code>' certificate_code



    if [[ -n "$certificate_code" ]]; then
        # echo "Variable is not empty\n "
        # echo "$certificate_code"
        set_client_cert
    else
        echo $YELLOW error: please paste certificate code from panel marzban here $RESET
        echo ""
        get_client_ssl_user  
    fi
    # echo "The Current User Name is\n $certificate_code"
}
get_client_ssl_user2(){
        echo "

█▀
▄█  🆂🆃🅰🆁🆃 get certificate from user"

    echo ""
    echo "Please paste the content of the Client Certificate, press ENTER on a new line when finished:"
    echo ""

    certificate_code=""
    while IFS= read -r line
    do
        if [[ -z $line ]]; then
            break
        fi
        certificate_code+="$line\n"
    done
    set_client_cert
    # echo -e "$certificate_code" | sudo tee /var/lib/marzban-node/$panel.pem > /dev/null

}

set_client_cert(){
    echo ""
    # echo "$certificate_code" 
    echo -e "$certificate_code" > /var/lib/marzban-node/ssl_client_cert.pem

    echo "set client cert is OK"
    echo $GREEN; printf -- "-%.0s" $(seq $(tput cols)); echo $RESET
    # sleep 1;
    composer_compile & spinner3
}

composer_compile(){
    echo "

█▄▄
█▄█ 🆂🆃🅰🆁🆃 compile docker compose "
    echo ""
    echo ""
    echo "start docker compose container. please wait..."
    sudo systemctl restart docker
    cd /root/Marzban-node/
    docker compose up -d & spinner3
    echo ""
    echo "docker compile is OK"
    echo $GREEN; printf -- "-%.0s" $(seq $(tput cols)); echo $RESET
    # printf %"$COLUMNS"s |tr " " "-"

}

show_spinner(){
for i in {001..100}; do
    sleep 1
    printf "\r $i"
done
}
show_spinner2(){
/usr/bin/scp me@website.com:file somewhere 2>/dev/null &
pid=$! # Process Id of the previous running command

spin='-\|/'

i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}"
  sleep .1
done
}
spinner3()
{
    local pid=$!
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

progreSh() {
    LR='\033[1;31m'
    LG='\033[1;32m'
    LY='\033[1;33m'
    LC='\033[1;36m'
    LW='\033[1;37m'
    NC='\033[0m'
    if [ "${1}" = "0" ]; then TME=$(date +"%s"); fi
    SEC=`printf "%04d\n" $(($(date +"%s")-${TME}))`; SEC="$SEC sec"
    PRC=`printf "%.0f" ${1}`
    SHW=`printf "%3d\n" ${PRC}`
    LNE=`printf "%.0f" $((${PRC}/2))`
    LRR=`printf "%.0f" $((${PRC}/2-12))`; if [ ${LRR} -le 0 ]; then LRR=0; fi;
    LYY=`printf "%.0f" $((${PRC}/2-24))`; if [ ${LYY} -le 0 ]; then LYY=0; fi;
    LCC=`printf "%.0f" $((${PRC}/2-36))`; if [ ${LCC} -le 0 ]; then LCC=0; fi;
    LGG=`printf "%.0f" $((${PRC}/2-48))`; if [ ${LGG} -le 0 ]; then LGG=0; fi;
    LRR_=""
    LYY_=""
    LCC_=""
    LGG_=""
    for ((i=1;i<=13;i++))
    do
        DOTS=""; for ((ii=${i};ii<13;ii++)); do DOTS="${DOTS}."; done
        if [ ${i} -le ${LNE} ]; then LRR_="${LRR_}#"; else LRR_="${LRR_}."; fi
        echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${DOTS}${LY}............${LC}............${LG}............ ${SHW}%${NC}\r"
        if [ ${LNE} -ge 1 ]; then sleep .05; fi
    done
    for ((i=14;i<=25;i++))
    do
        DOTS=""; for ((ii=${i};ii<25;ii++)); do DOTS="${DOTS}."; done
        if [ ${i} -le ${LNE} ]; then LYY_="${LYY_}#"; else LYY_="${LYY_}."; fi
        echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${DOTS}${LC}............${LG}............ ${SHW}%${NC}\r"
        if [ ${LNE} -ge 14 ]; then sleep .05; fi
    done
    for ((i=26;i<=37;i++))
    do
        DOTS=""; for ((ii=${i};ii<37;ii++)); do DOTS="${DOTS}."; done
        if [ ${i} -le ${LNE} ]; then LCC_="${LCC_}#"; else LCC_="${LCC_}."; fi
        echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${DOTS}${LG}............ ${SHW}%${NC}\r"
        if [ ${LNE} -ge 26 ]; then sleep .05; fi
    done
    for ((i=38;i<=49;i++))
    do
        DOTS=""; for ((ii=${i};ii<49;ii++)); do DOTS="${DOTS}."; done
        if [ ${i} -le ${LNE} ]; then LGG_="${LGG_}#"; else LGG_="${LGG_}."; fi
        echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${LG}${LGG_}${DOTS} ${SHW}%${NC}\r"
        if [ ${LNE} -ge 38 ]; then sleep .05; fi
    done
}


valid_os
update_upgrade_server
# check_docker
# install_docker
initial_node
make_docker_compose 
get_client_ssl_user2
# set_client_cert
# rtt_instller

echo ""
echo ""
echo "
███████╗██╗███╗░░██╗██╗░██████╗██╗░░██╗███████╗██████╗░
██╔════╝██║████╗░██║██║██╔════╝██║░░██║██╔════╝██╔══██╗
█████╗░░██║██╔██╗██║██║╚█████╗░███████║█████╗░░██║░░██║
██╔══╝░░██║██║╚████║██║░╚═══██╗██╔══██║██╔══╝░░██║░░██║
██║░░░░░██║██║░╚███║██║██████╔╝██║░░██║███████╗██████╔╝
╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝╚═════╝░╚═╝░░╚═╝╚══════╝╚═════╝░"
echo ""
echo "🄵🄸🄽🄸🅂🄷🄴🄳! Go back to marzban panel and click button Update Node to connected."; 
echo ""
echo ""
# exit ;;