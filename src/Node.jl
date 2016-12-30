"""
    Node(name, value, first, last, children, ruleType)
Node in the Abstract Syntax Tree generated by parsing according to a specified grammar.

`name` gives the name of the rule in the grammar.
`value` contains the complete String represented by this node and all its children.
`first` position of the first character matched by this node and its children within the parsed string
`last` position of the last character matched by this node and its children within the parsed string
`children`: Array of child-nodes
Creation adds the additional field `sym` containing the name as a Symbol.
"""
immutable Node
    name::AbstractString
    value::AbstractString
    first::Int
    last::Int
    children::Array #::Array{Node}
    ruleType::Type
    sym::Any

# This always exists by default
#    Node(node::Node) =
#        new(node.name, node.value, node.first, node.last, node.children, node.ruleType, node.sym)

    Node(name::AbstractString, value::AbstractString, first::Int, last::Int, children::Array, ruleType::Type) =
     new(name,                 value,                 first,      last,      children,        ruleType,
            length(name)==0 ? nothing : symbol(name))
end

Node(name::AbstractString, value::AbstractString, first::Int, last::Int, typ) =
    Node(name, value, first, last, [], typ)

show{T}(io::IO, val::T, indent) = println(io, "$val ($(typeof(val)))")

# by default don't show anything
displayValue{T <: Rule}(value, ::Type{T}) = ""
# except for terminals and regex
displayValue(value, ::Type{Terminal}) = "'$value',"
displayValue(value, ::Type{RegexRule}) = "'$value',"
displayValue(value, ::Type{IntegerRule}) = "$value,"
displayValue(value, ::Type{FloatRule}) = "$value,"

function show(io::IO, node::Node, indent)
  println(io, "node($(node.name)) {$(displayValue(node.value, node.ruleType))$(node.ruleType)}")
  if isa(node.children, Array)
    for (i, child) in enumerate(node.children)
      print(io, "  "^indent)
      print(io, "$i: ")
      show(io, child, indent+1)
    end
  else
    print(io, "  "^(indent+1))
    show(io, node.children, indent+1)
  end
end

show(io::IO, node::Node) = show(io, node, 0)
