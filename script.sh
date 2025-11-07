#!/bin/bash
# ============================================
# go.sh — Script principal do projeto SGM
# ============================================
# 1) Cria o ambiente Conda (Pratica3)
# 2) Cria a estrutura de diretórios do projeto
# 3) Faz download do genoma (.fna.gz)
# 4) Verifica o Prokka (instalado via Conda)
# 5) Executa o Makefile
# ============================================

set -e
ENV_NAME="Pratica3"

echo "==============================================="
echo "[1/5] Verificação e criação do ambiente Conda"
echo "==============================================="

# Verifica se o conda está instalado
if ! command -v conda &> /dev/null; then
    echo " Conda não encontrado!"
    echo "Instala primeiro o Miniconda ou Anaconda e volta a correr este script."
    exit 1
fi

# Recriar ambiente (reprodutibilidade total)
if conda info --envs | grep -q "$ENV_NAME"; then
    echo "Ambiente '$ENV_NAME' já existe. A remover..."
    conda env remove -n "$ENV_NAME" -y
fi

echo "A criar o ambiente Conda '$ENV_NAME' com o Prokka..."
conda create -n "$ENV_NAME" -c bioconda -c conda-forge prokka wget -y

# Ativar Conda corretamente dentro do script
eval "$($(conda info --base)/bin/conda shell.bash hook)"
conda activate "$ENV_NAME"
echo " Ambiente '$ENV_NAME' ativo."

# ==========================================
echo ""
echo "=========================================="
echo "[2/5] Criar estrutura de diretórios"
echo "=========================================="

mkdir -p projeto/{raw_data,cleaned_data,annotation_results}
echo "Estrutura criada:"
tree -d projeto 2>/dev/null || find projeto -type d

# ==========================================
echo ""
echo "=========================================="
echo "[3/5]()
