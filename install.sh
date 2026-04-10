#!/usr/bin/env bash

W='\033[1;37m'
G='\033[1;32m'
R='\033[1;31m'
Y='\033[1;33m'
C='\033[1;36m'
P='\033[1;35m'
B='\033[1;34m'
DIM='\033[2m'
NC='\033[0m'

clear

echo -e "${P}"
cat << "EOF"
  ██████╗ ██╗   ██╗██████╗ ██╗███╗   ██╗    ███╗   ███╗██████╗ 
 ██╔═══██╗██║   ██║██╔══██╗██║████╗  ██║    ████╗ ████║██╔══██╗
 ██║   ██║██║   ██║██████╔╝██║██╔██╗ ██║    ██╔████╔██║██║  ██║
 ██║   ██║██║   ██║██╔══██╗██║██║╚██╗██║    ██║╚██╔╝██║██║  ██║
 ╚██████╔╝╚██████╔╝██║  ██║██║██║ ╚████║    ██║ ╚═╝ ██║██████╔╝
  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    ╚═╝     ╚═╝╚═════╝
EOF
echo -e "${NC}"
echo -e "${DIM}  Auto Installer v2.3.0 — by Zann${NC}"
echo ""

run_step() {
    local label="$1"
    shift
    local cmd="$@"

    printf "${Y}  ⏳  ${W}%-40s${NC}" "$label"

    eval "$cmd" > /tmp/ourin_install.log 2>&1
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        printf "\r${G}  ✅  ${W}%-40s${NC}\n" "$label"
    else
        printf "\r${R}  ❌  ${W}%-40s${NC}\n" "$label"
        echo -e "${R}      └─ Gagal! Cek log: /tmp/ourin_install.log${NC}"
    fi

    return $exit_code
}

echo -e "${C}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${B}  📋  ${W}Mengecek sistem operasi kamu...${NC}"
echo -e "${C}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if command -v pkg &> /dev/null; then
    echo -e "${G}  🤖  ${W}Terdeteksi: ${C}Termux (Android)${NC}"
    echo ""

    run_step "Update repository Termux..." "pkg update -y"
    run_step "Upgrade package lama..." "pkg upgrade -y"
    run_step "Instal Node.js..." "pkg install nodejs -y"
    run_step "Instal FFmpeg..." "pkg install ffmpeg -y"
    run_step "Instal Git..." "pkg install git -y"
    run_step "Instal Python..." "pkg install python -y"
    run_step "Instal C++ Compiler (clang)..." "pkg install clang binutils build-essential -y"
    run_step "Instal libvips (untuk sharp)..." "pkg install libvips -y"

    export npm_config_build_from_source=true

elif command -v apt-get &> /dev/null; then
    echo -e "${G}  🐧  ${W}Terdeteksi: ${C}Ubuntu / Debian / VPS Linux${NC}"
    echo ""

    run_step "Update repository apt..." "sudo apt-get update -y"
    run_step "Instal FFmpeg..." "sudo apt-get install -y ffmpeg"
    run_step "Instal Git..." "sudo apt-get install -y git"
    run_step "Instal Build Tools..." "sudo apt-get install -y build-essential python3 curl"
    run_step "Instal libvips-dev..." "sudo apt-get install -y libvips-dev"

    if ! command -v node &> /dev/null; then
        run_step "Setup repo Node.js 22..." "curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -"
        run_step "Instal Node.js..." "sudo apt-get install -y nodejs"
    fi

elif command -v pacman &> /dev/null; then
    echo -e "${G}  🏗️  ${W}Terdeteksi: ${C}Arch Linux${NC}"
    echo ""

    run_step "Update & upgrade sistem..." "sudo pacman -Syu --noconfirm"
    run_step "Instal Node.js & NPM..." "sudo pacman -S --noconfirm nodejs npm"
    run_step "Instal FFmpeg & Git..." "sudo pacman -S --noconfirm ffmpeg git"
    run_step "Instal Build Tools..." "sudo pacman -S --noconfirm base-devel python vips"
else
    echo -e "${R}  ❌  ${W}OS tidak dikenali. Silakan instal manual:${NC}"
    echo -e "${W}      Node.js >= 22, FFmpeg, Git, Python, libvips${NC}"
    exit 1
fi

echo ""
echo -e "${C}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${B}  🔍  ${W}Verifikasi environment...${NC}"
echo -e "${C}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

NODE_VER=$(node -v 2>/dev/null || echo "tidak ditemukan")
NPM_VER=$(npm -v 2>/dev/null || echo "tidak ditemukan")
GIT_VER=$(git --version 2>/dev/null | awk '{print $3}' || echo "tidak ditemukan")

echo -e "${G}  ✅  ${W}Node.js  : ${C}${NODE_VER}${NC}"
echo -e "${G}  ✅  ${W}NPM      : ${C}v${NPM_VER}${NC}"
echo -e "${G}  ✅  ${W}Git      : ${C}v${GIT_VER}${NC}"

echo ""
echo -e "${C}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${B}  📦  ${W}Menginstal module bot (npm install)...${NC}"
echo -e "${DIM}      Proses ini bisa memakan waktu beberapa menit.${NC}"
echo -e "${C}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

npm install
NPM_EXIT=$?

echo ""

if [ $NPM_EXIT -eq 0 ]; then
    echo -e "${C}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${G}  ✅  INSTALASI SELESAI — BOT SIAP DIJALANKAN${NC}"
    echo -e "${C}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${W}  1. Edit file ${C}config.js${W} (isi nomor WA kamu)${NC}"
    echo -e "${W}  2. Jalankan bot:  ${Y}npm start${NC}"
    echo ""
else
    echo -e "${C}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${R}  ❌  NPM INSTALL GAGAL${NC}"
    echo -e "${C}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${W}  Coba jalankan ulang: ${Y}npm install${NC}"
    echo -e "${W}  Atau laporkan error di GitHub Issues.${NC}"
    echo ""
fi
