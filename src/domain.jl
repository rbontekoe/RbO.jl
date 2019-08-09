# domain.jl - rbontekoe@appligate.nl

abstract type Information end

"""
    PublisherType

# Values
- NEWSPAPER
- MAGAZINE
- SOCIAL_MEDIA
"""
@enum PublisherType begin
    NEWSPAPER
    MAGAZINE
    SOCIAL_MEDIA
end # defined enumeration for Publisher types

"""
    SubscriberType

# Values
- SUM_CALCULATOR (caluclates the sum of set of data, default value)
- AVG_CALCULATOR (caluclates the average of set of data)
- PLOTTER (keeps the dataset for plotting)
"""
@enum SubscriberType begin
    SUM_CALCULATOR
    AVG_CALCULATOR
    PLOTTER
end # defined enumeration for Subscriber types

"""
    struct Subscriber

# Fields
- name::String
- email::String
- subscribertype::SubscriberType

Instanstiation: see: : [`createSubscriber()`](@ref)
Reference: RbO.Subscriber

# Example
```
julia> function processMessage( s::RbO.Subscriber, n::RbO.Publisher, m::RbO.Message )
           if s.subscribertype == RbO.SUM_CALCULATOR
               println( s.name * " - the sum of the last 5 temperatures is: " * string(sum(m.body)) )
           elseif s.subscribertype == RbO.AVG_CALCULATOR
               println( s.name * " - the average of the last five temperatures is: " * string(sum(m.body) / length(m.body)) )
           elseif s.subscribertype == RbO.PLOTTER
               println( s.name * " - the dataset with the last five temperatures is: " * string(m.body))
               global result = m.body
           end
       end
processMessage (generic function with 1 method)
```
"""
struct Subscriber
    name::String
    email::String
    subscribertype::SubscriberType
    #constructors
    Subscriber( name::String ) = new( name, "", SUM_CALCULATOR )
    Subscriber( name::String, email::String ) = new( name, email, SUM_CALCULATOR )
    Subscriber( name::String, email::String, subscribertype::SubscriberType ) = new( name, email, subscribertype )
end # efine Scubscriber object

"""
    struct Publisher

# Fields
- name              ::  String
- subscribertype    ::  SubscriberType
- list              ::  Array{Subscriber, 1}

Instanstiate: see: : [`createPublisher()`](@ref)
Reference: RbO.Publisher

# Example
```
julia> function processMessage( s::RbO.Subscriber, n::RbO.Publisher, m::RbO.Message )
           if s.subscribertype == RbO.SUM_CALCULATOR
               println( s.name * " - the sum of the last 5 temperatures is: " * string(sum(m.body)) )
           elseif s.subscribertype == RbO.AVG_CALCULATOR
               println( s.name * " - the average of the last five temperatures is: " * string(sum(m.body) / length(m.body)) )
           elseif s.subscribertype == RbO.PLOTTER
               println( s.name * " - the dataset with the last five temperatures is: " * string(m.body))
               global result = m.body
           end
       end
processMessage (generic function with 1 method)
```

"""
struct Publisher
    name::String
    publishertype::PublisherType
    list::Array{Subscriber, 1}
end # defined Publisher object

"""
    struct Publisher

# Fields
- header    ::  String
- subject   ::  String
- body      ::  Array{Float64, 1}

Instanstiate: see: : [`createMessage()`](@ref)
Reference: RbO.Publisher

# Example
```
message = createMessage( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )

```
"""
struct Message <: Information
    header::String
    subject::String
    body::Array{Float64, 1}
end # defined Message object
