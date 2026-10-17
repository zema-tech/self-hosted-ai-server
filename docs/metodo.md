# Metodo Colibrì / ds4 applicato a Qwen ~27-35B

## Cosa fa Colibrì / ds4

1. Tengono in RAM solo la parte **sempre attiva** (attention, shared, embeddings).
2. Gli **expert** (o i tensori non sempre usati) restano sul disco.
3. A ogni token il router sceglie gli expert necessari → si leggono da SSD → si usano → si possono scaricare.
4. Motore in C minimale, specializzato per poche famiglie di modelli.

## Applicazione a Qwen

### Caso MoE (Qwen3.6-35B-A3B, Qwen3-Coder-30B-A3B, …)

- Stesso meccanismo: expert streamati.
- Colibrì ha già l’engine `qwen36`.
- Con ~23 GB di container e 16 GB di RAM il modello gira; la velocità dipende dalla cache expert e dalla velocità del disco.

### Caso Dense (Qwen3.8-27B)

- Non ci sono expert da “paginare” selettivamente.
- L’equivalente del metodo è:
  - quantizzare forte (Q3/IQ2-IQ3) così il file è 10-13 GB
  - usare **mmap** in llama.cpp → i pesi restano sul file e vengono toccati on-demand
  - tenere contesto basso (4k-8k) e pochi buffer
- Non è streaming intelligente come Colibrì, ma è lo stesso spirito: “il modello non deve stare tutto in RAM contemporaneamente”.

## Cosa non fare

- Non cercare di caricare un Q4_K_M da 17+ GB + contesto lungo su 16 GB: OOM o thrashing.
- Non aspettarti velocità da GPU: 4 core + streaming = pochi token/s.
- Non scaricare modelli da 80+ GB: il disco da 50 GB non li contiene.
