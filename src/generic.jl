using OpenStreetMapX
using OpenStreetMapXPlot
using Plots


"""
    _pairwise!(r::AbstractMatrix, metric::Function, a::Vector{Int64}, map::MapData)

Calc the distance matrix of a vector `a` according to the function `metric` and 
stores it in the `r` matrix.
"""
function _pairwise!(r::AbstractMatrix, metric::Function, a::Vector{Int64}, map::MapData)
    n = length(a)
    size(r) == (n, n) || throw(DimensionMismatch("Incorrect size of r."))
    @inbounds for (j, aj) in enumerate(a), (i, ai) in enumerate(a)
        r[i, j] = if i > j
            sr, distance, time = metric(map, ai, aj)
            distance
        # Quando i == j si sta cercando di calcolare la distanza tra un punto del vettore
        # e se stesso, dunque questa distanza è sicuramente zero
        elseif i == j 
            zero(eltype(r))
        # Se i < j significa che tutte le distanze tra le possibili
        # coppie sono state calcolate
        else
            r[j, i]
        end
    end
    r
end

"""
    pairwise(metric::Function, a::Vector{Int64}, map::MapData)

Calc the distance matrix of a vector `a` according to the function `metric`
"""
function pairwise(metric::Function, a::Vector{Int64}, map::MapData)
    n = length(a)
    r = Matrix{Float64}(undef,n, n)
    _pairwise!(r, metric, a, map)
    return r
end

# TODO: far inserire da linea di comando il path del file .osm da processare.
# Il file dovrà stare nella dir "data". 
map_path = (@__DIR__) * "/../data/cagliariMap.osm"

# Restituisce un oggetto di tipo MapData che contiene codificati tutti i dati contenuti 
# nel file .osm.
# Questo oggetto viene utilizzato per l'analisi dei dati spaziali.
map = get_map_data(map_path) 

"""
    generate_points(map::MapData, n_points::Int)

Generate in a random way `n_points` from the 
road network of the input map.
 
TODO: Sarebbe più corretto generare questi punti all'interno 
della mappa? Ossia non solo punti che fanno parte della rete stradale, 
ma quindi magari considerare anche i nodi degli edifici ecc.
"""
function generate_points(map::MapData, n_points::Int) 

    points_set = Set{Int64}()
    n_nodes = length(map.n)
    
    # Aggiungere controllo per sapere se un punto 
    # fa gia parte dell'insieme
    for i in 1:n_points
        index = rand(1:n_nodes)
        point = map.n[index]
        push!(points_set, point)
    end
    
    return collect(points_set)
end

generated_points = generate_points(map, 5)

# Calcolo la matrice delle distanze dei punti generati
distance_matrix = pairwise(OpenStreetMapX.shortest_route, generated_points, map)

println(distance_matrix)