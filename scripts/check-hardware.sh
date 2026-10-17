#!/bin/bash
echo "=== Check hardware per self-hosted AI (stile Colibrì/ds4) ==="
echo

# RAM
if command -v free >/dev/null; then
  echo "--- Memoria ---"
  free -h
  echo
fi

# Disco
echo "--- Disco ---"
df -h / 2>/dev/null || df -h
echo

# CPU
echo "--- CPU ---"
if command -v nproc >/dev/null; then
  echo "Core logici: $(nproc)"
fi
if [ -f /proc/cpuinfo ]; then
  grep -m1 "model name" /proc/cpuinfo || true
fi
echo

# Spazio libero approssimativo
FREE_GB=$(df -BG / 2>/dev/null | awk 'NR==2 {print $4}' | tr -d 'G' || echo "?")
echo "Spazio libero su / : ~${FREE_GB} GB"
echo

if [ "$FREE_GB" != "?" ] && [ "$FREE_GB" -lt 25 ]; then
  echo "ATTENZIONE: meno di 25 GB liberi."
  echo "Colibrì richiede almeno ~22 GB per i modelli più piccoli."
  echo "I modelli grandi (DeepSeek, GLM) non entreranno comunque."
fi

echo
echo "Consiglio: parti da OLMoE o Qwen3.6-35B-A3B se il disco lo permette."
