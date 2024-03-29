# Use the Ruby 3.1.2 base image
FROM ruby:3.1.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libffi-dev \
    postgresql-client \
    postgresql \
    tzdata \
    redis-server \
    zip \
    git

# Install nodejs 14
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

# Install java
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk

RUN npm install -g create-react-app \
    npm install -g @angular/cli  \
    npm install -g @vue/cli

# Install dotnet
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y apt-transport-https \
    && apt-get update \
    && apt-get install -y dotnet-sdk-6.0

# Rails app lives here
WORKDIR /rails

# Set environment variables
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="1" \
    RAILS_ENV="production" \
    BUNDLE_WITHOUT="development"

# Install the required Ruby gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the application code into the container
COPY . .

# Precompile the assets
RUN bundle exec rails assets:precompile

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

ENTRYPOINT [ "/rails/bin/docker-entrypoint" ]

# Start the main process
EXPOSE 3000
CMD ["./bin/rails", "server"]
