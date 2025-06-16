const mineflayer = require('mineflayer');

const bot = mineflayer.createBot({
  host: 'hamlet.aternos.host', // <- try DynIP here
  port: 64020,
  username: 'RailwayBot',
  version: false
});

bot.on('spawn', () => {
  console.log('✅ Bot connected!');
  bot.chat('Hello!');
});

bot.on('kicked', console.log);
bot.on('error', console.log);
