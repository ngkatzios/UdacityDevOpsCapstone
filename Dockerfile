FROM nginx:stable

## Step 1:
# Copy index.html to nginx directory
COPY html/index.html /usr/share/nginx/html
COP html/background01.jpg /usr/share/nginx/html

## Step 2:
# Expose port 80
EXPOSE 80