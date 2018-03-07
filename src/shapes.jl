#
# Type system.
#

module Shapes

export
    OPT,
    PLU,
    REG,
    AbstractShape,
    AnyShape,
    BlockShape,
    CapsuleShape,
    Cardinality,
    DecoratedShape,
    FieldShape,
    IndexShape,
    InputShape,
    NativeShape,
    NoneShape,
    OutputShape,
    RecordShape,
    TupleShape,
    bound,
    cardinality,
    class,
    decorate,
    decoration,
    denominalize,
    fits,
    ibound,
    isclosed,
    isoptional,
    isplural,
    isregular,
    syntax,
    undecorate

import Base:
    IndexStyle,
    OneTo,
    convert,
    getindex,
    eltype,
    size,
    show,
    summary,
    &, |, ~

using ..Layouts
import ..Layouts: syntax

include("shapes/sorteddict.jl")
include("shapes/bound.jl")
include("shapes/cardinality.jl")
include("shapes/shape.jl")

end
