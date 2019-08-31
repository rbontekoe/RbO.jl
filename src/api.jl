# api.jl - rbontekoe@appligate.nl
include("domain.jl")

### Domain objects
export Subscriber, Publisher, Message
### SubscriberType Values
export MEAN_CALCULATOR, STD_CALCULATOR, PLOTTER
### PublisherType Values
export NEWSPAPER, MAGAZINE, SOCIAL_MEDIA

"""
    createPublisher( name::String )

# Arguments
- `name::String`: name of the Publisher (mandatory).
- `publishertype::PublisherType`: see: [`PublisherType()`](@ref).

# Examples
```
julia> chronicals = createPublisher( "the Duck Chronicals" )
Publisher("the Duck Chronicals", NEWSPAPER::PublisherType = 0, Subscriber[])
```
"""
createPublisher( name::String )::Publisher =
        name != "" ? Publisher( name, NEWSPAPER, Array{Subscriber}(undef, 0) ) : throw(MissingException("Publisher name is mandatory"))

"""
    createPublisher( name::String, publishertype::PublisherType )

Returns a Publisher object
- name: name of the Publisher (mandatory)
- publishertype: PublisherType
Exception: MissingException

```
julia> chronicals = createPublisher( "the Duck Chronicals" )
Publisher("the Duck Chronicals", NEWSPAPER::PublisherType = 0, Subscriber[])
```
"""
createPublisher( name::String, publishertype::PublisherType )::Publisher =
        name != "" ? Publisher( name, publishertype, Array{Subscriber}(undef, 0) ) : throw(MissingException("Publisher name is mandatory"))




"""
    subscribe( p::Publisher, s::Subscriber )

Adds a subscriber to the list with subscribers

# Example

```
julia> scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER )
Subscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER::SubscriberType = 2)

julia> chronicals = createPublisher( "the Duck Chronicals" )
Publisher("the Duck Chronicals", NEWSPAPER::PublisherType = 0, Subscriber[])

julia> subscribe( chronicals, scrooge )
Publisher("the Duck Chronicals", NEWSPAPER::PublisherType = 0, Subscriber[Subscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER)])
```
"""
subscribe( p::Publisher, s::Subscriber ) =
    Publisher( p.name, p.publishertype, push!( p.list, s ) )

"""
    unsubscribe( p::Publisher, s::Subscriber )

Removes a subscriber from the list

# Example

nyt = createPublisher( "nyt" )

scrooge = createSubscriber( "Scrooge McDuck" [, "scrooge@duckcity.com"] )

subscribe( nyt, scrooge )

nyt = unscribe( nyt, scrooge )

Note: Publisher is an immutable object. 'unscubscribe' creates a new Publisher
object, and is reassigned to the variable 'nyt'.
"""
unsubscribe( p::Publisher, s::Subscriber  ) =
    Publisher(p.name, p.publishertype, filter(x -> x != ([s] ∩ p.list)[1], p.list))

# MESSAGE FUNCTIONS
"""
    createMessage(header::String, subject::String, body::Array{Float64, 1})

Create a message for subscribers

# Example

```
julia> using RbO

julia> message = createMessage( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )
RbO.Message("Weather station", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])
```
"""
createMessage(header::String, subject::String, body::Array{Float64, 1}) =
    Message(header, subject, body)

"""
    sendMessage( n::Publisher, m::Message, f::Function )

Notifies subscribers

# Example

```
julia> using RbO

julia> nyt = createPublisher( "NYT" )
Publisher("NYT", NEWSPAPER::PublisherType = 0, Subscriber[])

julia> scrooge = createSubscriber( "Scrooge McDuck" , "scrooge@duckcity.com" )
Subscriber("Scrooge McDuck", "scrooge@duckcity.com", SUM_CALCULATOR::SubscriberType = 0)

julia> subscribe(nyt, scrooge)
Publisher("NYT", NEWSPAPER::PublisherType = 0, Subscriber[Subscriber("Scrooge McDuck", "scrooge@duckcity.com", SUM_CALCULATOR)])

julia> message = createMessage( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )
RbO.Message("Weather station", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])

julia> result = []
0-element Array{Any,1}

julia> function processMessage( s::Subscriber, n::Publisher, m::RbO.Message )
           if s.subscribertype == RbO.SUM_CALCULATOR
               println( s.name * " - the sum of the last five temperatures is: " * string(sum(m.body)) )
           elseif s.subscribertype == RbO.AVG_CALCULATOR
               println( s.name * " - the average temperature of the last five temperatures is: " * string(sum(m.body) / length(m.body)) )
           elseif s.subscribertype == RbO.PLOTTER
               println( s.name * " - the dataset with temperatures is: " * string(m.body))
               global result = m.body
           end
       end

#julia> processMessage
#processMessage (generic function with 1 method)

julia> sendMessage( nyt, messageNyt, processMessage )
Scrooge McDuck - the sum of the last five temperatures is: 57.0

julia> using Plots

julia> pyplot()

julia> plot(result)
```
"""
sendMessage( p::Publisher, m::Message, f::Function ) = begin
    for subscriber in p.list
        f( subscriber, p, m )
    end
end #defined sendMessage high order function


#SUBSCRIPER FUNCTIONS
"""
    createSubscriber( name::String )

Creates a subscriber

# Examples:
```
julia> using RbO

julia> createSubscriber( "Micky Mouse" )
Subscriber("Micky Mouse", "", MEAN_CALCULATOR::SubscriberType = 0)
```
"""
createSubscriber( name::String ) ::Subscriber =
    Subscriber( name )

"""
    createSubscriber( name::String, email::String )

Creates a subscriber with an e-mail address

# Example:
```
julia> using RbO

julia> createSubscriber( "Daisy Mouse", "daisy@duckcity.com" )
Subscriber("Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR::SubscriberType = 0)
```
"""
createSubscriber( name::String, email::String ) ::Subscriber =
    Subscriber( name, email )

"""
    createSubscriber( name::String, email::String, subscribertype::SubscriberType )

Creates a subscriber with an e-mail address, and scubscriber type

#See also: [`SubscriberType()`](@ref)

# Example
```
julia> using RbO

julia> scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER )
Subscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER::SubscriberType = 2)
```
"""
createSubscriber( name::String, email::String, subscribertype::SubscriberType )::Subscriber =
    Subscriber( name, email, subscribertype )
