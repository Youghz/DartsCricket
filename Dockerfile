# Use the specified Flutter image as the base image
FROM ghcr.io/cirruslabs/flutter:3.24.1 as build

# Set the working directory inside the container
WORKDIR /app

# Copy the pubspec.yaml and pubspec.lock files to the container, and get dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the entire project to the container
COPY . .

# Build the web version of the Flutter app
RUN flutter build web

# Use Nginx as the server to serve the built Flutter web app
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
