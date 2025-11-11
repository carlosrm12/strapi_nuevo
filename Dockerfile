# Etapa 1: Construir la aplicación
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# ---
# Etapa 2: Imagen de producción final
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app/dist ./dist
COPY --from=build /app/build ./build
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/package-lock.json ./package-lock.json
COPY --from=build /app/node_modules ./node_modules

# Exponer el puerto de Strapi
EXPOSE 1337

# Comando para iniciar Strapi en modo producción
CMD ["npm", "run", "start"]
