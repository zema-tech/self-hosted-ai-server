# Self-Hosted AI Server

Repository per hostare modelli AI (LLM) su un server con **16 GB RAM**, **4 core CPU** e **50 GB di disco**.

Ottimizzato per CPU-only (senza GPU dedicata) usando **Ollama** + modelli quantizzati leggeri.

## Hardware target

| Specifica     | Valore     |
|---------------|------------|
| RAM           | 16 GB      |
| CPU           | 4 core     |
| Disco         | 50 GB      |
| GPU           | Nessuna    |

### Cosa puoi far girare realisticamente

- Modelli **3B–9B** quantizzati (Q4 / Q5)
- Velocità tipica su CPU: **3–15 token/secondo** (dipende dal modello)
- Contesto consigliato: 4k–8k token (per non saturare la RAM)

**Modelli consigliati (2026):**

| Modello              | Dimensione approx | Uso consigliato              | Comando Ollama                  |
|----------------------|-------------------|------------------------------|---------------------------------|
| Qwen3.5 4B           | ~3.3 GB           | Uso generale leggero         | `ollama run qwen3.5:4b`         |
| Qwen3.5 9B           | ~6.6 GB           | Miglior bilanciamento        | `ollama run qwen3.5:9b`         |
| Gemma 4 (varianti piccole) | ~4–8 GB     | Chat + reasoning             | `ollama run gemma3:4b` / simili |
| Llama 3.2 / 3.1 8B   | ~4.5–5 GB         | Coding e chat                | `ollama run llama3.2:3b` o 8B   |
| Phi-4 Mini / simili  | ~2–4 GB           | Velocità massima             | `ollama run phi4-mini`          |

> Regola pratica: tieni il modello sotto **~8 GB** di peso e lascia almeno 4–5 GB liberi per OS + KV cache.

## Installazione rapida (Linux)

### 1. Installa Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### 2. Avvia il servizio

```bash
sudo systemctl enable ollama
sudo systemctl start ollama
```

### 3. Scarica un modello leggero

```bash
# Consigliato per iniziare
ollama pull qwen3.5:4b

# Oppure il più capace che entra bene
ollama pull qwen3.5:9b
```

### 4. Testa

```bash
ollama run qwen3.5:4b
```

## Deploy con Docker (consigliato)

```bash
docker compose up -d
```

Poi:

```bash
docker exec -it ollama ollama pull qwen3.5:4b
docker exec -it ollama ollama run qwen3.5:4b
```

## Esporre l’API (OpenAI-compatible)

Ollama espone già un’API OpenAI-compatible su `http://localhost:11434`.

Per renderla accessibile dalla rete (con attenzione alla sicurezza):

```bash
# Solo se sai cosa stai facendo
export OLLAMA_HOST=0.0.0.0:11434
```

**Importante:** non esporre direttamente su internet senza autenticazione (reverse proxy + auth consigliato).

## Monitoraggio risorse

```bash
# Uso RAM/CPU
htop

# Spazio disco modelli
du -sh ~/.ollama/models

# Lista modelli installati
ollama list
```

## Consigli per non saturare le risorse

1. **Un solo modello carico alla volta** (Ollama ne tiene uno in memoria di default).
2. Limita il contesto: `--num-ctx 4096` o 8192.
3. Chiudi altri servizi pesanti mentre usi il modello.
4. Preferisci quantizzazione Q4_K_M / Q5.
5. 50 GB di disco: tieni solo 2–3 modelli contemporaneamente.

## Struttura del repository

```
.
├── README.md
├── docker-compose.yml
├── scripts/
│   └── install.sh
├── .gitignore
└── docs/
    └── modelli-consigliati.md
```

## Sicurezza

- Non esporre la porta 11434 pubblicamente senza autenticazione.
- Usa un reverse proxy (Caddy / Nginx) con basic auth o JWT.
- Tieni Ollama aggiornato.

## Licenza

MIT – usa pure come base per i tuoi progetti.

---

Creato per server low-resource. Buon self-hosting!
