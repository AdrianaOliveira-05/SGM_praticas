]#!/bin/bash
set -e

# ============================================
# go.sh — Script do Exercício 1
# Automatiza:
# 1) Criação do ambiente Conda
# 2) Instalação do Prokka
# 3) Criação da estrutura de diretórios
# 4) Download do genoma (FASTA)
# 5) Execução do Prokka
# 6) Guarda todos os comandos num ficheiro
# ============================================

# Nome do ambiente
ENV_NAME="prokka_env"

# URL e ficheiro do genoma
URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz"
FILENAME="GCF_000005845.2_ASM584v2_genomic.fna.gz"

# Criar ficheiro de log dos comandos
LOGFILE="comandos_executados.txt"
echo "# Lista de comandos executados" > $LOGFILE

log() {
    echo "$1" | tee -a $LOGFILE
}

# ============================================
# 1. Criar o ambiente Conda
# ============================================
log "conda create -y -n $ENV_NAME prokka=1.14.6 perl=5.26 bioperl=1.7.2"
conda create -y -n $ENV_NAME prokka=1.14.6 perl=5.26 bioperl=1.7.2

log "conda activate $ENV_NAME"
source ~/anaconda3/etc/profile.d/conda.sh
conda activate $ENV_NAME

# ============================================
# 2. Criar diretórios do projeto
# ============================================
log "mkdir -p projeto/raw"
log "mkdir -p projeto/annotation_results"
mkdir -p projeto/raw
mkdir -p projeto/annotation_results

# ============================================
# 3. Download do genoma
# ============================================
log "cd projeto/raw"
cd projeto/raw

log "wget $URL"
wget $URL

# ============================================
# 4. Descomprimir o ficheiro FASTA
# ============================================
log "gunzip -k $FILENAME"
gunzip -k $FILENAME

# Nome do ficheiro descomprimido
FASTA="${FILENAME%.gz}"

# ============================================
# 5. Executar o Prokka
# ============================================
log "cd ../annotation_results"
cd ../annotation_results

log "prokka ../raw/$FASTA --outdir ecoli_annotation --prefix ecoli"
prokka ../raw/$FASTA --outdir ecoli_annotation --prefix ecoli

# ============================================
# Fim
# ============================================
log "# Execução concluída com sucesso!"
echo "✔ Script terminado sem erros!"
echo "✔ Os comandos usados estão guardados em: $LOGFILE"
