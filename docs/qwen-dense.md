# Qwen3.8-27B dense (quant + mmap)

Qwen3.8-27B è **dense**: tutti i parametri sono attivi a ogni token.  
Colibrì non lo streama come MoE. Usiamo il metodo “disco come memoria” con quantizzazione forte e mmap.

## Quant consigliati per 16 GB RAM

| Quant | Dimensione approx | Uso |
|-------|-------------------|-----|
| UD-Q3_K_XL / IQ3 | ~11-13 GB | Consigliato |
| IQ2 / Q2_K | ~7-10 GB | Più leggero, qualità inferiore |
| Q4_K_M | ~16-18 GB | Solo con contesto molto basso e poca altra RAM usata |

Fonti tipiche: `unsloth/Qwen3.8-27B-GGUF`, ISTA-DASLab, bartowski.

## Esempio con llama.cpp

```bash
# Build (CPU)
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp
cmake -B build && cmake --build build -j --config Release

# Run (sostituisci il path del GGUF)
./build/bin/llama-server \
  -m /path/to/Qwen3.8-27B-UD-Q3_K_XL.gguf \
  -c 4096 \
  -t 4 \
  --mmap \
  --host 127.0.0.1 --port 8080
```

- `-c 4096` (o 8192) → non saturare la KV cache
- `--mmap` → i pesi restano sul file, letti on-demand
- `-t 4` → usa i tuoi 4 core

## Limiti

- Velocità: pochi token/s su 4 core.
- Contesto lungo: costa RAM extra; resta basso.
- Qualità: quant Q3/IQ2 è usabile ma inferiore a Q4/Q5 su macchine più grandi.
