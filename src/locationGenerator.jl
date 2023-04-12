using OpenStreetMapX

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

node1 = map.n[1]
node2 = map.n[36]

node1_cord = LLA(map.nodes[node1], map.bounds)
node2_cord = LLA(map.nodes[node2], map.bounds)

println("$node1 -> $node1_cord")
println("$node2 -> $node2_cord")

# Calcola il tragitto più breve tra due nodi facenti parte della mappa.
# Restituisce:
# - una lista dei nodi da attraversare
# - la distanza da percorrere (in metri)
# - il tempo di percorrenza (in secondi)
sr, distance, time = shortest_route(map, node1, node2)

println("Distance: $distance, Time: $time")
