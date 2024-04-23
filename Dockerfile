

# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:latest

# Set non-interactive mode for package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    libssl-dev \
    python3 \
    python3-pip \
    python3-dev \
    nodejs \
    npm \
    postgresql \
    postgresql-contrib \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --no-cache-dir \
    flask \
    requests \
    beautifulsoup4 \
    && rm -rf /root/.cache/pip

# Install Node.js packages
RUN npm install -g \
    nodemon \
    express \
    && rm -rf /root/.npm/_cacache

# Install Ruby packages
RUN gem install -g \
    bundler \
    && rm -rf /root/.gem/cache

# Install Elixir packages
RUN wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_23.2~ubuntu~20.04_amd64.deb && \
    dpkg -i esl-erlang_23.2~ubuntu~20.04_amd64.deb && \
    rm esl-erlang_23.2~ubuntu~20.04_amd64.deb

# Install Elixir
RUN wget https://github.com/elixir-lang/elixir/releases/download/v1.11.2/Precompiled.zip && \
    unzip Precompiled.zip && \
    mv elixir /usr/local/bin/ && \
    rm Precompiled.zip

# Install Go packages
RUN wget https://golang.org/dl/go1.17.2.linux-amd64.tar.gz && \
    tar -xvf go1.17.2.linux-amd64.tar.gz && \
    mv go /usr/local/ && \
    rm go1.17.2.linux-amd64.tar.gz

# Set environment variables
ENV PATH=/usr/local/go/bin:$PATH
ENV PATH=/usr/local/bin/elixir:$PATH

# Switch to non-root user
RUN addgroup --system app && adduser --system --group app
USER app

# Set working directory
WORKDIR /app

# Copy source code
COPY . .

# Expose ports
EXPOSE 8000 4000 5000

# Set entrypoint
ENTRYPOINT ["bash", "-l", "-c"]
