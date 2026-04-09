const { f } = require('../../src/lib/ourin-http')

const pluginConfig = {
    name: 'ytmp4-zann',
    alias: ['youtubemp4-zann', 'ytvideo-zann'],
    category: 'download',
    description: 'Download video YouTube',
    usage: '.ytmp4-zann <url>',
    example: '.ytmp4-zann https://youtube.com/watch?v=xxx',
    cooldown: 20,
    energi: 2,
    isEnabled: true
}

async function handler(m, { sock }) {
    const [url, resolusi] = m.text.split(' ')
    if (!url || !resolusi) return m.reply(`Contoh: ${m.prefix}ytmp4 https://youtube.com/watch?v=xxx`)
    if (!url.includes('youtube.com') && !url.includes('youtu.be')) return m.reply('❌ URL harus YouTube')

    m.react('🕕')

    try {
        const { result } = await f(`https://api.nexray.web.id/downloader/ytmp4?url=${encodeURIComponent(url)}&resolusi=${resolusi}`)
        await sock.sendMedia(m.chat, result?.url, null, m, {
            type: 'video'
        })
        m.react('✅')

    } catch (err) {
        console.error('[YTMP4]', err)
        m.react('❌')
        m.reply('Gagal mengunduh video. silahkan coba lagi')
    }
}

module.exports = {
    config: pluginConfig,
    handler
}