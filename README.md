# Self-Hosted AI — stile Colibrì / ds4

Motore di inferenza **minimale**, non un framework generale come Ollama.

Ispirato a:
- [antirez/ds4](https://github.com/antirez/ds4) (DwarfStar) — motore C specializzato per DeepSeek V4 Flash / GLM, con SSD streaming
- [JustVugg/colibri](https://github.com/JustVugg/colibri) — pure C, zero dipendenze, expert streamati da disco, modelli fino a 744B+ su hardware consumer

**Obiettivo di questo repo**: far girare modelli IA “grandi” (MoE) su un server reale con **16 GB RAM · 4 core · 50 GB disco**, sfruttando lo streaming degli expert da SSD invece di tenere tutto in RAM.

---

## Filosofia (come ds4 e Colibrì)

1. **Un motore stretto**, non un runtime generico.
2. **Il modello non deve stare tutto in RAM** — solo la parte densa + un piccolo cache di expert.
3. **Il disco (preferibilmente NVMe) diventa parte della gerarchia di memoria**.
4. **Codice C minimale**, poche o zero dipendenze esterne a runtime.
5. **Un file (o pochi file) per famiglia di modello**.

Non stiamo costruendo “un altro Ollama”. Stiamo costruendo (o avvolgendo) un motore che tratti il tuo hardware limitato come i creatori di ds4 e Colibrì trattano un Mac o un laptop da 16-25 GB.

---

## Realtà del tuo hardware (16 GB / 4 core / 50 GB)

| Vincolo | Impatto |
|---------|--------|
| **50 GB disco** | I modelli frontier (DeepSeek V4 Flash ~167 GB, GLM-5.2 ~372 GB) **non entrano**. Solo modelli piccoli/medi o container fortemente ridotti. |
| **16 GB RAM** | La parte densa + cache expert deve stare sotto ~12-13 GB (lasciando spazio a OS). |
| **4 core CPU** | Velocità bassa: pochi token/s, soprattutto in cold streaming. |
| **Niente GPU** | Solo path CPU (Colibrì e ds4 supportano CPU; ds4 è ottimizzato soprattutto su Metal/CUDA). |

### Cosa è realistico oggi

| Modello (via Colibrì) | Disco approx | RAM residente | Note |
|-----------------------|--------------|---------------|------|
| **OLMoE** (7B / 1B active) | ~7 GB | ~8 GB | Il più piccolo, gira bene |
| **Qwen3.6-35B-A3B** | ~23 GB | ~10-20 GB | Entra sul disco, borderline su RAM |
| **Qwen3-Coder-30B-A3B** | ~19 GB | ~8-18 GB | Buono per coding |
| DeepSeek V4 Flash (pieno) | 85-167 GB | 16+ GB | **Non entra** sul disco |
| GLM-5.2 / 5.3 | ~370 GB | 16+ GB | **Impossibile** |

Con 50 GB di disco il tetto pratico è un modello da ~20-40 GB di container quantizzato.

---

## Come partire (Colibrì — raccomandato)

Colibrì è pure C, zero dipendenze a runtime, e fa esattamente lo streaming degli expert da disco.

```bash
# Dipendenze di build
sudo apt update
sudo apt install -y git python3 build-essential

# Clona e avvia il setup guidato
git clone https://github.com/JustVugg/colibri.git
cd colibri
./start-here.sh
```

Il setup:
1. Legge RAM e disco libero
2. Ti propone solo i modelli che entrano
3. Compila (o scarica) il motore
4. Scarica il container del modello (con resume)
5. Avvia `coli chat` / `coli serve`

Per il tuo server, probabilmente ti proporrà **OLMoE** o **Qwen3.6-35B-A3B** (se hai ~23 GB liberi).

### Comandi utili dopo l’installazione

```bash
./coli chat          # chat interattiva
./coli serve         # API OpenAI-compatible
./coli setup --list  # tutti i modelli e perché entrano / non entrano
```

---

## Alternativa: ds4 (antirez)

ds4 è un motore C altamente specializzato (DeepSeek V4 Flash / GLM, con path Metal e CUDA molto ottimizzati). Supporta **SSD streaming** degli expert.

```bash
git clone https://github.com/antirez/ds4.git
cd ds4
make cpu          # build solo CPU (Linux)
# poi scarica un GGUF compatibile e lancia con --ssd-streaming
```

Attenzione: ds4 è pensato soprattutto per Mac con tanta memoria unificata e GPU. Sul tuo server CPU-only a 16 GB sarà molto più lento e i modelli full non entrano comunque sul disco.

---

## Struttura di questo repository

```
.
├── README.md                 # questo file
├── docs/
│   ├── filosofia.md          # perché non Ollama
│   ├── limiti-hardware.md    # calcoli realistici 16GB/50GB
│   └── modelli-realistici.md
├── scripts/
│   ├── install-colibri.sh    # setup automatico Colibrì
│   └── check-hardware.sh     # verifica RAM/disco/CPU
└── .gitignore
```

---

## Prossimi passi possibili

- Script che scarica e prepara solo i container che entrano in 50 GB
- Wrapper minimale in C intorno a un motore esistente (stile “un solo binario”)
- Documentazione su come convertire/quantizzare un MoE per ridurre il footprint su disco
- Benchmark reali sul tuo hardware (4 core + SSD)

Se vuoi, possiamo:
1. Fare di questo repo un **fork/setup guidato di Colibrì** ottimizzato per 16 GB / 50 GB, oppure
2. Iniziare uno **scheletro di motore C** (caricamento GGUF/safetensors + streaming expert) nello spirito di ds4, anche se sarà un progetto lungo.

Dimmi quale direzione preferisci.
