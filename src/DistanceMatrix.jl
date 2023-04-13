"""
    This implementation for the creation
    of a distance matrix takes a strong 
    inspiration from the library Distance.jl
"""
module DistanceMatrix

using OpenStreetMapX

export pairwise
export distance_matrix

"""
    _pairwise!(r::AbstractMatrix, metric::Function, a::Vector{Int64}, map::MapData)

Calc the distance matrix of a vector `a` according to the function `metric` and 
stores it in the `r` matrix.
"""
function _pairwise!(r::AbstractMatrix, metric::Function, a::Vector{Int64}, map::MapData)
    n = length(a)
    size(r) == (n, n) || throw(DimensionMismatch("Incorrect size of r."))
    @inbounds for (j, aj) in enumerate(a), (i, ai) in enumerate(a)
        r[i, j] = if i > j
            sr, distance, time = metric(map, ai, aj)
            distance
        # Quando i == j si sta cercando di calcolare la distanza tra un punto del vettore
        # e se stesso, dunque questa distanza è sicuramente zero
        elseif i == j 
            zero(eltype(r))
        # Se i < j significa che tutte le distanze tra le possibili
        # coppie sono state calcolate
        else
            r[j, i]
        end
    end
    r
end

"""
    pairwise(metric::Function, a::Vector{Int64}, map::MapData)

Calc the distance matrix of a vector `a` according to the function `metric`
"""
function pairwise(metric::Function, a::Vector{Int64}, map::MapData)
    n = length(a)
    r = Matrix{Float64}(undef,n, n)
    _pairwise!(r, metric, a, map)
    return r
end

function distance_matrix!(r::AbstractMatrix, metric::Function, a::Vector{Int64}, b::Vector{Int64}, map::MapData)
    
    na = length(a)
    nb = length(b)
    size(r) == (na, nb) || throw(DimensionMismatch("Incorrect size of r."))
    
    @inbounds for j = 1:length(b)
        bj = b[j]
        for i = 1:length(a)
            ai = a[i]
            sp, distance, time = metric(map, ai, bj)
            r[i, j] = distance
        end
    end
    r
end

"""
    distance_matrix(metric::Function, a::Number, b::Vector{Number}, map::MapData)

Calc the distance matrix between a point `a` and a vector of points `b` according to the function `metric`
"""
function distance_matrix(metric::Function, a::Int64, b::Vector{Int64}, map::MapData)
    a_vect = Vector{Int64}([a])
    na = length(a_vect)
    nb = length(b)
    r = Matrix{Float64}(undef, na, nb)
    distance_matrix!(r, metric, a_vect, b, map)
    return r
end

end