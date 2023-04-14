"""
    This implementation takes inspiration from 
    the library Distance.jl

    @TODO Make this more general and utilized also for Euclidean and Manatthan distance
"""
module DistanceMatrix

using OpenStreetMapX

export distance_matrix

"""
Calc the distance matrix of a vector `a` according to the function `metric` and 
stores it in the `r` matrix.
"""
function _distance_matrix!(r::AbstractMatrix, metric::Function, a::Vector{Int64}, map::MapData)
    n = length(a)
    size(r) == (n, n) || throw(DimensionMismatch("Incorrect size of r."))
    @inbounds for (j, aj) in enumerate(a), (i, ai) in enumerate(a)
        r[i, j] = if i > j
            sr, distance, time = metric(map, ai, aj)
            distance
        elseif i == j 
            zero(eltype(r))
        else
            r[j, i]
        end
    end
end

"""
Calc the distance matrix of a vector `a` and a vector `b` according to the function `metric` and 
stores it in the `r` matrix.
"""
function _distance_matrix!(r::AbstractMatrix, metric::Function, a::Vector{Int64}, b::Vector{Int64}, map::MapData)
    na = length(a)
    nb = length(b)
    size(r) == (na, nb) || throw(DimensionMismatch("Incorrect size of r."))
    @inbounds for j = 1:length(b)
        for i = 1:length(a)
            sp, distance, time = metric(map, a[i], b[j])
            r[i, j] = distance
        end
    end
end

"""
Calc the distance matrix between a point `a` and a vector of points `b` according to the function `metric`
"""
function distance_matrix(metric::Function, a::Int64, b::Vector{Int64}, map::MapData)
    a_vect = Vector{Int64}([a])
    na = length(a_vect)
    nb = length(b)
    r = Matrix{Float64}(undef, na, nb)
    _distance_matrix!(r, metric, a_vect, b, map)
    return r
end

"""
Calc the distance matrix of a vector `a` according to the function `metric`
"""
function distance_matrix(metric::Function, a::Vector{Int64}, map::MapData)
    n = length(a)
    r = Matrix{Float64}(undef,n, n)
    _distance_matrix!(r, metric, a, map)
    return r
end

end