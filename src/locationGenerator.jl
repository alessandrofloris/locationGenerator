using OpenStreetMapX
using OpenStreetMapXPlot
using Plots

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
    Generate in a random way n_points from the 
    road netword of the input map
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

# Genero randomicamente N punti all'interno della rete stradale. 
# TODO: Sarebbe più corretto generare questi punti all'interno 
# della mappa?
generated_points = generate_points(map, 5)

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
