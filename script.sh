#!/bin/bash
# ============================================
# go.sh — Script principal do projeto SGM
# ============================================
# 1) Criação do ambiente Conda (Pratica3)
# 2) Criação da estrutura de diretórios
# 3) Instalação do Prokka (via Conda)
# 4) Download do ficheiro genómico (.fna.gz)
# ============================================

set -e
ENV_NAME="Pratica3"

echo "=========================================="
echo "[1/4] Criação do ambiente Conda"
echo "=========================================="

# Verificar se conda está instalado
if ! command -v conda &> /dev/null; then
    echo "Conda não encontrado. Instala Miniconda ou Anaconda e tenta novamente."
    exit 1
fi

# Ativar o hook do conda
eval "$($(conda info --base)/bin/conda shell.bash hook)"

# Remover ambiente antigo (se existir)
if conda info --envs | grep -q "^$ENV_NAME"; then
    echo "Ambiente '$ENV_NAME' já existe. A remover..."
    conda env remove -n "$ENV_NAME" -y
fi

# Criar novo ambiente com Prokka e wget
echo "A criar o ambiente '$ENV_NAME'..."
conda create -n "$ENV_NAME" -c bioconda -c conda-forge prokka wget -y
echo "Ambiente '$ENV_NAME' criado com sucesso!"

# Ativar o ambiente
conda activate "$ENV_NAME"

echo ""
echo "=========================================="
echo "[2/4] Criação da estrutura de diretórios"
echo "=========================================="

mkdir -p projeto/{raw_data,cleaned_data,annotation_results}
echo "Estrutura criada:"
find projeto -type d


echo ""
echo "=========================================="
echo "[3/4] Instalação do Prokka"
echo "=========================================="

if command -v prokka &> /dev/null; then
    echo "Prokka instalado corretamente."
else
    echo "Erro: Prokka não foi encontrado no ambiente."
    exit 1
fi

prokka --version

echo ""
echo "=========================================="
echo "[4/4] Download do ficheiro genómico"
echo "=========================================="

cd projeto/raw_data
GENOME_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz"

echo "A descarregar ficheiro genómico..."
wget -N "$GENOME_URL"

echo "A descomprimir o ficheiro..."
gunzip -f GCF_000005845.2_ASM584v2_genomic.fna.gz


echo "executar o prokka"
prokka GCF_000005845.2_ASM584v2_genomic.fna \
  --outdir ../annotation_results \
  --prefix ecoli \
  --cpus 2


echo "Genoma disponível em: $(pwd)/GCF_000005845.2_ASM584v2_genomic.fna"

echo ""
echo "=========================================="
echo " Script concluído com sucesso!"
echo "=========================================="
