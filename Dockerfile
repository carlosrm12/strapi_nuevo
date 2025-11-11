# Etapa 1: Construir el panel de admin
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# ---
# Etapa 2: Imagen de producción final (limpia)
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production

# Instalar solo dependencias de PRODUCCIÓN
COPY package.json package-lock.json ./
RUN npm install --only=production

# Copiar los artefactos y el código de la app desde la etapa 'build'
COPY --from=build /app/build ./build
COPY --from=build /app/config ./config
COPY --from=build /app/src ./src

# Exponer el puerto de Strapi
EXPOSE 1337

# Comando para iniciar Strapi en modo producción
CMD ["npm", "run", "start"]
