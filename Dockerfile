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
