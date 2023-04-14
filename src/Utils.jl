module Utils

using OpenStreetMapX

include("DistanceMatrix.jl")

export generate_points
export calc_sources
export centre_of_gravity # TODO: da rimuovere
export partition # TODO: da rimuovere


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

"""
    get_number_of_points_to_generate()
Reads a configuration file and return the value 
that specifies the number of points to be generated
"""
function get_number_of_points_to_generate()
    n = 0
    conf_path = (@__DIR__) * "/../conf/conf"
    open(conf_path) do io
        line = readline(io)
        conf = split(line, " ")
        n = parse(Int, conf[2])
    end
    return n
end

"""
    centre_of_gravity(points::Vector{Int64}, map::MapData) 
Determines a centre of gravity for a cluster of points

@Return the point that is the centre of gravity of the cluster
"""
function centre_of_gravity(points::Vector{Int64}, map::MapData) 
    
    current_centre_of_gravity = 0
    current_centre_of_gravity_cost = Base.Inf

    for point in points
    
        dm = DistanceMatrix.distance_matrix(OpenStreetMapX.shortest_route, point, points, map)

        cost = sum(+, dm)
        
        if cost < current_centre_of_gravity_cost
            current_centre_of_gravity = point
            current_centre_of_gravity_cost = cost
        end
    
    end

    # TODO: dovremmo lanciare un eccezzione se current_center_of_gravity rimane 0
    # E' una situazione che accade spesso, ed è provocata dalla presenza di 
    # una distanza tra i punti che vale infinito.
    # Quello che bisogna fare è capire quando la metrica resitiusce Inf 
    # per la distanza di due punti, e poi vedere come procedere
    return current_centre_of_gravity

end

function partition(sources::Vector{Int64}, nodes::Vector{Int64}, map::MapData)

    partition = Dict{Int64, Vector{Int64}}()
    for v in sources
        partition[v] = Vector{Int64}()
    end

    for point in nodes 
        min_distance = Base.Inf
        index_source = 0
        for source in sources
            sr, distance, time = shortest_route(map, point, source) # dovrei calcolare la distanza tra il point e la source o viceversa?
            distance = distance
            if distance < min_distance
                min_distance = distance
                index_source = source
            end
        end
        # TODO: da rimuovere
        if index_source != 0
            push!(partition[index_source], point) # aggiungere una gestione delle eccezzioni nel caso l'indice sia 0
        end
    end

    return partition
end

"""
    calc_sources(number_of_sources::Int, nodes::Vector{Int64})
Calculate `m` sources (pick up points), and their
respective partitions given a set `p` of points in a network

@Return\n
`sources = Vector{Int64}` (conterra l'id dei nodi)\n
`partitions = Matrix{Int64}` (ogni riga contiene l'id dei sink serviti da un source) 
"""
function calc_sources(number_of_sources::Int, nodes::Vector{Int64}, map::MapData)
    
    # Eseguire un controllo sul numero richiesto di sources e il numero di nodi

    # Implementazione dell'algoritmo di Maranzana

    #Step 1 
        # Seleziona in maniera arbitraria m punti dall'insieme dei nodi,
        # e assegna questi m punti a una array pxi

    sources = nodes[1:number_of_sources]

    #Step 2
        # Per ogni valore di pxi determinare la corrispondente partizione
        # a partire dall'insieme dei nodi, quindi ottenenedo Px1, ..., Pxm
    
    partitions = partition(sources, nodes)

    #Step 3
        # Determinare un centro di gravita cx per ogni partizione Pxi

    #Step 4
        # Se cxi = pxi per ogni i, la computazione viene interrota, e i valori correnti
        # di pxi e Pxi costituiscono la soluzione desiderata
        # Se cxi != pxi, allora setta pxi = cxi e riparti dallo step 2
end

end