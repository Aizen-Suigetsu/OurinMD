#!/usr/bin/env bash

# =======================================================
# OURIN MD V2.3.0 - Auto Installer Script
# =======================================================
# Mendukung: Ubuntu/Debian, Termux, & Arch Linux
# =======================================================

echo "Memulai proses instalasi untuk OURIN MD V2.3.0..."

# Deteksi OS / Package Manager
if command -v pkg &> /dev/null; then
    echo "OS / Env Terdeteksi: TERMUX (Android)"
    echo "Memperbarui package list Termux..."
    pkg update -y && pkg upgrade -y
    
    echo "Menginstal dependensi utama (Node.js, FFmpeg, Git, libvips)..."
    pkg install nodejs-lts ffmpeg libvips git build-essential python -y
    
elif command -v apt-get &> /dev/null; then
    echo "OS Terdeteksi: DEBIAN / UBUNTU"
    echo "Memperbarui package list..."
    sudo apt-get update -y
    
    echo "Menginstal dependensi utama (FFmpeg, git, libvips)..."
    sudo apt-get install -y curl ffmpeg libvips-dev build-essential python3 git

    # Cek Node.js
    if ! command -v node &> /dev/null; then
        echo "Node.js belum terinstall! Mengambil instalasi Node.js 22 LTS..."
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        echo "Node.js sudah terinstall: $(node -v)"
    fi

elif command -v pacman &> /dev/null; then
    echo "OS Terdeteksi: ARCH LINUX"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm nodejs npm ffmpeg vips base-devel python git
else
    echo "Package manager tidak didukung oleh script otomatis ini."
    echo "Harap instal manual: Node.js (>=22), FFmpeg, Python, dan Build Essential."
    sleep 3
fi

echo "==============================================="
echo "Menginstal module NPM (ini mungkin butuh beberapa menit)..."
echo "==============================================="

# Install package
npm install

echo "==============================================="
echo "Instalasi selesai! 🎉"
echo "Silakan edit file config.js sesuai kebutuhanmu,"
echo "Lalu jalankan bot dengan perintah:"
echo "   npm start"
echo "==============================================="
