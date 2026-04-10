#!/usr/bin/env bash

CYAN='\033[0;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
NC='\033[0m'

clear

echo -e "${PURPLE}"
cat << "EOF"
  ██████╗ ██████╗ ██████╗ ██╗███╗   ██╗    ███╗   ███╗██████╗
 ██╔═══██╗██╔══██╗██╔═══██╗██║████╗  ██║    ████╗ ████║██╔══██╗
 ██║   ██║██║  ██║██████╔╝██║██╔██╗ ██║    ██╔████╔██║██║  ██║
 ██║   ██║██║  ██║██╔══██╗██║██║╚██╗██║    ██║╚██╔╝██║██║  ██║
 ╚██████╔╝╚██████╔╝██║  ██║██║██║ ╚████║    ██║ ╚═╝ ██║██████╔╝
  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    ╚═╝     ╚═╝╚═════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}[*] Menyiapkan auto installer...${NC}"
sleep 1

spinner() {
    local pid=$1
    local delay=0.1
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

LOADING_TEXT="[!] Mengecek sistem operasi kamu"
echo -n -e "${YELLOW}${LOADING_TEXT}${NC}"
sleep 2 & spinner $!
echo -e "\n${GREEN}[✔] Sistem berhasil dikenali${NC}\n"

if command -v pkg &> /dev/null; then
    echo -e "${CYAN}[*] Tipe OS: Termux (Android)${NC}"
    
    echo -e "${YELLOW}[!] Sedang memperbarui package Termux...${NC}"
    pkg update -y > /dev/null 2>&1 & spinner $!
    pkg upgrade -y > /dev/null 2>&1 & spinner $!
    
    echo -e "${YELLOW}[!] Menginstal package pendukung (Nodejs, FFmpeg, dll)...${NC}"
    pkg install nodejs-lts ffmpeg libvips git build-essential python -y > /dev/null 2>&1 & spinner $!
    
elif command -v apt-get &> /dev/null; then
    echo -e "${CYAN}[*] Tipe OS: Ubuntu / Debian / VPS Linux${NC}"
    
    echo -e "${YELLOW}[!] Sedang memperbarui package apt dasar...${NC}"
    sudo apt-get update -y > /dev/null 2>&1 & spinner $!
    
    echo -e "${YELLOW}[!] Menginstal package pendukung utama...${NC}"
    sudo apt-get install -y curl ffmpeg libvips-dev build-essential python3 git > /dev/null 2>&1 & spinner $!

    if ! command -v node &> /dev/null; then
        echo -e "${YELLOW}[!] Menginstal Node.js versi 22...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - > /dev/null 2>&1 & spinner $!
        sudo apt-get install -y nodejs > /dev/null 2>&1 & spinner $!
    fi

elif command -v pacman &> /dev/null; then
    echo -e "${CYAN}[*] Tipe OS: Arch Linux${NC}"
    sudo pacman -Syu --noconfirm > /dev/null 2>&1 & spinner $!
    sudo pacman -S --noconfirm nodejs npm ffmpeg vips base-devel python git > /dev/null 2>&1 & spinner $!
else
    echo -e "${RED}[X] OS tidak dikenali! Tolong instal manual.${NC}"
    sleep 2
    exit 1
fi

echo -e "${GREEN}[✔] Semua package pendukung telah berhasil diinstal!${NC}\n"

echo -e "${CYAN}[*] Sedang mendownload dan menginstal module bot (NPM)...${NC}"
npm install & spinner $!

echo -e "\n${PURPLE}===============================================${NC}"
echo -e "${GREEN}    [✔] INSTALASI SELESAI [✔]    ${NC}"
echo -e "${PURPLE}===============================================${NC}"
echo -e "${CYAN}    Silakan ubah nomor kamu di file config.js  ${NC}"
echo -e "${CYAN}    Setelah itu, nyalakan bot dengan ketik:    ${NC}"
echo -e "${YELLOW}                 npm start                     ${NC}"
echo -e "${PURPLE}===============================================${NC}\n"
