# Imagem base Node.js Debian para maior compatibilidade
FROM node:18-bullseye

# Instala Python3, pip e dependências do Chromium e build tools
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv wget curl build-essential \
    libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libx11-xcb1 libxcomposite1 \
    libxdamage1 libxrandr2 libgbm1 libasound2 libpangocairo-1.0-0 libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

# Instala o n8n globalmente
RUN npm install -g n8n

# Cria um virtualenv para python e usa ele
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Atualiza pip e instala playwright e dependências
RUN pip install --upgrade pip
RUN pip install playwright
RUN playwright install --with-deps chromium

# Cria diretório para scripts e copia seu script
RUN mkdir -p /scripts
COPY baixar_pdf.py /scripts/baixar_pdf.py
RUN chmod +x /scripts/baixar_pdf.py

# Usuário padrão n8n
USER node

# Expõe a porta padrão
EXPOSE 5678

# Comando padrão para rodar n8n
CMD ["n8n"]
