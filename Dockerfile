FROM php:8-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nano \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Setting default editor
RUN export EDITOR=/usr/bin/nano

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Install NodeJs
RUN apt install nodejs -y && apt install npm -y

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www

USER $user