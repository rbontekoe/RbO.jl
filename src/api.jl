# api.jl - rbontekoe@appligate.nl
include("domain.jl")

### Domain objects
export Subscriber, Publisher, Message
### SubscriberType Values
export MEAN_CALCULATOR, STD_CALCULATOR, PLOTTER
### PublisherType Values
export NEWSPAPER, MAGAZINE, SOCIAL_MEDIA

#SUBSCRIPER FUNCTIONS
"""
    createSubscriber( name::String )

Creates a subscriber

# Examples:
```jldoctest
julia> using RbO

julia> mickey = createSubscriber( "Micky Mouse" )
Subscriber("Micky Mouse", "", MEAN_CALCULATOR::SubscriberType = 0)
```
"""
createSubscriber( name::String ) ::Subscriber =
    Subscriber( name )

"""
    createSubscriber( name::String, email::String )

Creates a subscriber with an e-mail address

# Example:
```jldoctest
julia> using RbO

julia> daisy = createSubscriber( "Daisy Mouse", "daisy@duckcity.com" )
Subscriber("Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR::SubscriberType = 0)
```
"""
createSubscriber( name::String, email::String ) ::Subscriber =
    Subscriber( name, email )

"""
    createSubscriber( name::String, email::String, subscribertype::SubscriberType )

Creates a subscriber with an e-mail address, and scubscriber type

# Example
```jldoctest
julia> using RbO

julia> scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER )
Subscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER::SubscriberType = 2)
```
"""
createSubscriber( name::String, email::String, subscribertype::SubscriberType )::Subscriber =
    Subscriber( name, email, subscribertype )

## Publisher functions

"""
    createPublisher( name::String )

# Examples
```jldoctest
julia> using RbO

julia> nyt = createPublisher( "The New York Times" )
Publisher("The New York Times", NEWSPAPER::PublisherType = 0, Subscriber[])
```
"""
createPublisher( name::String )::Publisher =
        name != "" ? Publisher( name, NEWSPAPER, Array{Subscriber}(undef, 0) ) : throw(MissingException("Publisher name is mandatory"))

"""jldoctest
    createPublisher( name::String, publishertype::PublisherType )

Returns a Publisher object

```jldoctest
julia> using RbO

julia> chronicals = createPublisher( "the Duck Chronicals", MAGAZINE )
Publisher("the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[])
```
"""
createPublisher( name::String, publishertype::PublisherType )::Publisher =
        name != "" ? Publisher( name, publishertype, Array{Subscriber}(undef, 0) ) : throw(MissingException("Publisher name is mandatory"))

"""
    subscribe( p::Publisher, s::Subscriber )

Adds a subscriber to the list with subscribers

# Example
```jldoctest
julia> using RbO

julia> daisy = createSubscriber( "Daisy Mouse", "daisy@duckcity.com" )
Subscriber("Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR::SubscriberType = 0)

julia> scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER )
Subscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER::SubscriberType = 2)

julia> chronicals = createPublisher( "the Duck Chronicals", MAGAZINE )
Publisher("the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[])

julia> subscribe( chronicals, daisy )
Publisher("the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[Subscriber("Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR)])

julia> subscribe( chronicals, scrooge )
Publisher("the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[Subscriber("Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR), Subscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER)])

```
"""
subscribe( p::Publisher, s::Subscriber ) =
    Publisher( p.name, p.publishertype, push!( p.list, s ) )

"""
    unsubscribe( p::Publisher, s::Subscriber )

Removes a subscriber from the list

# Example
```
julia> using RbO

julia> mickey = createSubscriber( "Micky Mouse" )
Subscriber("Micky Mouse", "", MEAN_CALCULATOR::SubscriberType = 0))

julia> chronicals = createPublisher( "the Duck Chronicals", MAGAZINE )
Publisher("the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[])

julia> chronicals = unsubscribe( chronicals, mickey )
Publisher("the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[Subscriber("Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR), Subscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER)])
"""
unsubscribe( p::Publisher, s::Subscriber  ) =
    Publisher(p.name, p.publishertype, filter(x -> x != ([s] ∩ p.list)[1], p.list))

# MESSAGE FUNCTIONS
"""
    createMessage(header::String, subject::String, body::Array{Float64, 1})

Create a message for subscribers

# Example

```jldoctest
julia> using RbO

julia> message = createMessage( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )
Message("Weather station", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])
```
"""
createMessage( header::String, subject::String, body::Array{Float64, 1} ) =
    Message( header, subject, body )

"""
    sendMessage( n::Publisher, m::Message, f::Function )

Notifies subscribers

# Example

```jldoctest
julia> using RbO, Statistics

julia> daisy = createSubscriber( "Daisy Mouse", "daisy@duckcity.com" )
Subscriber("Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR::SubscriberType = 0)

julia> scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER )
Subscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER::SubscriberType = 2)

julia> chronicals = createPublisher( "the Duck Chronicals", MAGAZINE )
Publisher("the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[])

julia> subscribe( chronicals, daisy )
Publisher("the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[Subscriber("Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR)])

julia> subscribe( chronicals, scrooge )
Publisher("the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[Subscriber("Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR), Subscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER)])

julia> message = createMessage( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )
Message("Weather station", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])

julia> result = []
0-element Array{Any,1}

julia> processMessage( s::Subscriber, n::Publisher, m::Message ) = begin
           if s.subscribertype == STD_CALCULATOR
               println( s.name * ": the standard deviation of the last five temperatures is: " * string( round( std(m.body); digits=2) ) * " °C" )
           elseif s.subscribertype == MEAN_CALCULATOR
               println( s.name * ": the average of the last five temperatures is: " * string( mean( m.body ) ) * " °C" )
           elseif s.subscribertype == PLOTTER
               println( s.name * ": the dataset with the last five temperatures is: " * string( m.body ) )
               global result = m.body
           end
       end
processMessage (generic function with 1 method)

julia> sendMessage( chronicals, message, processMessage )
Daisy Mouse: the average of the last five temperatures is: 11.26 °C
Scrooge McDuck: the dataset with the last five temperatures is: [10.9, 12.0, 10.5, 12.7, 10.2]
```
"""
sendMessage( p::Publisher, m::Message, f::Function ) = begin
    for subscriber in p.list
        f( subscriber, p, m )
    end
end #defined sendMessage high order function
