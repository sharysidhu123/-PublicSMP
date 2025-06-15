# Use Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files first (for caching install layers)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the bot files
COPY . .

# Set environment variables if needed (optional)
# ENV MC_HOST=example.com
# ENV MC_PORT=25565
# ENV MC_USERNAME=RailwayBot

# Start the bot
CMD ["npm", "start"]
