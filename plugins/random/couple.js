const config = require('../../config');
const { downloadMediaMessage } = require('ourin');
const fs = require('fs');
const { default: axios } = require('axios');
const te = require('../../src/lib/ourin-error')

const pluginConfig = {
    name: 'ppcouple',
    alias: ['cp', 'ppcp'],
    category: 'random',
    description: 'Random gambar pp couple',
    usage: '.ppcouple',
    isGroup: true,
    isBotAdmin: false,
    isAdmin: false,
    cooldown: 10,
    energi: 2,
    isEnabled: true
};

async function handler(m, { sock }) {
   try {
        const res = await axios.get(`https://api.deline.web.id/random/ppcouple`)
        const data = res.data.result
        const cowo = data.cowo
        const cewe = data.cewe
        await sock.sendMessage(m.chat, {
            albumMessage: [
                {
                    image: { url: cowo },
                },
                {
                    image: { url: cewe },
                }
            ]
        }, { quoted: m })
   } catch (error) {
    m.reply(te(m.prefix, m.command, m.pushName))
   }
}

module.exports = {
    config: pluginConfig,
    handler
};
