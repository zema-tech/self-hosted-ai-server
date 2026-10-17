#!/bin/bash
echo "=== Hardware check — Qwen 27-35B stile Colibrì/ds4 ==="
echo

if command -v free >/dev/null; then
  echo "--- RAM ---"
  free -h
  echo
fi

echo "--- Disco ---"
df -h / 2>/dev/null || df -h
echo

echo "--- CPU ---"
command -v nproc >/dev/null && echo "Core: $(nproc)"
[ -f /proc/cpuinfo ] && grep -m1 "model name" /proc/cpuinfo || true
echo

FREE_GB=$(df -BG / 2>/dev/null | awk 'NR==2 {gsub(/G/,"",$4); print $4}' || echo "?")
echo "Spazio libero su / ≈ ${FREE_GB} GB"
echo

if [ "$FREE_GB" != "?" ] && [ "$FREE_GB" -lt 25 ]; then
  echo "⚠  Meno di 25 GB liberi: Qwen3.6-35B-A3B (~23 GB) potrebbe non entrare."
  echo "   Considera quant dense Q3 (~12 GB) o libera spazio."
fi

echo
echo "Raccomandazione:"
echo "  1) MoE  → Colibrì + Qwen3.6-35B-A3B  (metodo streaming expert)"
echo "  2) Dense → llama.cpp + Qwen3.8-27B Q3/IQ3 + mmap"
