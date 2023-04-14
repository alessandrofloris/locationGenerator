using OpenStreetMapX
using OpenStreetMapXPlot
using Plots
import Random

include("DistanceMatrix.jl")
include("Utils.jl")

# TODO: far inserire da linea di comando il path del file .osm da processare.
# Il file dovrà stare nella dir "data". 
map_path = (@__DIR__) * "/../data/cagliariMap.osm"

# Restituisce un oggetto di tipo MapData che contiene codificati tutti i dati contenuti 
# nel file .osm.
# Questo oggetto viene utilizzato per l'analisi dei dati spaziali.
map = get_map_data(map_path) 

# Genero dei punti random all'interno della rete stradale
number_of_points_to_generate = Utils.get_number_of_points_to_generate()
generated_points = Utils.generate_points(map, number_of_points_to_generate)

# Calcolo la matrice delle distanze dei punti generati
distance_matrix = DistanceMatrix.pairwise(OpenStreetMapX.shortest_route, generated_points, map)

# Calcoliamo i punti migliori per i punti di ricarico
number_of_sources = Utils.get_number_of_sources()
partitions = Utils.calc_sources(number_of_sources, generated_points, map)

# Specifico il backend (BE) che voglio utilizzare per la visualizzazione del plot
Plots.gr()

# Crea il plot delle strade data una certa mappa
p = OpenStreetMapXPlot.plotmap(map,width=600,height=400)

# Vogliamo assegnare un colore specifico ad ogni sottocluster
col = ["green", "red", "blue", "black", "orange"]

# Aggiunge al plot dei punti (nodi)
i = 1
for (key, value) in partitions
    median = Vector{Int64}([key])  
    OpenStreetMapXPlot.plot_nodes_as_symbols!(p, map, median, symbols="x", fontsize=15, colors=col[i])
    OpenStreetMapXPlot.plot_nodes_as_symbols!(p, map, value, symbols="o", fontsize=10, colors=col[i])
    global i = i + 1
end

# Chiama il BE per mostrare il plot
display(p)

# Aspetta un new line prima di chiudere il processo
readline()