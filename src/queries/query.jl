#
# Query interface.
#


"""
    QueryEnvironment

Runtime state for query evaluation.
"""
mutable struct QueryEnvironment
    refs::Vector{Pair{Symbol,AbstractVector}}
end


"""
    Query

A query represents a vector function that, given an environment and the input
vector, produces an output vector of the same length.
"""
struct Query
    op
    args::Vector{Any}
    sig::Tuple{AbstractShape,AbstractShape}
    src::Any

end

Query(op, args...) =
    Query(op, collect(Any, args), (NoneShape(), AnyShape()), nothing)

designate(q::Query, sig::Tuple{AbstractShape,AbstractShape}) =
    Query(q.op, q.args, sig, q.src)

designate(ishp::AbstractShape, shp::AbstractShape) =
    q::Query -> designate(q, (ishp, shp))

function (q::Query)(input::AbstractVector)
    input, refs = decapsulate(input)
    env = QueryEnvironment(copy(refs))
    output = q(env, input)
    encapsulate(output, env.refs)
end

(q::Query)(env::QueryEnvironment, input::AbstractVector) =
    q.op(env, input, q.args...)

Layouts.tile(q::Query) =
    Layouts.tile(Layouts.Layout[Layouts.tile(arg) for arg in q.args], brk=("$(nameof(q.op))(", ")"))

show(io::IO, q::Query) =
    pretty_print(io, q)

