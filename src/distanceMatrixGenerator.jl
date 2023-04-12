"""
    pairwise!(r::AbstractMatrix, metric::PreMetric,
              a::AbstractMatrix, b::AbstractMatrix=a; dims)
Compute distances between each pair of rows (if `dims=1`) or columns (if `dims=2`)
in `a` and `b` according to distance `metric`, and store the result in `r`.
If a single matrix `a` is provided, compute distances between its rows or columns.
`a` and `b` must have the same numbers of columns if `dims=1`, or of rows if `dims=2`.
`r` must be a matrix with size `size(a, dims) × size(b, dims)`.

"""
# Noi dobbiamo passare come dims sempre 2 (il numero di righe deve matchare)
function pairwise!(r::AbstractMatrix, metric::PreMetric,
                   a::AbstractMatrix, b::AbstractMatrix;
                   dims::Union{Nothing,Integer}=nothing)
    
    dims = deprecated_dims(dims)
    dims in (1, 2) || throw(ArgumentError("dims should be 1 or 2 (got $dims)"))
    
    if dims == 1
        na, ma = size(a) # size() -> n_rows, n_cols
        nb, mb = size(b)
        ma == mb || throw(DimensionMismatch("The numbers of columns in a and b " *
                                            "must match (got $ma and $mb)."))
    else
        ma, na = size(a)
        mb, nb = size(b)
        ma == mb || throw(DimensionMismatch("The numbers of rows in a and b " *
                                            "must match (got $ma and $mb)."))
    end

    size(r) == (na, nb) ||
        throw(DimensionMismatch("Incorrect size of r (got $(size(r)), expected $((na, nb)))."))
    
    if dims == 1
        _pairwise!(r, metric, permutedims(a), permutedims(b))
    else
        _pairwise!(r, metric, a, b)
    end

end

function _pairwise!(r::AbstractMatrix, metric::PreMetric,
    a::AbstractMatrix, b::AbstractMatrix=a)
    require_one_based_indexing(r, a, b)
    na = size(a, 2)
    nb = size(b, 2)
    size(r) == (na, nb) || throw(DimensionMismatch("Incorrect size of r."))
    @inbounds for j = 1:size(b, 2)
    bj = view(b, :, j)
    for i = 1:size(a, 2)
    r[i, j] = metric(view(a, :, i), bj)
    end
    end
    r
end