#!/bin/bash
set -e

echo "=== Installazione Self-Hosted AI Server ==="
echo "Target: 16GB RAM / 4 core / 50GB disco"
echo

# Controlla se siamo root o abbiamo sudo
if [ "$EUID" -ne 0 ]; then
  SUDO="sudo"
else
  SUDO=""
fi

# Installa dipendenze base
echo "[1/5] Aggiornamento sistema e dipendenze..."
$SUDO apt-get update -qq
$SUDO apt-get install -y curl htop ca-certificates

# Installa Ollama
echo "[2/5] Installazione Ollama..."
if ! command -v ollama &> /dev/null; then
  curl -fsSL https://ollama.com/install.sh | sh
else
  echo "Ollama già installato."
fi

# Avvia servizio
echo "[3/5] Avvio servizio Ollama..."
$SUDO systemctl enable ollama || true
$SUDO systemctl start ollama || true

# Aspetta che sia pronto
sleep 3

# Scarica modello leggero di default
echo "[4/5] Download modello consigliato (qwen3.5:4b)..."
ollama pull qwen3.5:4b

echo "[5/5] Test rapido..."
ollama run qwen3.5:4b "Ciao! Rispondi solo con: OK, tutto funzionante."

echo
echo "=== Installazione completata ==="
echo "Comandi utili:"
echo "  ollama list                  # modelli installati"
echo "  ollama run qwen3.5:4b        # chat interattiva"
echo "  ollama pull qwen3.5:9b       # modello più capace"
echo "  curl http://localhost:11434  # verifica API"
echo
