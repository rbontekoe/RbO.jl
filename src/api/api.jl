# api.jl - rbontekoe@appligate.nl
include("../domain.jl")
#include("./db.jl")

### Domain objects
export Subscriber, Publisher, Message, SubscriberType, PublisherType
### SubscriberType Values
export MEAN_CALCULATOR, STD_CALCULATOR, PLOTTER
### PublisherType Values
export NEWSPAPER, MAGAZINE, SOCIAL_MEDIA

#SUBSCRIPER FUNCTIONS
"""
    createSubscriber( name::String )::Subscriber

Creates a Subscriber.

# Example

```julia
julia> using RbO

julia> mickey = createSubscriber( "Micky Mouse" )
Subscriber("5266070367247245961", "Micky Mouse", "", MEAN_CALCULATOR::SubscriberType = 0
```
"""
createSubscriber( name::String ) ::Subscriber =
    name != "" ? Subscriber( name ) : throw(MissingException("Publisher name is mandatory"))

"""
    createSubscriber( name::String, email::String )::Subscriber

Creates a Subscriber with an e-mail address.

# Example

```julia
julia> using RbO

julia> createSubscriber( "Daisy Mouse", "daisy@duckcity.com" )
Subscriber("12318486163220258938", "Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR::SubscriberType = 0)
```
"""
createSubscriber( name::String, email::String ) ::Subscriber =
    name != "" ? Subscriber( name, email ) : throw(MissingException("Publisher name is mandatory"))

"""
    createSubscriber( name::String, email::String, subscribertype::SubscriberType )::Subscriber

Creates a Subscriber with a name, an e-mail address, and [SubscriberType] (@ref).

# Example

```julia
julia> using RbO

julia> scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER )
Subscriber("7556935909242662862", "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER::SubscriberType = 2)
```
"""
createSubscriber( name::String, email::String, subscribertype::SubscriberType )::Subscriber =
    name != "" ? Subscriber( name, email, subscribertype ) : throw(MissingException("Publisher name is mandatory"))

## Publisher functions

"""
    createPublisher( name::String )::Publisher

Creates a Publisher.

# Examples

```julia
julia> using RbO

julia> nyt = createPublisher("")::Publisher
ERROR: MissingException: Publisher name is mandatory

julia> nyt = createPublisher( "The New York Times" )
Publisher("8651587598072409040", "The New York Times", NEWSPAPER::PublisherType = 0, Subscriber[])
```
"""
createPublisher( name::String )::Publisher =
        name != "" ? Publisher( name, NEWSPAPER, Array{Subscriber}(undef, 0) ) : throw(MissingException("Publisher name is mandatory"))

"""
    createPublisher( name::String, publishertype::PublisherType )::Publisher

Returns a Publisher object.

# Example

```julia_projects
julia> using RbO

julia> chronicals = createPublisher( "the Duck Chronicals", MAGAZINE )
Publisher("1425143201220694185", "the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[])
```
"""
createPublisher( name::String, publishertype::PublisherType )::Publisher =
        name != "" ? Publisher( name, publishertype, Array{Subscriber}(undef, 0) ) : throw(MissingException("Publisher name is mandatory"))

"""
    subscribe( p::Publisher, s::Subscriber )::Publisher

Adds a subscriber to the list with subscribers of a Publisher.

# Example

```julia
julia> using RbO

julia> daisy = createSubscriber( "Daisy Mouse", "daisy@duckcity.com" )
Subscriber("12635951225266630417", "Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR::SubscriberType = 0)

julia> scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER )
Subscriber("10413109711473660059", "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER::SubscriberType = 2)

julia> chronicals = createPublisher( "the Duck Chronicals", MAGAZINE )
Publisher("3837529886997444322", "the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[])

julia> subscribe( chronicals, daisy )
Publisher("1914673065319653327", "the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[Subscriber("12635951225266630417", "Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR)])

julia> subscribe( chronicals, scrooge )
Publisher("13462719397894381475", "the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[Subscriber("12635951225266630417", "Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR), Subscriber("10413109711473660059", "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER)])

```
"""
subscribe( p::Publisher, s::Subscriber ) =
    Publisher( p.name, p.publishertype, push!( p.list, s ) )

"""
    unsubscribe( p::Publisher, s::Subscriber )::Publisher

Removes a subscriber from the list of subscribers of a Publisher,

# Example

```Julia
julia> using RbO

julia> mickey = createSubscriber( "Micky Mouse" )
Subscriber("3423088500793114972", "Micky Mouse", "", MEAN_CALCULATOR::SubscriberType = 0)

julia> chronicals = createPublisher( "the Duck Chronicals", MAGAZINE )
Publisher("17516499932697635194", "the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[])

julia> subscribe( chronicals, mickey )
Publisher("5230641724437552158", "the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[Subscriber("3423088500793114972", "Micky Mouse", "", MEAN_CALCULATOR)])

julia> chronicals = unsubscribe( chronicals, mickey )
Publisher("8395917352308977462", "the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[])
```
"""
unsubscribe( p::Publisher, s::Subscriber  )::Publisher =
    Publisher(p.name, p.publishertype, filter(x -> x != ([s] ∩ p.list)[1], p.list))

# MESSAGE FUNCTIONS
"""
    createMessage(header::String, subject::String, body::Array{Float64, 1})::Message

Create a Message for the subscribers of a publisher.

# Example

```julia
julia> using RbO

julia> message = createMessage( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )
Message("6552947469222051903", "Weather station", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])
```
"""
createMessage( header::String, subject::String, body::Array{Float64, 1} )::Message =
    Message( header, subject, body )

"""
    sendMessage( n::Publisher, m::Message, f::Function )

Notifies subscribers of a Publisher.

# Example

```juia
julia> using RbO, Statistics

julia> daisy = createSubscriber( "Daisy Mouse", "daisy@duckcity.com" )
Subscriber("6169770273605469864", "Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR::SubscriberType = 0)

julia> scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER )
Subscriber("10186428844176937704", "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER::SubscriberType = 2)

julia> chronicals = createPublisher( "the Duck Chronicals", MAGAZINE )
Publisher("7230819820238935481", "the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[])

ulia> subscribe( chronicals, daisy )
Publisher("6510219041301655288", "the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[Subscriber("6169770273605469864", "Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR)])

julia> subscribe( chronicals, scrooge )
Publisher("7476862917858954939", "the Duck Chronicals", MAGAZINE::PublisherType = 1, Subscriber[Subscriber("6169770273605469864", "Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR), Subscriber("10186428844176937704", "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER)])

julia> message = createMessage( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )
Message("12608934706983977616", "Weather station", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])

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

# Update methods
"""
    updateSubscriber( subscriber::Subscriber, name::String, email::String, subscribertype::SubscriberType )::Subscriber

Update a Subscriber. Empty strings ("") don't modify the data. subscribertype should always be specified.

# Example

```julia
julia> using RbO

julia> daisy = createSubscriber( "Daisy" )
Subscriber("16587901847852633888", "Daisy", "", MEAN_CALCULATOR::SubscriberType = 0)

julia> daisy = updateSubscriber(daisy, "Daisy Mouse", "daisy@duckcity.com", daisy.subscribertype )
Subscriber("16587901847852633888", "Daisy Mouse", "daisy@duckcity.com", MEAN_CALCULATOR::SubscriberType = 0)
```
"""
updateSubscriber( subscriber::Subscriber, name::String, email::String, subscribertype::SubscriberType )::Subscriber =
    begin
        id = subscriber.id
        name = name == "" ? subscriber.name : name
        emai = email == "" ? subscriber.email : email
        subscribertype = subscribertype
        Subscriber( id, name, email, subscribertype)
    end

createKey(name::String) = string( hash( name * string( time() ) ) )


"""
    updatePublisher( publisher::Publisher, name::String, publishertype::PublisherType )::Publisher

Update a Publisher. Empty strings ("") don't modify the data. '''publishertype''' should always be specified.

# Example

```julia
julia> using RbO

julia> nyt = createPublisher( "New York times" )
Publisher("9842848910504957757", "New York times", NEWSPAPER::PublisherType = 0, Subscriber[])

julia> nyt = updatePublisher( nyt, "The New York Times", nyt.publishertype )
Publisher("9842848910504957757", "The New York Times", NEWSPAPER::PublisherType = 0, Subscriber[])
```
"""
updatePublisher( publisher::Publisher, name::String, publishertype::PublisherType )::Publisher =
    begin
        id = publisher.id
        name = name == "" ? publisher.name : name
        publishertype = publishertype
        list = publisher.list
        Publisher( id, name, publishertype, list)
    end

"""
    updateMessage( message::Message, header::String, subject::String, body::Array{Float64, 1})::Message

    Update a Message. Empty strings ("") don't modify the data. '''body''' should always be specified.

#Example

```julia
julia> using RbO

julia> message = createMessage( "Wether station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )
Message("1941280172945521746", "Wether station", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])

julia> message = updateMessage( message, "Weather Station XYZ", "", message.body )
Message("1941280172945521746", "Weather Station XYZ", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])
```
"""
updateMessage( message::Message, header::String, subject::String, body::Array{Float64, 1})::Message =
    begin
        id = message.id
        header = header == "" ? message.header : header
        subject = subject == "" ? message.subject : subject
        #body = message.body
        Message( id, header, subject, body )
    end
