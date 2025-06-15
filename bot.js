const mineflayer = require('mineflayer');

function createBot() {
  const bot = mineflayer.createBot({
    host: 'sharrysidhu.aternos.me', // Your Aternos IP
    port: 64020,                    // Your Aternos port
    username: 'RailwayBot',        // Bot username (can be anything for cracked servers)
    version: false
  });

  bot.on('spawn', () => {
    console.log('✅ Bot connected!');
    bot.chat('Hello from Railway!');
  });

  bot.on('error', err => {
    console.log('❌ Error:', err);
  });

  bot.on('end', () => {
    console.log('🔁 Bot disconnected. Reconnecting in 5s...');
    setTimeout(createBot, 5000);
  });
}

createBot();
