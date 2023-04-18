using OpenStreetMapX
using OpenStreetMapXPlot
using Plots

include("DistanceMatrix.jl")
include("Utils.jl")

# TODO: far inserire da linea di comando il path del file .osm da processare.
# Il file dovrà stare nella dir "data". 
map_path = (@__DIR__) * "/../data/cagliariMap.osm"

# Restituisce un oggetto di tipo MapData che contiene codificati tutti i dati contenuti 
# nel file .osm.
# Questo oggetto viene utilizzato per l'analisi dei dati spaziali.
@info "Converting osm data to a graph..."
map = get_map_data(map_path) 

# Genero dei punti random all'interno della rete stradale
@info "Generating points from the graph..."
number_of_points_to_generate = Utils.get_number_of_points_to_generate()
generated_points = Utils.generate_points(map, number_of_points_to_generate)

# Calcolo la matrice delle distanze dei punti generati
dm = DistanceMatrix.distance_matrix(OpenStreetMapX.shortest_route, generated_points, map)

# Calcoliamo i nodi migliori per i punti di ricarico
@info "Calculating sink and sources points..."
number_of_sources = Utils.get_number_of_sources()
partitions = Utils.calc_sources(number_of_sources, generated_points, map)

# Stampo in output le posizioni dei clienti (sink) e dei punti di pick up (sources)
n_sources = length(partitions)

@info "Writing in output..."
output = (@__DIR__) * "/../data/out/output.txt"
open(output, "w") do io

    # number of sources 
    write(io, "$n_sources\n")

    # for each source
    for (key,value) in partitions
        coord = LLA(map.nodes[key], map.bounds)
        write(io, "$(coord.lat),$(coord.lon)\n")
        
        # number of sinks
        n_sinks = length(value)
        write(io, "$n_sinks\n")

        # for each sink served by the current source
        for v in value
            coord = LLA(map.nodes[v], map.bounds)
            write(io, "$(coord.lat),$(coord.lon)\n")
        end
    end

end

#=
# Crea il plot delle strade data una certa mappa
p = plotmap(map,width=600,height=400)

# Vogliamo assegnare un colore specifico ad ogni sottocluster
col = ["green", "red", "blue", "black", "orange"]

# Aggiunge al plot dei punti (nodi)
i = 1
for (key, value) in partitions
    median = Vector{Int64}([key])  
    plot_nodes_as_symbols!(p, map, median, symbols="x", fontsize=15, colors=col[i])
    plot_nodes_as_symbols!(p, map, value, symbols="o", fontsize=10, colors=col[i])
    global i = i + 1
end

# Chiama il BE per mostrare il plot
display(p)

# Aspetta un new line prima di chiudere il processo
readline()
=#