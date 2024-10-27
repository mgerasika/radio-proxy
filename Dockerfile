# Use the official Node.js image as the base image
FROM node:18

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of the application code
COPY ./src ./src

# Expose the port the app runs on
EXPOSE 8002

# Start the application
CMD ["yarn", "dev"]
