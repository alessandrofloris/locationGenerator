using OpenStreetMapX
using OpenStreetMapXPlot
using Plots

include("../src/Utils.jl")

map_path = (@__DIR__) * "/../data/cagliariMap.osm"

# Restituisce un oggetto di tipo MapData che contiene codificati tutti i dati contenuti 
# nel file .osm.
# Questo oggetto viene utilizzato per l'analisi dei dati spaziali.
map = get_map_data(map_path) 

# Genero un cluster di punti random all'interno della rete stradale
number_of_points_to_generate = Utils.get_number_of_points_to_generate()
generated_points = Utils.generate_points(map, number_of_points_to_generate)

# Calcolo il centro di gravita del cluster di punti generato
centre_of_gravity_ = Utils.centre_of_gravity(generated_points, map)
# lo inserisco in un vettore in modo da poterlo dare in pasto alla funzione per il plotting
centre_of_gravity = Vector{Int64}([centre_of_gravity_])  

# Specifico il backend (BE) che voglio utilizzare per la visualizzazione del plot
Plots.gr()

# Crea il plot delle strade data una certa mappa
p = OpenStreetMapXPlot.plotmap(map,width=600,height=400)

# Aggiunge al plot dei punti (nodi)
OpenStreetMapXPlot.plot_nodes_as_symbols!(p, map, generated_points, symbols="*", fontsize=10)
OpenStreetMapXPlot.plot_nodes_as_symbols!(p, map, centre_of_gravity, symbols="O", fontsize=20)

# Chiama il BE per mostrare il plot
display(p)

# Aspetta un new line prima di chiudere il processo
readline()