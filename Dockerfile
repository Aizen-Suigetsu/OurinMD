# Gunakan Node.js 22 di atas OS Linux Debian yang paling stabil (bookworm)
# Sangat disarankan untuk mempermudah pemasangan Sharp dan Canvas tanpa kompilasi manual yang abrok
FROM node:22-bookworm

# Persiapkan environment
ENV NODE_ENV=development
ENV TZ=Asia/Jakarta

# Set working directory di dalam container
WORKDIR /app

# Update package manager dan instal dependencies fundamental OS:
# - ffmpeg (Untuk bikin stiker video/audio)
# - libvips-dev (Dukungan penuh untuk library sharp jika butuh recompile)
# - build-essential (Untuk modul native C++ jika ada)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    libvips-dev \
    build-essential \
    python3 \
    git \
    tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy file dependency dlu biar ke-cache Docker dgn baik
COPY package.json ./

# Install npm dependencies
RUN npm install

# Copy seluruh source code ke dalam app
COPY . .

# Berikan akses penuh untuk execute permissions (berjaga-jaga)
RUN chmod -R 777 /app

# Jalankan index.js
CMD ["npm", "start"]
