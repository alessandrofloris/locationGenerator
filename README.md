# LocationGenerator

Dato un file OSM contenente le informazioni spaziali di una certa zona geografica calcola 
un cluster di potenziali clienti e un insieme di punti di pick up (utilizzando l'algoritmo 
di Maranzano per la risoluzione del p-problem)

Per la gestione dei dati spaziali utilizziamo OpenStreetMapX.
Per la visualizzazione dei punti e delle rotte utilizziamo OpenStreetMapXPlot e Plots (con GR come BE).

![example](https://github.com/alessandrofloris/locationGenerator/blob/main/img/example.png?raw=true)

Il programma restituisce in output un file cosi formattato:
Numero di punti di pick up
Per ogni punto di pick up 
        lat,long 
Numero di clienti
Per ogni cliente
        lat,lon 

## Cose da fare domani

- Trovare un modo per calcolare la matrice delle distanze una sola volta
- 

## Bug e features

- [ ] Ci sono dei casi in cui l'algoritmo di partizionamento non sta funzionando bene
- [ ] Gestire il caso in cui la distanza tra due punti sia Inf
        - Questo caso si verifica quando si cerca di calcolare la distanza tra due 
        vertici non collegati da un arco
- [ ] Ora calcolo una (sotto) matrice delle distanze ogni qual volta voglio calcolare il centro di gravita di un cluster,
  quello che invece dovrei fare è creare una struttura dati che contenga una sola matrice delle distanze e le informazioni
  ausiliarie che mi permettano di utilizzarla
- [ ] Migliorare gestione del file di configurazione

## Futuri sviluppi

- Fare in modo che i mezzi non partano tutti dallo stesso magazzino
- Scoprire se è possibile differenziare i nodi che fanno parte di un centro urbano o meno
        - I nodi possono essere serviti da determinati mezzi in base alla loro posizione
        - Le finestre orarie dei clienti dipende dalla loro posizione
- Fare in modo che i mezzi che partano da un magazzino di un certo cluster possano servire anche 
  i clienti facenti parte di un altro cluster