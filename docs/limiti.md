# Limiti del server 16 GB / 4 core / 50 GB

| Risorsa | Limite pratico |
|---------|----------------|
| Disco | ~40-45 GB utilizzabili per modelli (dopo OS) |
| RAM | Parte densa + cache + OS ≤ ~14-15 GB |
| CPU | 4 core → decode lento, soprattutto con I/O da disco |
| GPU | Nessuna → solo path CPU |

## Cosa entra

- Qwen3.6-35B-A3B (~23 GB) via Colibrì
- Qwen3-Coder-30B-A3B (~19 GB)
- Qwen3.8-27B quant Q3/IQ2-IQ3 (~10-13 GB) via llama.cpp

## Cosa non entra

- DeepSeek V4 Flash (85-167 GB)
- GLM-5.x (~370 GB)
- Qualsiasi container > ~40 GB

Aumentando solo il disco (anche a 100-200 GB) si aprono molti più MoE con lo stesso metodo di streaming.
