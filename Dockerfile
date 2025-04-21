FROM nginx:alpine

# Create a custom index.html that redirects to blood.html
RUN echo '<meta http-equiv="refresh" content="0;url=/blood.html">' > /usr/share/nginx/html/index.html

# Copy the static website to the nginx html directory
COPY . /usr/share/nginx/html

# Fix permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
