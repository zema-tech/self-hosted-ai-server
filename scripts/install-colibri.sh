#!/bin/bash
set -euo pipefail

echo "=== Colibrì per Qwen MoE (fascia 27-35B) su 16GB/4core/50GB ==="
echo

if ! command -v git >/dev/null; then
  echo "Serve git."
  exit 1
fi

if ! command -v python3 >/dev/null; then
  echo "Serve python3."
  exit 1
fi

if command -v apt-get >/dev/null; then
  echo "[1/3] Dipendenze..."
  sudo apt-get update -qq
  sudo apt-get install -y build-essential git python3
fi

TARGET_DIR="${1:-$HOME/colibri}"

if [ -d "$TARGET_DIR" ]; then
  echo "Aggiorno $TARGET_DIR..."
  cd "$TARGET_DIR" && git pull || true
else
  echo "[2/3] Clono Colibrì..."
  git clone https://github.com/JustVugg/colibri.git "$TARGET_DIR"
  cd "$TARGET_DIR"
fi

echo "[3/3] Setup interattivo (scegli Qwen3.6-35B-A3B se offerto)..."
echo
./start-here.sh

echo
echo "Fatto. Poi:"
echo "  cd $TARGET_DIR && ./coli chat"
echo "  oppure: $(pwd)/scripts/run-qwen-moe.sh  (se lanciato dal repo)"
