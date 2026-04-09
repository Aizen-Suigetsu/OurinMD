const ttdown = require('../../src/scraper/tiktok')
const config = require('../../config')
const axios = require('axios')
const ffmpeg = require('fluent-ffmpeg')
const ffmpegInstaller = require('@ffmpeg-installer/ffmpeg')
ffmpeg.setFfmpegPath(ffmpegInstaller.path)

const pluginConfig = {
    name: ['ttmp3'],
    alias: ['ttmusic', 'tiktokmusic'],
    category: 'download',
    description: 'Download video TikTok tanpa watermark',
    usage: '.ttmp3 <url>',
    example: '.ttmp3 https://vt.tiktok.com/xxx',
    isOwner: false,
    isPremium: false,
    isGroup: false,
    isPrivate: false,
    cooldown: 10,
    energi: 1,
    isEnabled: true
}

function formatNumber(num) {
    if (!num) return '0'
    const n = parseInt(num)
    if (n >= 1000000) return (n / 1000000).toFixed(1) + 'M'
    if (n >= 1000) return (n / 1000).toFixed(1) + 'K'
    return n.toString()
}

async function handler(m, { sock }) {
  const url = m.text?.trim()

  if (!url) {
    return m.reply(
`╭┈┈⬡「 🎵 *ᴛɪᴋᴛᴏᴋ ᴅᴏᴡɴʟᴏᴀᴅ* 」
┃ ㊗ ᴜsᴀɢᴇ: \`${m.prefix}ttmp3 <url>\`
╰┈┈⬡

> Contoh: ${m.prefix}ttmp3 https://vt.tiktok.com/xxx`
    )
  }

  if (!url.match(/tiktok\.com|vt\.tiktok/i)) {
    return m.reply('❌ URL tidak valid. Gunakan link TikTok.')
  }

  m.react('🕕')

  try {
    const result = await ttdown(url)
    
    const saluranName =
      config.saluran?.name ||
      config.bot?.name ||
      'Ourin-AI'

    const carivideotanpawm = result.downloads.find(d => d.type == 'mp3')
    if (!carivideotanpawm) return m.reply('❌ Video HD tidak ditemukan.')

    await sock.sendMedia(m.chat, carivideotanpawm.url, null, m, {
        type: 'audio',
        mimetype: 'audio/mpeg',
        fileName: `TikTok_Audio_${Date.now()}.mp3`,
        contextInfo: {
            forwardingScore: 99,
            isForwarded: true,
            externalAdReply: {
                title: result.title,
                body: `👤 By \`${result.author.username || '-'}\``,
                thumbnailUrl: result.author?.avatar || result.author?.cover,
                sourceUrl: url,
                mediaUrl: url,
                mediaType: 2,
                renderLargerThumbnail: false,
            }
        }
    })

    m.react('✅')

    // cleanup
    setTimeout(() => {
      if (require('fs').existsSync(result.file)) {
        require('fs').unlinkSync(result.file)
      }
    }, 5000)

  } catch (err) {
    console.error('[TikTokDL] Error:', err)
    m.react('❌')
    m.reply(
      `❌ *ɢᴀɢᴀʟ ᴍᴇɴɢᴜɴᴅᴜʜ*\n\n> ${err.message}`
    )
  }
}

module.exports = {
    config: pluginConfig,
    handler
}
