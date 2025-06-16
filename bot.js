const mineflayer = require('mineflayer');

function createBot() {
  const bot = mineflayer.createBot({
    host: 'sharrysidhu.aternos.me',
    port: 64020,
    username: 'RailwayBot',  // Use any name (if cracked mode ON)
    version: false
  });

  bot.on('spawn', () => {
    console.log('✅ Bot connected and spawned.');
    bot.chat('Hello! Bot is online.');
  });

  bot.on('kicked', (reason) => {
    console.log('❌ Kicked from server:', reason);
  });

  bot.on('error', err => {
    console.log('❌ Error:', err.message);
    console.error(err);
  });

  bot.on('end', () => {
    console.log('🔁 Disconnected. Reconnecting in 5s...');
    setTimeout(createBot, 5000);
  });
}

createBot();
