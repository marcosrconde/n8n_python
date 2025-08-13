FROM n8nio/n8n:latest

USER root

# Atualiza e instala Python + pip no Alpine
RUN apk add --no-cache python3 py3-pip python3-dev build-base

# Instala venv
RUN python3 -m ensurepip
RUN pip3 install --upgrade pip

# Instala Playwright
RUN pip3 install playwright
RUN playwright install --with-deps chromium

RUN mkdir -p /scripts
COPY baixar_pdf.py /scripts/baixar_pdf.py
RUN chmod +x /scripts/baixar_pdf.py
