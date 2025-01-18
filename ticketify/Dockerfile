# Stage 1: Serve the built web app with Nginx
FROM nginx:alpine

# Copy the pre-built web app from local machine to Nginx container
COPY ./build/web /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
