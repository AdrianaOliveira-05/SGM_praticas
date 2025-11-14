#!/bin/bash
# ============================================
# Exercício 1 — Anotação Automatizada de um Genoma Bacteriano
#
# Este script faz:
#  1) Inicializa o Conda e cria o ambiente prokka_env (a partir de environment.yml)
#  2) Cria uma pasta para o exercício
#  3) Faz o download do genoma em formato FASTA (.fna.gz) com wget
#  4) Descomprime o ficheiro (.fna.gz -> .fna)
#  5) Executa o Prokka para anotar o genoma
# ============================================

set -e

# Nome do ambiente (tem de coincidir com o environment.yml)
ENV_NAME="prokka_env"

# Pasta do exercício (Passo 1 da folha)
EXERCISE_DIR="exercicio_prokka"

# URL e nome do ficheiro do genoma montado
GENOME_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz"
GENOME_GZ="GCF_000005845.2_ASM584v2_genomic.fna.gz"

echo "====================================="
echo "1) Inicializar Conda"
echo "====================================="

# Tenta encontrar o conda.sh em locais típicos da VM
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/anaconda3/etc/profile.d/conda.sh"
elif [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
    source "/opt/miniconda3/etc/profile.d/conda.sh"
else
    echo "❌ Não encontrei o ficheiro conda.sh."
    echo "   Verifica onde está instalado o Conda e ajusta o caminho no script."
    exit 1
fi

echo "====================================="
echo "2) Criar ambiente Conda (se necessário)"
echo "====================================="

# Cria o ambiente a partir do environment.yml se ainda não existir
if ! conda env list | grep -q " $ENV_NAME"; then
    echo "-> A criar ambiente $ENV_NAME a partir de environment.yml..."
    conda env create -f environment.yml
else
    echo "-> Ambiente $ENV_NAME já existe, a reutilizar."
fi

# Activar o ambiente
echo "-> Ativar ambiente $ENV_NAME"
conda activate "$ENV_NAME"

echo "====================================="
echo "3) Criar pasta para o exercício"
echo "====================================="

mkdir -p "$EXERCISE_DIR"
cd "$EXERCISE_DIR"

echo "Diretório do exercício: $(pwd)"

echo "====================================="
echo "4) Download do genoma (wget)"
echo "====================================="

# Passo 1.2 da folha: download do genoma em formato FASTA
wget "$GENOME_URL"

echo "Ficheiro descarregado: $GENOME_GZ"

echo "====================================="
echo "5) Descomprimir o ficheiro FASTA"
echo "====================================="

gunzip -k "$GENOME_GZ"

GENOME_FNA="${GENOME_GZ%.gz}"
echo "Ficheiro FASTA descomprimido: $GENOME_FNA"

echo "====================================="
echo "6) Executar o Prokka"
echo "====================================="

# O Prokka vai criar automaticamente a pasta de saída
prokka "$GENOME_FNA" --outdir anotacao_ecoli --prefix ecoli

echo "====================================="
echo "✔ Terminado!"
echo "Resultados da anotação em: $(pwd)/anotacao_ecoli"

