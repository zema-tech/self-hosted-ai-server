#!/bin/bash
# Esempio di lancio Qwen3.8-27B dense quantizzato con llama.cpp + mmap
set -euo pipefail

MODEL="${1:-}"
if [ -z "$MODEL" ]; then
  echo "Uso: $0 /path/to/Qwen3.8-27B-*.gguf"
  echo
  echo "Consigliato: quant Q3 / IQ3 (~11-13 GB) per 16 GB RAM"
  echo "Esempio: unsloth/Qwen3.8-27B-GGUF  UD-Q3_K_XL o IQ3"
  exit 1
fi

if [ ! -f "$MODEL" ]; then
  echo "File non trovato: $MODEL"
  exit 1
fi

# Cerca llama-server
LLAMA=""
for c in llama-server ./llama-server ./build/bin/llama-server; do
  if command -v "$c" >/dev/null 2>&1 || [ -x "$c" ]; then
    LLAMA="$c"
    break
  fi
done

if [ -z "$LLAMA" ]; then
  echo "llama-server non trovato. Installa llama.cpp e mettilo nel PATH."
  exit 1
fi

echo "Modello: $MODEL"
echo "Contesto: 4096 | thread: 4 | mmap attivo"
exec "$LLAMA" \
  -m "$MODEL" \
  -c 4096 \
  -t 4 \
  --mmap \
  --host 127.0.0.1 \
  --port 8080
