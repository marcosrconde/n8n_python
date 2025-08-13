FROM n8nio/n8n:latest

# Troca para root para instalar pacotes
USER root

# Instala Python e dependências para Playwright
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv \
    && pip3 install --no-cache-dir playwright \
    && playwright install --with-deps chromium

# Cria diretório para scripts
RUN mkdir -p /scripts
COPY baixar_pdf.py /scripts/baixar_pdf.py
RUN chmod +x /scripts/baixar_pdf.py

# Retorna para o usuário padrão do n8n
USER node
