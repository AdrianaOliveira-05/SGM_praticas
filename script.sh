diff --git a/script.sh b/script.sh
index 132a320b497eae772d28d6f48e73ca9be08ee8dc..52d8663cc06dbc61bc7874cb036e43bbd23d56ae 100644

b/script.sh
@@ -1,95 +1,127 @@
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
 

set -euo pipefail
 
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
 
# Caminho para o environment.yml localizado na mesma pasta deste script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/environment.yml"

if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Não encontrei o ficheiro environment.yml em $SCRIPT_DIR"
    exit 1
fi

 # Cria o ambiente a partir do environment.yml se ainda não existir

if ! conda env list | awk 'NR>2 {print $1}' | grep -qx "$ENV_NAME"; then
    echo "-> A criar ambiente $ENV_NAME a partir de $ENV_FILE..."
    conda env create -f "$ENV_FILE"
 else

    echo "-> Ambiente $ENV_NAME já existe, a sincronizar dependências."
    conda env update -f "$ENV_FILE" --prune
 fi
 
 # Activar o ambiente
 echo "-> Ativar ambiente $ENV_NAME"
 conda activate "$ENV_NAME"
 
# Validar disponibilidade do Prokka (versão definida no environment.yml)
if ! command -v prokka >/dev/null 2>&1; then
    echo "-> Prokka não detetado, a tentar instalar via Conda..."
    conda install -y -n "$ENV_NAME" prokka=1.14.6

    if ! command -v prokka >/dev/null 2>&1; then
        echo "❌ Prokka continua indisponível mesmo após tentativa de instalação."
        exit 1
    fi
fi

echo "-> Versão do Prokka: $(prokka --version)"

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
wget -c "$GENOME_URL"
 
 echo "Ficheiro descarregado: $GENOME_GZ"
 
 echo "====================================="
 echo "5) Descomprimir o ficheiro FASTA"
 echo "====================================="
 

if [ ! -f "$GENOME_GZ" ]; then
    echo "❌ O ficheiro $GENOME_GZ não foi encontrado após o download."
    exit 1
fi

if [ ! -f "${GENOME_GZ%.gz}" ]; then
    gunzip -k "$GENOME_GZ"
else
    echo "-> Ficheiro FASTA já descomprimido, a reutilizar."
fi
 
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
 


