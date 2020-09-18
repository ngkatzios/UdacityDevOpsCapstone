FROM nginx:stable

## Step 1:
# Copy source code to working directory
COPY html/index.html /usr/share/nginx/html
COPY html/background01.jpg /usr/share/nginx/html

## Step 2:
# Expose port 80
EXPOSE 80
