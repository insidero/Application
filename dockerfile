# syntax=docker/dockerfile:experimental
FROM node:8.11.4-alpine as base

#create new user
ENV USER=wahaj
RUN adduser -D -u 1001 $USER 

#second container
FROM base as build
WORKDIR /home/$USER
COPY node-easy-notes-app /home/$USER 
RUN npm install
RUN chown -R $USER:$USER /home/$USER/

#third container
FROM base
COPY --from=build /home/$USER /home/$USER
USER $USER
WORKDIR /home/$USER
CMD node server.js

