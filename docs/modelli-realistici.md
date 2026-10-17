# Modelli realistici per 16 GB / 50 GB

## Priorità consigliata (Colibrì)

1. **OLMoE**  
   - Disco: ~7 GB  
   - RAM: ~8 GB  
   - Uso: sperimentare lo streaming e il motore  
   - Velocità: la più alta sul tuo hardware

2. **Qwen3.6-35B-A3B**  
   - Disco: ~23 GB  
   - RAM: 10-20 GB  
   - Uso: chat + thinking + tool  
   - Entra sul disco; sulla RAM è borderline ma fattibile

3. **Qwen3-Coder-30B-A3B**  
   - Disco: ~19 GB  
   - Buono se il focus è codice

## Cosa non tentare (con 50 GB di disco)

- DeepSeek V4 Flash (85-167 GB)
- DeepSeek V4.1 Flash
- GLM-5.2 / 5.3 (~370 GB)
- Kimi K3, Inkling, ecc.

Anche se la RAM basterebbe in streaming, il **download non entra**.

## Velocità attesa (ordine di grandezza)

| Scenario | Token/s tipici |
|----------|----------------|
| OLMoE residente, 4 core | qualche tok/s |
| Qwen3.6-35B con expert in cache | 1-6 tok/s (dipende da quanti expert tieni in RAM) |
| Expert cold da SSD lento | < 1 tok/s |

Questi numeri non sono “lenti rispetto a una GPU”: sono la realtà di un server CPU-only con poca RAM e poco disco.
