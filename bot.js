const mineflayer = require('mineflayer');

function createBot() {
  const bot = mineflayer.createBot({
    host: process.env.MC_HOST || 'localhost',      // IP of the server
    port: parseInt(process.env.MC_PORT) || 25565,  // Port
    username: process.env.MC_USERNAME || 'RailwayBot', // Bot username
    version: false
  });

  bot.on('spawn', () => {
    console.log('Bot has spawned!');
    bot.chat('Hello from Railway!');
  });

  bot.on('chat', (username, message) => {
    if (username === bot.username) return;
    if (message.toLowerCase() === 'hi') {
      bot.chat(`Hi ${username}!`);
    }
  });

  bot.on('error', err => {
    console.log('Error:', err);
  });

  bot.on('end', () => {
    console.log('Disconnected. Reconnecting in 5s...');
    setTimeout(createBot, 5000);
  });
}

createBot();
