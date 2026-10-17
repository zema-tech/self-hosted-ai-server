#!/bin/bash
# Avvia Colibrì su Qwen MoE (dopo aver fatto install-colibri.sh)
set -euo pipefail

COLIBRI_DIR="${COLIBRI_DIR:-$HOME/colibri}"

if [ ! -d "$COLIBRI_DIR" ]; then
  echo "Colibrì non trovato in $COLIBRI_DIR"
  echo "Esegui prima: ./scripts/install-colibri.sh"
  exit 1
fi

cd "$COLIBRI_DIR"

if [ ! -x ./coli ]; then
  echo "Binario coli non trovato. Riesegui il setup di Colibrì."
  exit 1
fi

echo "Avvio coli chat (Qwen MoE se installato)..."
exec ./coli chat
