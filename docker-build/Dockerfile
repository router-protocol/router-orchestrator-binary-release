# Build Runner
FROM --platform=linux/amd64 ubuntu:22.04

# Install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y git wget
COPY ../linux/router-orchestrator.tar.gz .

RUN wget https://raw.githubusercontent.com/router-protocol/routerd-libs/main/libwasmvm.x86_64.so
RUN cp libwasmvm.x86_64.so /lib
RUN cp libwasmvm.x86_64.so /lib64

RUN tar -xvf router-orchestrator.tar.gz -C /usr/bin
RUN chmod +x /usr/bin/router-orchestrator
RUN which router-orchestrator

ENV HOME /router
WORKDIR $HOME
EXPOSE 8001
RUN touch .env

# Clean up
RUN apt-get remove -y wget bash --allow-remove-essential && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.ssh && \
    rm /bin/sh

ENTRYPOINT ["router-orchestrator", "start", "--config", "/src/config.json", "--reset"]