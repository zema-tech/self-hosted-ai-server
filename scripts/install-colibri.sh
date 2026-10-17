#!/bin/bash
set -euo pipefail

echo "=== Setup Colibrì per server 16GB / 4 core / 50GB ==="
echo

# Controlli base
if ! command -v git >/dev/null; then
  echo "Installa git prima."
  exit 1
fi

if ! command -v python3 >/dev/null; then
  echo "Installa python3."
  exit 1
fi

echo "[1/4] Dipendenze di compilazione..."
if command -v apt-get >/dev/null; then
  sudo apt-get update -qq
  sudo apt-get install -y build-essential git python3
fi

TARGET_DIR="${1:-$HOME/colibri}"

if [ -d "$TARGET_DIR" ]; then
  echo "Directory $TARGET_DIR già esistente. Aggiorno..."
  cd "$TARGET_DIR"
  git pull || true
else
  echo "[2/4] Clono Colibrì in $TARGET_DIR..."
  git clone https://github.com/JustVugg/colibri.git "$TARGET_DIR"
  cd "$TARGET_DIR"
fi

echo "[3/4] Lancio il setup interattivo di Colibrì..."
echo "    Il setup leggerà la tua RAM e il disco libero e ti proporrà solo modelli che entrano."
echo
./start-here.sh

echo
echo "[4/4] Fatto."
echo "Comandi utili:"
echo "  cd $TARGET_DIR"
echo "  ./coli chat"
echo "  ./coli serve"
echo "  ./coli setup --list"
