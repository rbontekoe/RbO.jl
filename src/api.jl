# api.jl - rbontekoe@appligate.nl
include("domain.jl")

#= Summary of API methods definitions
function createSubscriber(name::String)::Subscriber end
function createSubscriber(name::String, email::String)::Subscriber end
function createSubscriber( name::String, email::String, subscribertype::SubscriberType ) end

function createPublisher(name::String, publishertype::PublisherType)::Publisher end
function subscribe(publisher::Publisher, subscriber::Subscriber) end
function unsubscribe(publisher::Publisher, subscriber::Subscriber, )::Publisher end
function createMessage(header::String, subject::String, body::Array{Float64, 1})::Message end
function sendMessage(publisher::Publisher, message::Information, f::Function) end
=#

#PUBLISHER FUNCTIONS
"""
    createPublisher( name::String, publishertype::PublisherType )

Returns a Publisher object
- name: name of the Publisher (mandatory)
- publishertype, see: [`PublisherType()`](@ref)

Exception: MissingException

# Examples
```
julia> chronicals = createPublisher( "the Duck Chronicals" )
Publisher("the Duck Chronicals", NEWSPAPER::PublisherType = 0, Subscriber[])
```
"""
function createPublisher( name::String, publishertype::PublisherType = NEWSPAPER )::Publisher
        name != "" ? Publisher( name, publishertype, Array{Subscriber}(undef, 0) ) : throw(MissingException("Publisher name is mandatory"))
end #defined createPublisher function

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
function subscribe( p::Publisher, s::Subscriber )
    np = Publisher( p.name, p.publishertype, push!( p.list, s ) )
end #defined subscribe function

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
function unsubscribe( p::Publisher, s::Subscriber  )
    Publisher(p.name, p.publishertype, filter(x -> x != ([s] ∩ p.list)[1], p.list))
end #defined unsubscribe function


# MESSAGE FUNCTIONS
"""
    function createMessage(header::String, subject::String, body::Array{Float64, 1})

Create a message for subscribers

# Example

```
julia> using RbO

julia> message = createMessage( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )
RbO.Message("Weather station", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])
```
"""
function createMessage(header::String, subject::String, body::Array{Float64, 1})
    Message(header, subject, body)
end

"""
    function sendMessage( n::Publisher, m::Message, f::Function )

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
plot(result)```
"""
function sendMessage( p::Publisher, m::Message, f::Function )
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
Subscriber("Micky Mouse", "", SUM_CALCULATOR::SubscriberType = 0)
```
"""
function createSubscriber( name::String ) ::Subscriber
    Subscriber( name )
end #defined createSubscriber function method 1

"""
    createSubscriber( name::String, email::String )

Creates a subscriber with an e-mail address

# Example:
```
julia> using RbO

julia> createSubscriber( "Mickey Mouse" )
Subscriber("Mickey Mouse", "", SUM_CALCULATOR::SubscriberType = 0)
```
"""
function createSubscriber( name::String, email::String ) ::Subscriber
    Subscriber( name, email )
end #defined createSubscriber function method 2

"""
    createSubscriber( name::String, email::String, subscribertype::SubscriberType )

Creates a subscriber with an e-mail address, and scubscriber type

See also: [`SubscriberType()`](@ref)

# Example
```
julia> using RbO

julia> scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", RbO.PLOTTER )
Subscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER::SubscriberType = 2)
```
"""
function createSubscriber( name::String, email::String, subscribertype::SubscriberType ) ::Subscriber
    Subscriber( name, email, subscribertype )
end #defined createSubscriber
