#!/bin/bash

# Verificar si el script se ejecuta como root
if [ "$EUID" -ne 0 ]; then
    echo "🔒 Ejecutando el script con sudo..."
    sudo bash "$0"
    exit
fi

# Actualizar el sistema
echo "🔄 Actualizando paquetes del sistema..."
apt update && apt upgrade -y

# Instalar dependencias
echo "📦 Instalando dependencias..."
apt install -y ca-certificates curl gnupg

# Agregar clave GPG de Docker
echo "🔑 Agregando clave GPG de Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Agregar repositorio de Docker
echo "📥 Configurando repositorio de Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list

# Instalar Docker Engine
echo "🐳 Instalando Docker..."
apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

# Agregar usuario al grupo docker
echo "👥 Agregando usuario actual al grupo 'docker'..."
usermod -aG docker $SUDO_USER

# Instalar Docker Compose (plugin)
echo "🎭 Instalando Docker Compose..."
apt install -y docker-compose-plugin

# Verificar instalación
echo "✅ Verificando la instalación..."
sudo -u $SUDO_USER docker run hello-world
sudo -u $SUDO_USER docker compose version

echo "✨ ¡Instalación completada! Reinicia tu sistema."                                                                                                                                                                                                                           