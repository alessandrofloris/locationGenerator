module Utils

using OpenStreetMapX

export generate_points

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

end