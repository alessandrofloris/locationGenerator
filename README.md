# locationGenerator

Dato un file OSM che contiene delle informazioni spaziali riguardo una certa zona 
geografica si occupa di creare una matrice delle distanze e una serie di punti (utilizzando
il p-median algorithm).

Per la gestione dei dati spaziali utilizziamo OpenStreetMapX.
Per la visualizzazione dei punti e delle rotte utilizziamo OpenStreetMapXPlot e Plots (con GR come BE).

## Cose da fare 

- [X] Dato un file OSM trasformarlo in un grafo stradale
- [X] Prendere due nodi random che fanno parte del grafo e calcolare lo shortest path tra i due 
- [X] Disegnare la route tra due nodi
- [ ] Calcolare la matrice delle distanze
- [ ] Utilizzare l'algoritmo di Maranzana per calcolare le p-mediane