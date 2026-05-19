# Instalación de dependencias limpias
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./

# Se usa npm ci ya que es más estricto y rápido para entornos de producción/CI-CD (a comparacion de npm install)
RUN npm ci --only=production

# Imagen final ultra ligera
FROM node:18-alpine
WORKDIR /app

# Dependencias necesarias para la app copiadas desde la etapa anterior
COPY --from=builder /app/node_modules ./node_modules
COPY . .

# Aqui se usa el el usuario 'node' que ya viene creado en Alpine (con el No-Root)
USER node

EXPOSE 3001
CMD ["npm", "start"]