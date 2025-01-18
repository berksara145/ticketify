# Step 1: Build the Flutter web app
FROM cirrusci/flutter:stable AS build

# Create a non-root user and set the working directory
RUN useradd -ms /bin/bash flutteruser
WORKDIR /home/flutteruser/ticketify

# Switch to the non-root user
USER flutteruser

# Fix the permissions for the Flutter SDK cache (no sudo required as we're root by default)
RUN chown -R flutteruser:flutteruser /sdks/flutter/bin/cache

# Add the Flutter SDK directory as safe to resolve git ownership issue
RUN git config --global --add safe.directory /sdks/flutter

# Fetch dependencies and build the Flutter web app
RUN flutter pub get
RUN flutter build web

# Step 2: Serve the built app using Nginx
FROM nginx:alpine

# Copy the built web app from the Flutter build container
COPY --from=build /home/flutteruser/ticketify/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]