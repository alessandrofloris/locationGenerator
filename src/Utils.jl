module Utils

using OpenStreetMapX

include("DistanceMatrix.jl")

export generate_points
export calc_sources
export offset_point
export find_not_reachable_nodes

"""
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

"""
Determines a centre of gravity for a cluster of points

@Return a point that is the center of gravity of the cluster in input
"""
function centre_of_gravity(cluster::Vector{Int64}, map::MapData) 
    
    centre_of_gravity = 0
    centre_of_gravity_cost = Base.Inf

    """
        Se per caso esiste un punto che non è raggiungibile da 
        tutti gli altri, allora non verra trovato nessun centro di gravità 
        dunque il programma fallirà
    """
    for point in cluster
    
        dm = DistanceMatrix.distance_matrix(OpenStreetMapX.shortest_route, point, cluster, map)
        
        cost = sum(+, dm)
        
        if cost < centre_of_gravity_cost
            centre_of_gravity = point
            centre_of_gravity_cost = cost
        end
    
    end

     return centre_of_gravity
end

"""
Calculates a partition of the cluster based on the sources points

@Return a dictionary where the keys are the medians of the sub cluster, and the value are the points
of the sub cluster 
"""
function partition(sources::Vector{Int64}, cluster::Vector{Int64}, map::MapData)

    partition = Dict{Int64, Vector{Int64}}()
    for v in sources
        partition[v] = Vector{Int64}()
    end

    """
        Se esiste un punto che non è raggiungibile dagli altri nodi,
        esso non può essere messo in nessuna partizione.

        Una soluzione temporanea sarebbe quella di metterlo
        nella partizione della source la cui distanza eucliedea 
        è la minore (rimarrebbe comunque il problema nella matrice
        delle distanze) 
    """
    for point in cluster 
        min_distance = Base.Inf
        index_source = 0
        for source in sources
            sr, distance, time = shortest_route(map, source, point)
            distance = distance
            if distance < min_distance
                min_distance = distance
                index_source = source
            end
        end
        # TODO: da rimuovere
        if index_source != 0
            push!(partition[index_source], point)
        else 
            @warn "Distanza infinita: $point"
        end
    end

    return partition
end

"""
Calculate `m` sources (pick up points), and their
respective partitions given a set `p` of points in a network (maranzana algorithm implementation)

@Return `partitions = Dict{Int64, Vector{Int64}}` dove la chiave è la mediana del sotto cluster, e il valore è il sotto cluster 
"""
function calc_sources(number_of_sources::Int, cluster::Vector{Int64}, map::MapData)
    
    # Eseguire un controllo sul numero richiesto di sources e il numero di nodi

    sources = cluster[1:number_of_sources]

    partition_ = Dict{Int64, Vector{Int64}}()

    while true
        partition_ = partition(sources, cluster, map)

        medians = Dict{Int64, Int64}()
        for (key,value) in partition_
            medians[key] = key
        end

        for (key, value) in partition_
            medians[key] = centre_of_gravity(value, map)
        end

        solution_found = true 

        for (i, key_value) in enumerate(medians)
            if key_value[1] != key_value[2] 
                solution_found = false
                sources[i] = key_value[2]
            else 
                sources[i] = key_value[1]
            end
        end

        if solution_found
            break
        end
    end

    # Elimino dalle partizioni il centro di gravità
    for (key,value) in partition_
        partition_[key] = filter(x -> x != key ,partition_[key])
    end

    return partition_
end



"""
Calculates a new point in the graph according to a starting point 
and a given offset (N,W,E,S) 

@Returns a new point in the graph  
"""
function offset_point(point, offset, map)
    
    # Usiamo la funzione di OpenStreetMapX nearest_node(map.nodes, node.ENU)
    point_enu_ = map.nodes[point]
    point_enu = OpenStreetMapX.ENU((point_enu_.east + offset.east), (point_enu_.north+offset.north), 0)
    new_point = OpenStreetMapX.nearest_node(map.nodes, point_enu)

    return new_point 

end 

"""
Given a distance matrix and a vector that contains the points 
used to create the dm, returns a vector of indexes.

Those indexes indicate where not rechable nodes are in the 
vectors that contains the points.

@Returns a vector of indexes of the not reachable nodes
"""
function find_not_reachable_nodes(dm)

    not_reachable_points = Vector{Int}()

    n = size(dm,1)

    for i in 1:n
        inf_found = false
        for j in 1:n
            if dm[i,j] == Base.Inf
                inf_found = true
                break
            end
        end
        if inf_found
            push!(not_reachable_points,i)
        end
    end

    return not_reachable_points
end

"""
Genereta N points, where N is the lenght of the vector `not_reachable_points`,
and replaces them in the `generated_points` vector
"""
function replace_not_reachable_points(not_reachable_nodes, generated_points, map)
    n = length(not_reachable_nodes)
    new_nodes = generate_points(map, n)
    for i in 1:n
        generated_points[not_reachable_nodes[i]] = new_nodes[i]
    end
    return generated_points
end

end