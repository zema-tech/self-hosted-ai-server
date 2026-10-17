# Limiti reali del tuo server

**16 GB RAM · 4 core · 50 GB disco · no GPU**

## Disco (il vincolo più duro)

I modelli MoE “frontier” quantizzati in int4 occupano:

- OLMoE 7B → ~7 GB
- Qwen3.6-35B-A3B → ~23 GB
- DeepSeek V4 Flash (REAP) → ~85 GB
- DeepSeek V4 Flash pieno → ~167 GB
- GLM-5.2 → ~370 GB

Con **50 GB** totali (OS + swap + modelli) puoi realisticamente tenere:

- 1 modello da ~20-30 GB, oppure
- 2 modelli molto piccoli (~7-15 GB ciascuno)

Non puoi ospitare DeepSeek V4 Flash o GLM-5.x completi.

## RAM

- OS + servizi base: ~1.5-3 GB
- Parte densa del modello (sempre residente): dipende dal modello (es. ~10 GB per Qwen3.6-35B)
- Cache expert + KV + overhead: il resto

Regola pratica: se la parte densa + cache minima supera ~12-13 GB, rischi OOM o thrashing.

## CPU (4 core)

Token generation su CPU con streaming da disco è **memory-bandwidth e I/O bound**.
Aspettati:

- modelli piccoli residenti: qualche token/s
- modelli con expert streamati a freddo: 0.05 – 1 tok/s (dipende dalla velocità del disco)

Un NVMe veloce aiuta moltissimo; un HDD rende l’esperienza quasi inutilizzabile.

## Cosa fare in pratica

1. Usa **Colibrì** e lascia che il setup ti proponga solo ciò che entra.
2. Parti da **OLMoE** o **Qwen3.6-35B-A3B**.
3. Non cercare di forzare modelli da 100+ GB di container.
4. Se in futuro aumenti il disco (anche solo a 200-400 GB), si aprono DeepSeek Flash e simili.
