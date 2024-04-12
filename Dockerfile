FROM ubuntu:22.04

RUN apt update -y && apt upgrade -y && apt install curl git jq libicu70 unzip wget apt-transport-https software-properties-common -y

# Download the Microsoft repository keys
RUN wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb

# Register the Microsoft repository keys
RUN dpkg -i packages-microsoft-prod.deb

# Delete the Microsoft repository keys file
RUN rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com
RUN apt-get update -y && apt install -y powershell

# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT ./start.sh