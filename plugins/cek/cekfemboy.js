const cekfemboy = require('../../src/scraper/lufemboy')
const { fetchBuffer } = require('../../src/lib/ourin-utils')
const te = require('../../src/lib/ourin-error')

const pluginConfig = {
    name: 'cekfemboy',
    alias: ['femboy'],
    category: 'cek',
    description: 'Cek seberapa femboy kamu',
    usage: '.cekfemboy <nama>',
    example: '.cekfemboy Budi',
    isOwner: false,
    isPremium: false,
    isGroup: false,
    isPrivate: false,
    cooldown: 5,
    energi: 0,
    isEnabled: true
}

async function handler(m, { sock }) {
    const percent = Math.floor(Math.random() * 101)
    const mentioned = m.mentionedJid[0] || m.sender
            try {
        const result = cekfemboy(nama)
        
        let buffer = null
        try {
            buffer = await fetchBuffer(result.gif)
        } catch (e) {}
        
        let txt = mentioned === m.sender ? `Hai @${mentioned.split('@')[0]}
    
Tingkat kefemboyan kamu *${percent}%*
\`\`\`${desc}\`\`\`` : `Kamu ingin ngecek tingkat kefemboyan @${mentioned.split('@')[0]} yak? 
    
Tingkat kefemboyan dia sebesar *${percent}%*
\`\`\`${desc}\`\`\``
    
    await m.reply(txt, { mentions: [mentioned] })
        
        
    } catch (err) {
        return m.reply(te(m.prefix, m.command, m.pushName))
    }
}

module.exports = {
    config: pluginConfig,
    handler
}
