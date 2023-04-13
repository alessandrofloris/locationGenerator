module DistanceMatrix

using OpenStreetMapX

export pairwise

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

end