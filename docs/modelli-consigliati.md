# Modelli consigliati per 16 GB RAM / 4 core

Aggiornato ottobre 2026.

## Priorità di scelta

1. **Qualità vs velocità** → Qwen3.5 9B (se entra bene)
2. **Velocità massima** → Qwen3.5 4B o Phi-4 Mini
3. **Coding** → Qwen2.5-Coder / Llama 3.2 varianti piccole
4. **Multilingua (italiano incluso)** → Qwen series di solito eccellono

## Tabella pratica

| Priorità | Modello              | Peso approx | Token/s stimati (CPU 4-core) | Note                          |
|----------|----------------------|-------------|------------------------------|-------------------------------|
| ★★★★★    | qwen3.5:4b           | 3.3 GB      | 10–18                        | Miglior punto di partenza     |
| ★★★★☆    | qwen3.5:9b           | 6.6 GB      | 5–12                         | Più capace, ancora gestibile  |
| ★★★★     | gemma3:4b / simili   | ~4 GB       | 8–15                         | Buona qualità Google          |
| ★★★☆     | llama3.2:3b          | ~2 GB       | 15–25                        | Molto veloce, qualità media   |
| ★★★      | phi4-mini            | ~2–3 GB     | 12–20                        | Ottimo per task semplici      |

## Comandi pronti

```bash
# Leggero e veloce
ollama pull qwen3.5:4b
ollama run qwen3.5:4b

# Più qualità (se hai ~7-8 GB liberi)
ollama pull qwen3.5:9b
ollama run qwen3.5:9b

# Coding
ollama pull qwen2.5-coder:7b   # verifica disponibilità aggiornata
```

## Limiti da rispettare

- Non superare ~8–9 GB di modello + KV cache su 16 GB totali.
- Contesto lungo (32k+) consuma molta RAM extra → resta su 4k–8k.
- 50 GB di disco: 2–3 modelli al massimo contemporaneamente.

## Alternative a Ollama

- **llama.cpp** puro → massimo controllo e leggermente più efficiente su CPU.
- **LM Studio** → solo se hai interfaccia grafica (non ideale su server headless).
- **vLLM** → sconsigliato su CPU-only e 16 GB (nato per GPU + throughput alto).
