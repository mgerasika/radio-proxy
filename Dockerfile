# Use the official Node.js image as the base image
FROM node:18

ARG PORT

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy tsconfig.json
COPY tsconfig.json ./

# Copy the rest of the application code
COPY ./src ./src

# Install TypeScript globally
RUN yarn global add typescript

# Compile TypeScript to JavaScript
RUN tsc

# Expose the port the app runs on
EXPOSE ${PORT}

# Start the application
CMD ["node", "dist/index.js"]
