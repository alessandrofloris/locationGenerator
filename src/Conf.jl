module Conf

export get_number_of_points_to_generate
export get_number_of_sources
export get_offset

include("Types.jl")

"""
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
Reads a configuration file and return the value 
that specifies the number of requested sources 
"""
function get_number_of_sources()
    n = 0
    conf_path = (@__DIR__) * "/../conf/conf"
    open(conf_path) do io
        readline(io) # scartiamo la prima riga
        line = readline(io)
        conf = split(line, " ")
        n = parse(Int, conf[2])
    end
    return n
end

"""
Reads a configuration file and return the value 
that specifies the offset for the sources (if specified)
"""
function get_offset()
    offset = Types.Offset()
    conf_path = (@__DIR__) * "/../conf/conf"
    open(conf_path) do io
        readline(io) # scartiamo la prima riga
        readline(io) # scartiamo la seconda riga
        line = readline(io)
        conf = split(line, " ")
        offset.east = parse(Int, conf[2])
        offset.north = parse(Int, conf[3])
    end
    return offset
end

end