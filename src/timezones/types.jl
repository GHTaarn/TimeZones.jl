
# import Base.Dates: UTInstant, DateTime, TimeZone, Millisecond
using Base.Dates
import Base.Dates: UTInstant, UTM

# Using type Symbol instead of AbstractString for name since
# gets us ==, and hash for free.
immutable FixedTimeZone <: TimeZone
    name::Symbol
    offset::UTInstant{Millisecond}  # Maybe just Second?
end

FixedTimeZone(name::String, offset::Int) = FixedTimeZone(symbol(name), UTM(offset))

immutable Transition
    utc_datetime::DateTime
    zone::FixedTimeZone
end

Base.isless(x::Transition,y::Transition) = isless(x.utc_datetime,y.utc_datetime)

# function Base.string(t::Transition)
#     return "$(t.utc_datetime), $(t.zone.name), $(t.zone.offset)"
# end

immutable VariableTimeZone <: TimeZone
    name::Symbol
    transitions::Vector{Transition}
end

function VariableTimeZone(name::String, transitions::Vector{Transition})
    return VariableTimeZone(symbol(name), transitions)
end

Base.show(io::IO, tz::VariableTimeZone) = print(io, string(tz.name))