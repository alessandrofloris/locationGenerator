using OpenStreetMapX

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