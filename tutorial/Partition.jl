using OpenStreetMapX
using OpenStreetMapXPlot
using Plots
import Random

include("../src/Utils.jl")

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

# Scelgo 3 punti cardine da cui sviluppare le partizioni
sources = generated_points[1:3]

partition = Utils.partition(sources, generated_points, map)

# Specifico il backend (BE) che voglio utilizzare per la visualizzazione del plot
Plots.gr()

# Crea il plot delle strade data una certa mappa
p = OpenStreetMapXPlot.plotmap(map,width=600,height=400)

# Vogliamo assegnare un colore specifico ad ogni sottocluster
col = ["green", "red", "blue", "black", "orange"]

# Aggiunge al plot dei punti (nodi)
for (key, value) in partition
    Random.seed!(key)
    a = rand(1:5)
    median = Vector{Int64}([key])  
    OpenStreetMapXPlot.plot_nodes_as_symbols!(p, map, median, symbols="x", fontsize=15, colors=col[a])
    OpenStreetMapXPlot.plot_nodes_as_symbols!(p, map, value, symbols="o", fontsize=10, colors=col[a])
end

# Chiama il BE per mostrare il plot
display(p)

# Aspetta un new line prima di chiudere il processo
readline()