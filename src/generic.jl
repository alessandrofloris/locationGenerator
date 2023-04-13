using OpenStreetMapX
using OpenStreetMapXPlot
using Plots

"""
++++++++++++++++++++++++++
"""

_eltype(a) = __eltype(Base.IteratorEltype(a), a)
_eltype(::Type{T}) where {T} = eltype(T) === T ? T : _eltype(eltype(T))
_eltype(::Type{Union{Missing, T}}) where {T} = Union{Missing, T}

__eltype(::Base.HasEltype, a) = _eltype(eltype(a))
__eltype(::Base.EltypeUnknown, a) = _eltype(typeof(first(a)))

"""
    result_type(dist, Ta::Type, Tb::Type) -> T
    result_type(dist, a, b) -> T

Infer the result type of metric `dist` with input types `Ta` and `Tb`, or element types
of iterators `a` and `b`.
"""
result_type(dist, a, b, m) = result_type(dist, _eltype(a), _eltype(b), m)
result_type(f, a::Type, b::Type, m) = typeof(f(m, oneunit(a), oneunit(b)))

function _pairwise!(r::AbstractMatrix, metric::Function, a, map::MapData)
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
    pairwise(metric::PreMetric, a)

Calc the distance matrix of a vector 'a' according to the function 'metric'
"""
function pairwise(metric::Function, a, map::MapData)
    n = length(a)
    r = Matrix{Float64}(undef,n, n)
    #r = Matrix{result_type(metric, a, a, map)}(undef, n, n)
    _pairwise!(r, metric, a, map)
    return r
end

"""
++++++++++++++++++++++++++
"""

# TODO: far inserire da linea di comando il path del file .osm da processare.
# Il file dovrà stare nella dir "data". 
map_path = (@__DIR__) * "/../data/cagliariMap.osm"

# Restituisce un oggetto di tipo MapData che contiene codificati tutti i dati contenuti 
# nel file .osm.
# Questo oggetto viene utilizzato per l'analisi dei dati spaziali.
map = get_map_data(map_path) 

# Cose da tenere a mente rispetto alla struttura di un oggetto MapData:
# map.nodes è un dizionario di nodi, ogniuno dei quali rappresenta un oggetto nella mappa (coordinate in ENU)
# map.g è un grafo che rappresenta la rete stradale
# map.v è un dizionario che per ogni nodo associa un vertice del grafo stradale 
# map.n è un vettore che contiene gli id di tutti i nodi
# ...

#= +++++++++++++++++++++++

node1 = map.n[1]
node2 = map.n[36]

node1_cord = LLA(map.nodes[node1], map.bounds)
node2_cord = LLA(map.nodes[node2], map.bounds)

println("$node1 -> $node1_cord")
println("$node2 -> $node2_cord")

+++++++++++++++++++++++++ =#

# Calcola il tragitto più breve tra due nodi facenti parte della mappa.
# Restituisce:
# - una lista dei nodi da attraversare
# - la distanza da percorrere (in metri)
# - il tempo di percorrenza (in secondi)
#sr, distance, time = shortest_route(map, node1, node2)


n_points = 10
points_set = Set{Int64}()
n_nodes = length(map.n)

for i in 1:n_points
    point = rand(1:n_nodes)
    push!(points_set, map.n[point])
end

generated_points = collect(points_set)

"""
    generate_points(map::MapData, n_points::Int)

Generate in a random way 'n_points' from the 
road network of the input map.

    Genero randomicamente N punti all'interno della rete stradale. 
    TODO: Sarebbe più corretto generare questi punti all'interno 
    della mappa?
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

distance_matrix = pairwise(OpenStreetMapX.shortest_route, generated_points, map)

println(distance_matrix)

"""
# Genero la matrice delle distanze dei punti generati
for node1 in generated_points
    for node2 in generated_points
        sr, distance, time = shortest_route(map, node1, node2)
    end
end
"""

#= +++++++++++++++++

# Visualizziamo i punti generati all'interno della mappa

# Specifico il backend (BE) che voglio utilizzare per la visualizzazione del plot
Plots.gr()

# Crea il plot delle strade data una certa mappa
p = OpenStreetMapXPlot.plotmap(map,width=600,height=400)

# Aggiunge al plot dei punti (nodi)
OpenStreetMapXPlot.plot_nodes_as_symbols!(p, map, generated_points, symbols="*")

# Chiama il BE per mostrare il plot
display(p)

# Aspetta un new line prima di chiudere il processo
readline()

++++++++++++++ =#