# Qwen MoE (metodo Colibrì)

## Target principale: Qwen3.6-35B-A3B

| Voce | Valore |
|------|--------|
| Parametri totali | ~35B |
| Attivi per token | ~3B |
| Container Colibrì | ~23 GB |
| RAM tipica | 10-20 GB (densa + cache) |
| Supporto | Nativo in Colibrì (engine qwen36) |

## Perché è la scelta giusta sul tuo server

- Entra nel disco da 50 GB.
- Usa **streaming degli expert** → stesso metodo di ds4/Colibrì.
- Qualità superiore a un 7-8B classico, con footprint attivo da modello piccolo.

## Installazione

```bash
./scripts/install-colibri.sh
# oppure
git clone https://github.com/JustVugg/colibri.git && cd colibri && ./start-here.sh
```

Quando il setup chiede il modello, scegli **Qwen3.6-35B-A3B** (o il Coder se preferisci codice).

## Comandi dopo l’install

```bash
./coli chat
./coli serve          # API OpenAI-compatible
./coli setup --list   # verifica cosa entra ancora
```

## Alternative MoE nella stessa fascia

- **Qwen3-Coder-30B-A3B** (~19 GB) — se il focus è coding
- OLMoE (più piccolo) — solo per test veloci del motore
