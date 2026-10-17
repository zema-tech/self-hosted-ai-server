# Qwen ~27-35B su server piccolo — metodo Colibrì / ds4

Applicare lo **stesso metodo** di [Colibrì](https://github.com/JustVugg/colibri) e [antirez/ds4](https://github.com/antirez/ds4) a modelli Qwen della fascia **27B–35B**, sul tuo hardware:

**16 GB RAM · 4 core · 50 GB disco · no GPU**

---

## Il metodo (in breve)

| Principio | Come lo usiamo qui |
|-----------|--------------------|
| Motore stretto, non framework generico | Colibrì per MoE · llama.cpp minimale per dense |
| Non tenere tutto in RAM | Expert streamati da disco (MoE) oppure quant forte + mmap (dense) |
| Disco = parte della memoria | NVMe/SSD obbligatorio se vuoi velocità accettabile |
| Onestà sui limiti | 50 GB di disco tagliano fuori i modelli troppo grossi |

---

## Due strade per la fascia Qwen 27-35B

### 1. MoE → metodo Colibrì/ds4 puro (consigliato)

**Qwen3.6-35B-A3B** (35B totali, ~3B attivi per token)

- Disco: **~23 GB** → entra nei tuoi 50 GB
- RAM residente: parte densa + piccolo cache expert (~10-20 GB)
- Colibrì lo supporta già e fa **streaming degli expert da disco**
- È esattamente lo stesso approccio di ds4/Colibrì

```bash
# Setup Colibrì (legge da solo RAM/disco e propone solo ciò che entra)
git clone https://github.com/JustVugg/colibri.git
cd colibri
./start-here.sh
# Scegli Qwen3.6-35B-A3B quando te lo propone
```

Oppure con lo script di questo repo:

```bash
./scripts/install-colibri.sh
```

### 2. Dense → quant forte + mmap (Qwen3.8-27B)

**Qwen3.8-27B** è **dense** (tutti i 27B attivi a ogni token).

Colibrì **non** lo streama come MoE (non ci sono expert da paginare).  
Il metodo “disco come memoria” diventa:

- quantizzazione aggressiva (Q3 / IQ2 / IQ3 ≈ 10-13 GB)
- `llama.cpp` con **mmap** (i pesi restano sul file e vengono letti on-demand)
- contesto corto (4k-8k) per non saturare la RAM

| Quant | Dimensione file | Realistico su 16 GB RAM |
|-------|-----------------|--------------------------|
| Q4_K_M / UD-Q4 | ~16-18 GB | Stretto, contesto basso |
| Q3_K / IQ3 | ~11-13 GB | Sì, con contesto moderato |
| IQ2 / Q2 | ~7-10 GB | Sì, più marginale qualità |

Esempio con llama.cpp:

```bash
# Scarica un quant leggero (es. Unsloth)
# Poi:
./llama-server \
  -m Qwen3.8-27B-UD-Q3_K_XL.gguf \
  -c 4096 \
  -t 4 \
  --mmap \
  --host 0.0.0.0 --port 8080
```

---

## Cosa entra davvero nei tuoi 50 GB

| Modello | Tipo | Disco | Metodo | Note |
|---------|------|-------|--------|------|
| **Qwen3.6-35B-A3B** | MoE | ~23 GB | Colibrì (streaming expert) | **Miglior match** al metodo ds4/Colibrì |
| Qwen3-Coder-30B-A3B | MoE | ~19 GB | Colibrì | Ottimo se serve coding |
| **Qwen3.8-27B** Q3/IQ3 | Dense | ~11-13 GB | llama.cpp + mmap | Dense, non streaming expert |
| Qwen3.8-27B Q4 | Dense | ~16-18 GB | llama.cpp + mmap | Borderline su 16 GB RAM |
| DeepSeek / GLM grandi | MoE | 85-370 GB | — | **Non entrano** sul disco |

---

## Struttura del repo

```
.
├── README.md
├── docs/
│   ├── metodo.md              # Colibrì/ds4 applicato a Qwen
│   ├── qwen-moe.md            # Qwen3.6-35B-A3B
│   ├── qwen-dense.md          # Qwen3.8-27B quant + mmap
│   └── limiti.md
├── scripts/
│   ├── install-colibri.sh
│   ├── run-qwen-moe.sh
│   ├── run-qwen-dense.sh
│   └── check-hardware.sh
└── .gitignore
```

---

## Partenza rapida

```bash
git clone https://github.com/zema-tech/self-hosted-ai-server.git
cd self-hosted-ai-server
chmod +x scripts/*.sh

./scripts/check-hardware.sh

# Strada MoE (consigliata)
./scripts/install-colibri.sh

# Oppure solo dense Qwen 27B (dopo aver installato llama.cpp)
# ./scripts/run-qwen-dense.sh
```

---

## Perché non “un altro Ollama”

Ollama nasconde il modello dietro un’API comoda.  
Qui vogliamo il **controllo del posizionamento dei pesi** (RAM vs disco), come fanno ds4 e Colibrì: meno astrazione, più capacità di far girare modelli che non entrano interamente in 16 GB.

Se in futuro aumenti il disco (anche solo a 100-200 GB), si aprono MoE più grandi con lo stesso metodo.
