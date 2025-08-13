import argparse
import os
import asyncio
from playwright.async_api import async_playwright

async def baixar_pdf(url, pasta_destino):
    # Cria pasta se não existir
    if not os.path.exists(pasta_destino):
        os.makedirs(pasta_destino)

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context()
        page = await context.new_page()

        # Define headers para simular navegador
        await page.set_extra_http_headers({
            "Referer": "https://venda-imoveis.caixa.gov.br/",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36"
        })

        # Prepara evento de download
        async with page.expect_download() as download_info:
            await page.goto(url)
        download = await download_info.value

        # Define caminho final do arquivo
        nome_arquivo = download.suggested_filename
        caminho_final = os.path.join(pasta_destino, nome_arquivo)

        # Salva o PDF
        await download.save_as(caminho_final)
        await browser.close()

        return caminho_final

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Baixar PDF de matrícula Caixa")
    parser.add_argument("--url", required=True, help="URL do PDF")
    parser.add_argument("--destino", default="/tmp", help="Pasta de destino (default: /tmp)")
    args = parser.parse_args()

    caminho = asyncio.run(baixar_pdf(args.url, args.destino))
    print(caminho)  # Isso será capturado pelo n8n
