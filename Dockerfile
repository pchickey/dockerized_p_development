FROM ubuntu:bionic

# This env variable makes sure installing the tzdata package doesn't hang in prompt
ENV DEBIAN_FRONTEND=noninteractive

# Prerequisites
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    apt-transport-https \
    git \
    default-jre \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Install ms deb servers
RUN curl -sSLO https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

# install dotnet 3.1 sdk and runtime
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    dotnet-sdk-3.1 \
    aspnetcore-runtime-3.1 \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --recursive https://github.com/p-org/p

RUN cd p/Bld \
    && ./build.sh

# install via some wrapper scripts
RUN echo "#!/bin/bash" > /usr/local/bin/pc \
    && echo "dotnet /p/Bld/Drops/Release/Binaries/netcoreapp3.1/P.dll \"\$@\"" >> /usr/local/bin/pc \
    && chmod +x /usr/local/bin/pc \
    && echo "#!/bin/bash" > /usr/local/bin/pmc \
    && echo "dotnet /p/packages/microsoft.coyote/1.0.5/lib/netcoreapp3.1/coyote.dll test \"\$@\"" >> /usr/local/bin/pmc \
    && chmod +x /usr/local/bin/pmc

# smoke test.
RUN pc --help
# no smoke test for pmc - it seems to exit 1 when you pass it --version or --?
