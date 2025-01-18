# Stage 1: Build the Flutter web app
FROM ghcr.io/cirruslabs/flutter:3.27.2 AS build

# Set working directory inside the container
WORKDIR /app

# Copy the entire Flutter project to the container
COPY . .

# Install Flutter dependencies
RUN flutter pub get

# Build the Flutter web app in release mode
RUN flutter build web --dart-define=ENVIRONMENT=production

# Stage 2: Serve the built web app with Nginx
FROM nginx:alpine

# Copy the built web app from the first stage to the Nginx container
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
