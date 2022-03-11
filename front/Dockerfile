FROM node:15.14-alpine as build
WORKDIR /2021.2-G2_Solaire_Disciples_Logical_Hospital_Triage/front
ENV PATH /2021.2-G2_Solaire_Disciples_Logical_Hospital_Triage/front/node_modules/.bin:$PATH
COPY package*.json ./
RUN npm install --silent
RUN npm install react-scripts@3.3.1 -g --silent

CMD ["npm", "start"]
