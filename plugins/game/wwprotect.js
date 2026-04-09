const { nightActionHandler } = require('./werewolf')
const te = require('../../src/lib/ourin-error')

const pluginConfig = {
    name: 'wwprotect',
    alias: ['protect', 'guardian', 'wpr'],
    category: 'game',
    description: 'Guardian night action - Protect target',
    usage: '.wwprotect <nomor>',
    example: '.wwprotect 3',
    isOwner: false,
    isPremium: false,
    isGroup: false,
    isPrivate: true,
    cooldown: 0,
    energi: 0,
    isEnabled: true
}

async function handler(m, { sock }) {
    try {
        return await nightActionHandler(m, { sock })
    } catch (error) {
        console.error('[WWPROTECT ERROR]', error)
        m.reply(te(m.prefix, m.command, m.pushName))
    }
}

module.exports = {
    config: pluginConfig,
    handler
}
