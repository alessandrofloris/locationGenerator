# LocationGenerator

Dato un file OSM contenente le informazioni spaziali di una certa zona geografica calcola 
un cluster di potenziali clienti e un insieme di punti di pick up (utilizzando l'algoritmo 
di Maranzano per la risoluzione del p-problem)

Per la gestione dei dati spaziali utilizziamo OpenStreetMapX.
Per la visualizzazione dei punti e delle rotte utilizziamo OpenStreetMapXPlot e Plots (con GR come BE).

## Cose da fare 

- [X] Dato un file OSM trasformarlo in un grafo stradale
- [X] Prendere due nodi random che fanno parte del grafo e calcolare lo shortest path tra i due 
- [X] Disegnare la route tra due nodi
- [X] Calcolare la matrice delle distanze
- [ ] Utilizzare l'algoritmo di Maranzana per calcolare le p-mediane

## Futuri sviluppi

In questo momento i nodi cliente vengono generati in maniera totalmente randomica all'interno del grafo.
Un possibile sviluppo futuro sarebbe quello di utilizzare diverse distribuzioni per la 
genereazione di questi punti.

## Algoritmo di Maranzana

P = insieme di nodi 
d(i,j) = la distanza tra due nodi pi e pj (collegati direttamente, quindi che non tiene conto di punti intermedi)

Attenzione, nel paper si suppone che d(i,j) = d(j,i) cosa che nel nostro caso non è per forza vero

d(i,j) = inf quando non esiste un percorso diretto tra pi e pj

Attenzione, nel paper si suppone che esista sempre un percorso diretto tra due nodi(?)

wi = peso (quantita richiesta) dal nodo pi

source = è un nodo in cui è situato un punto di ricarico

sink = un nodo che ha una domanda da soddisfare

### Modelliamo il problema in termini matematici:

Quello che abbiamo:

P è un insieme di n punti, p1, ..., pn
W è un insieme di n pesi associati a ogni punto appartenente a p, w1, ..., wn
M è una matrice delle distanze

Quello che vogliamo ottenere: 

m punti source, px1, ..., pxm
Una partizione di P in m sottoinsiemi di punti sink, Px1, ..., Pxm serviti rispettivamente dagli m punti source

pj è un centro di gravita di Q, che è sottoinsieme di P, se la sommatoria delle distanze tra pj e tutti i punti di Q 
è minore o uguale alla sommatoria delle distanze tra pi e tutti i punti di Q per qualsiasi valore i.


### Algoritmo

- Step 1 
        Seleziona in maniera arbitraria m punti dall'insieme dei nodi,
        e assegna questi m punti a una array pxi

- Step 2
        Per ogni valore di pxi determinare la corrispondente partizione
        a partire dall'insieme dei nodi, quindi ottenenedo Px1, ..., Pxm

- Step 3
        Determinare un centro di gravita cx per ogni partizione Pxi

- Step 4
        Se cxi = pxi per ogni i, la computazione viene interrota, e i valori correnti
        di pxi e Pxi costituiscono la soluzione desiderata
        Se cxi != pxi, allora setta pxi = cxi e riparti dallo step 2

