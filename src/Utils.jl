module Utils

using OpenStreetMapX

export generate_points
export calc_sources

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
    calc_centre_of_gravity(nodes::Vector{Int64})
Determines a centre of gravity for the set of point 
passed to the function

@Return\n 
Returns the id of the node that is the centre of gravity
"""
function calc_centre_of_gravity(nodes::Vector{Int64}) 

end

"""
    calc_sources(number_of_sources::Int, nodes::Vector{Int64})
Calculate `m` sources (pick up points), and their
respective partitions given a set `p` of points in a network

@Return\n
`sources = Vector{Int64}` (conterra l'id dei nodi)\n
`partitions = Matrix{Int64}` (ogni riga contiene l'id dei sink serviti da un source) 
"""
function calc_sources(number_of_sources::Int, nodes::Vector{Int64})
    
    # Implementazione dell'algoritmo di Maranzana

    #Step 1 
        # Seleziona in maniera arbitraria m punti dall'insieme dei nodi,
        # e assegna questi m punti a una array pxi

    #Step 2
        # Per ogni valore di pxi determinare la corrispondente partizione
        # a partire dall'insieme dei nodi, quindi ottenenedo Px1, ..., Pxm
    
    #Step 3
        # Determinare un centro di gravita cx per ogni partizione Pxi

    #Step 4
        # Se cxi = pxi per ogni i, la computazione viene interrota, e i valori correnti
        # di pxi e Pxi costituiscono la soluzione desiderata
        # Se cxi != pxi, allora setta pxi = cxi e riparti dallo step 2
end

end