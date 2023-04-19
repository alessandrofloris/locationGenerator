module Types

export Offset

mutable struct Offset
    east::Float64
    north::Float64
    Offset() = new()
end

end