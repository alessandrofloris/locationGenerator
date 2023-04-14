# LocationGenerator

Dato un file OSM contenente le informazioni spaziali di una certa zona geografica calcola 
un cluster di potenziali clienti e un insieme di punti di pick up (utilizzando l'algoritmo 
di Maranzano per la risoluzione del p-problem)

Per la gestione dei dati spaziali utilizziamo OpenStreetMapX.
Per la visualizzazione dei punti e delle rotte utilizziamo OpenStreetMapXPlot e Plots (con GR come BE).

![example](https://github.com/alessandrofloris/locationGenerator/blob/main/img/example.png?raw=true)


## Bug e features

- [ ] Migliorare gestione del file di configurazione 
- [ ] Gestire il caso in cui la distanza tra due punti sia Inf
- [ ] L'algoritmo di partizionamento non sta funzionando bene

## Futuri sviluppi

- In questo momento i nodi cliente vengono generati in maniera totalmente randomica all'interno del grafo.
        Un possibile sviluppo futuro sarebbe quello di utilizzare diverse distribuzioni per la 
        genereazione di questi punti.
- Usare distribuzioni per la domanda dei clienti
