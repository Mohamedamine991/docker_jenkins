# Step 1: Use an official Node.js runtime as a parent image
FROM node:latest as build

# Step 2: Set the working directory in the container
WORKDIR /usr/src/app

# Step 3: Copy the package.json and package-lock.json (if available)
COPY package*.json ./

# Step 4: Install any needed packages
RUN npm install

# Step 5: Copy the rest of your app's source code
COPY . .

# Step 6: Build your app
RUN npm run build

# Step 7: Use nginx to serve the React application
FROM nginx:alpine

# Step 8: Copy built assets from build stage to nginx serving directory
COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Step 9: Expose port 80 to the outside once the container has launched
EXPOSE 80

# Step 10: Start nginx
CMD ["nginx", "-g", "daemon off;"]
