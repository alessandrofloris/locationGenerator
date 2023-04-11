using OpenStreetMapX
using StableRNGs

map_path = (@__DIR__) * "/../data/cagliariMap.osm"
#map_path = (@__DIR__) * "/../data/map.osm"
map_data = get_map_data(map_path)

println("The map contains $(length(map_data.nodes)) nodes")

rng = StableRNGs.StableRNG(1234)

pA = generate_point_in_bounds(rng, map_data)
pB = generate_point_in_bounds(rng, map_data)

println("puntoA: $pA")
println("puntoB: $pB")

pointA = point_to_nodes(pA, map_data)
pointB = point_to_nodes(pB, map_data)

println("puntoA: $pointA")
println("puntoB: $pointB")

sr = shortest_route(map_data, pointA, pointB; routing = :dijkstra)

println(sr)

println(map_data.w)