using OpenStreetMapX
using OpenStreetMapXPlot
using Plots

include("DistanceMatrix.jl")
include("Utils.jl")
include("Types.jl")
include("Conf.jl")

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
number_of_points_to_generate = Conf.get_number_of_points_to_generate()
generated_points = Utils.generate_points(map, number_of_points_to_generate)

nodes_ready = false

while !nodes_ready

# Calcolo la matrice delle distanze dei punti generati
@info "generating distance matrix"
global dm = DistanceMatrix.distance_matrix(OpenStreetMapX.shortest_route, generated_points, map)
not_reachable_nodes = Utils.find_not_reachable_nodes(dm)
global generated_points = Utils.replace_not_reachable_points(not_reachable_nodes, generated_points, map)

println(not_reachable_nodes)

if length(not_reachable_nodes) == 0
    global nodes_ready = true
end

end

#=dm_n = length(generated_points)

# Stampo in output la matrice delle distanze
output = (@__DIR__) * "/../data/out/dm.txt"
open(output, "w") do io
    write(io, "[\n")
    for i in 1:dm_n
        write(io,"[ ")
        for j in 1:dm_n
            write(io, "$(dm[i,j]) ")    
        end
        write(io,"]\n")
    end
    write(io,"]")
end
=#

# Calcoliamo i nodi migliori per i punti di ricarico
@info "Calculating sink and sources points..."
number_of_sources = Conf.get_number_of_sources()
partitions_ = Utils.calc_sources(number_of_sources, generated_points, map)

partitions = Dict{Int64, Vector{Int64}}()

# Applica un offset ai punti di ricarico (se specificato nel file di configurazione)
offset = Conf.get_offset() 
for (key, value) in partitions_
    new_key = Utils.offset_point(key, offset, map)
    v = pop!(partitions_, key)
    partitions[new_key] = v
end

# Stampo in output le posizioni dei clienti (sink) e dei punti di pick up (sources)
n_sources = length(partitions)

n_sinks = 0
for (key,value) in partitions
    global n_sinks = n_sinks + length(value)
end

@info "Writing in output..."
output = (@__DIR__) * "/../data/out/locations.txt"
open(output, "w") do io

    # number of sources 
    write(io, "$n_sources\n")

    # for each source
    for (key,value) in partitions
        coord = LLA(map.nodes[key], map.bounds)
        write(io, "$(coord.lat),$(coord.lon)\n")
    end

    # number of sinks
    write(io, "$n_sinks\n")  
    
    # for each sink
    for (key,value) in partitions
        for v in value 
            coord = LLA(map.nodes[v], map.bounds)
            write(io, "$(coord.lat),$(coord.lon)\n")
        end
    end

end

"""
++++
"""

nodes = Vector{Int64}()

# Aggiungo le sources
for (key,value) in partitions
    push!(nodes, key)
end

# Aggiungo i sink
for (key,value) in partitions
    for v in value
        push!(nodes, v)
    end
end

# Calcolo la matrice delle distanze dei punti generati
@info "Calculating distance matrix"
dm = DistanceMatrix.distance_matrix(OpenStreetMapX.shortest_route, nodes, map)

dm_n = (n_sinks+n_sources)

"""
++++
"""

# Stampo in output la matrice delle distanze
output = (@__DIR__) * "/../data/out/dm.txt"
open(output, "w") do io
    write(io, "[\n")
    for i in 1:dm_n
        write(io,"[ ")
        for j in 1:dm_n
            write(io, "$(dm[i,j]) ")    
        end
        write(io,"]\n")
    end
    write(io,"]")
end

#=
# Crea il plot delle strade data una certa mappa
@info "Printing map"
p = plotmap(map,width=600,height=400)

# Vogliamo assegnare un colore specifico ad ogni sottocluster
col = ["green", "red", "blue", "black", "orange"]

# Aggiunge al plot dei punti (nodi)
i = 1
for (key, value) in partitions
    median = Vector{Int64}([key])  
    plot_nodes_as_symbols!(p, map, median, symbols="x", fontsize=10, colors=col[i])
    plot_nodes_as_symbols!(p, map, value, symbols="o", fontsize=10, colors=col[i])
    global i = i + 1
end

# Chiama il BE per mostrare il plot
display(p)

# Aspetta un new line prima di chiudere il processo
readline()
=#
