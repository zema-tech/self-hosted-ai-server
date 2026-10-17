# Filosofia: perché non Ollama

## Ollama vs ds4 / Colibrì

| Aspetto | Ollama / llama.cpp generico | ds4 / Colibrì |
|---------|-----------------------------|---------------|
| Scopo | Far girare *tanti* modelli diversi | Far girare *pochi* modelli grandi al meglio |
| Codice | Runtime generale + wrapper | Motore verticale, un file (o pochi) per famiglia |
| Memoria | Tutto (o quasi) in RAM / VRAM | Parte densa in RAM, expert su disco |
| Dipendenze | Go / C++ / Python a seconda | Pure C, zero o quasi zero runtime deps |
| Target | Laptop / server generico | Hardware consumer limitato ma con SSD veloce |
| Astrazione | Alta (facilità d’uso) | Bassa (controllo e performance) |

## Cosa vogliamo qui

- Trattare il **disco come memoria** (streaming degli expert).
- Accettare che 16 GB di RAM non bastano per un 300B+ se lo carichi tutto.
- Preferire un motore piccolo e specializzato a un framework che “fa tutto”.
- Essere onesti sui limiti del disco da 50 GB.

Questo non è un prodotto “plug-and-play per tutti i modelli”.
È un tentativo di portare lo spirito di antirez e di Colibrì su un server piccolo e reale.
