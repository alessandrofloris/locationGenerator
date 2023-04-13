"""
    result_type(dist, Ta::Type, Tb::Type) -> T
    result_type(dist, a, b) -> T

Infer the result type of metric `dist` with input types `Ta` and `Tb`, or element types
of iterators `a` and `b`.
"""
result_type(dist, a, b) = result_type(dist, _eltype(a), _eltype(b))
result_type(f, a::Type, b::Type) = typeof(f(oneunit(a), oneunit(b))) # don't require `PreMetric` subtyping

function _pairwise!(r::AbstractMatrix, metric::SemiMetric, a)
   
    n = length(a)
   
    size(r) == (n, n) || throw(DimensionMismatch("Incorrect size of r."))
   
    @inbounds for (j, aj) in enumerate(a), (i, ai) in enumerate(a)

        r[i, j] = if i > j
            metric(ai, aj)
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
    pairwise(metric::PreMetric, a)

Calc the distance matrix of a vector 'a' according to the function 'metric'
"""
function pairwise(metric, a)
    n = length(a)
    r = Matrix{result_type(metric, a, a)}(undef, n, n)
    _pairwise!(r, metric, a)
    return r
end