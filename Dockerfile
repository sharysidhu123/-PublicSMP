FROM ubuntu:22.04

# Avoid user prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt update && apt install -y \
    openjdk-17-jre-headless \
    curl wget sudo screen \
    ttyd nano unzip iputils-ping net-tools && \
    apt clean

# Create non-root user for security
RUN useradd -ms /bin/bash minecraft && echo "minecraft ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER minecraft
WORKDIR /home/minecraft

# Download and prepare Paper server
RUN mkdir server && cd server && \
    curl -L -o paper.jar https://api.papermc.io/v2/projects/paper/versions/1.21.4/builds/1/downloads/paper-1.21.4-1.jar && \
    echo "eula=true" > eula.txt

# Create start script
RUN echo '#!/bin/bash\ncd ~/server\njava -Xms1G -Xmx2G -jar paper.jar nogui' > ~/start.sh && chmod +x ~/start.sh

# Expose Minecraft and web terminal ports
EXPOSE 25565 6080

# Start Minecraft in a detached screen and ttyd in foreground
CMD screen -dmS mc bash ~/start.sh && ttyd -p 6080 bash
