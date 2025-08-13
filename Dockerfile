FROM n8nio/n8n:latest

USER root

RUN apk add --no-cache python3 py3-pip build-base

# Cria venv e ativa via ENV PATH
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip
RUN pip install playwright
RUN playwright install --with-deps chromium

RUN mkdir -p /scripts
COPY baixar_pdf.py /scripts/baixar_pdf.py
RUN chmod +x /scripts/baixar_pdf.py

USER node
