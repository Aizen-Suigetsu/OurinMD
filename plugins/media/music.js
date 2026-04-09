const axios = require('axios')
const { f } = require('../../src/lib/ourin-http')

const MUSIC_LIST = []
for (let i = 1; i <= 65; i++) {
    MUSIC_LIST.push(`music${i}`)
}

const pluginConfig = {
    name: 'music',
    alias: MUSIC_LIST,
    category: 'media',
    description: 'Koleksi musik 1-65',
    usage: '.music1 sampai .music65',
    example: '.music1',
    isOwner: false,
    isPremium: false,
    isGroup: false,
    isPrivate: false,
    cooldown: 5,
    energi: 0,
    isEnabled: true
}

async function handler(m, { sock, command }) {
    const musicNum = command.replace('music', '')
    const num = parseInt(musicNum)
    
    if (isNaN(num) || num < 1 || num > 65) {
        return m.reply(`🎵 *ᴍᴜsɪᴄ ᴄᴏʟʟᴇᴄᴛɪᴏɴ*\n\n> Tersedia: .music1 - .music65`)
    }
    
    m.react('🕕')
    
    try {
        const musicUrl = `https://github.com/Rez4-3yz/Music-rd/raw/master/music/music${num}.mp3`

        await sock.sendMedia(m.chat, musicUrl, null, m, {
            type: 'audio',
            mimetype: 'audio/mpeg',
            ptt: false
        })
        
        m.react('✅')
        
    } catch (err) {
        m.react('❌')
        m.reply(`❌ *ᴇʀʀᴏʀ*\n\n> Musik tidak ditemukan atau gagal diambil.`)
    }
}

module.exports = {
    config: pluginConfig,
    handler
}
