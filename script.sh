#!/bin/bash
# ============================================
# go.sh — Exercício 1: Anotação Automatizada
# ============================================
# Este script:
#  1) Cria/usa um ambiente Conda a partir de environment.yml
#  2) Activa o ambiente (prokka disponível)
#  3) Cria a estrutura de diretórios do projecto
#  4) Faz download do genoma E. coli (formato FASTA .fna.gz)
#  5) Descomprime o ficheiro FASTA
#  6) Executa o Prokka para anotação
#  7) Guarda todos os comandos executados em comandos_executados.txt
# ============================================

set -e

# Nome do ambiente (deve ser o mesmo que está em environment.yml)
ENV_NAME="prokka_env"

# URL e ficheiro do genoma
GENOME_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz"
GENOME_FILE="GCF_000005845.2_ASM584v2_genomic.fna.gz"

# Ficheiro onde vamos guardar todos os comandos
LOGFILE="comandos_executados.txt"
echo "# Lista de comandos executados" > "$LOGFILE"

log() {
    echo "$1" | tee -a "$LOGFILE"
}

# ============================================
# 1. Inicializar o conda no shell actual
# ============================================
log 'eval "$(conda shell.bash hook)"'
eval "$(conda shell.bash hook)"

# ============================================
# 2. Criar o ambiente Conda a partir do environment.yml (se ainda não existir)
# ============================================
if ! conda env list | grep -q "$ENV_NAME"; then
    log "conda env create -f environment.yml"
    conda env create -f environment.yml
fi

# Activar o ambiente
log "conda activate $ENV_NAME"
conda activate "$ENV_NAME"

# ============================================
# 3. Criar a estrutura de diretórios
# ============================================
log "mkdir -p projeto/raw"
mkdir -p projeto/raw

log "mkdir -p projeto/annotation_results"
mkdir -p projeto/annotation_results

# ============================================
# 4. Download do genoma (ficheiro FASTA .fna.gz)
# ============================================
log "cd projeto/raw"
cd projeto/raw

log "wget $GENOME_URL"
wget "$GENOME_URL"

# ============================================
# 5. Descomprimir o ficheiro FASTA
# ============================================
log "gunzip -k $GENOME_FILE"
gunzip -k "$GENOME_FILE"

# Nome do ficheiro descomprimido (.fna)
FASTA_FILE="${GENOME_FILE%.gz}"

# ============================================
# 6. Executar o Prokka para anotação
# ============================================
log "cd ../annotation_results"
cd ../annotation_results

log "prokka ../raw/$FASTA_FILE --outdir ecoli_annotation --prefix ecoli"
prokka ../raw/"$FASTA_FILE" --outdir ecoli_annotation --prefix ecoli

# ============================================
# 7. Fim
# ============================================
log "# Execução concluída com sucesso"
echo "✔ Script terminado sem erros."
echo "✔ Comandos usados: $(pwd)/$LOGFILE"

