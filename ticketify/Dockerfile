# Step 1: Build the Flutter web app
FROM cirrusci/flutter:stable AS build

WORKDIR /app

COPY ./ticketify /app

RUN flutter pub get
RUN flutter build web

# Step 2: Serve the built app using Nginx
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
