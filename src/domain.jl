# domain.jl - rbontekoe@appligate.nl

## API Functions
function createSubscriber end
function createPublisher end
function subscribe end
function unsubscribe end
function createMessage end
function sendMessage end

## Infrastructure functions
function createDbConnection end
function create end
function read end
function update end
function delete end

## Abstract types
abstract type Information end

## Domain items
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
end # defined enumerator for Publisher types

"""
    SubscriberType

# Values
- STD_CALCULATOR (caluclates the standard deviation of set of data, default value)
- MEAN_CALCULATOR (caluclates the mean of set of data)
- PLOTTER (keeps the dataset for plotting)
"""
@enum SubscriberType begin
    MEAN_CALCULATOR
    STD_CALCULATOR
    PLOTTER
end # defined enumerator for Subscriber types

"""
    struct Subscriber

Returns a Subscriber. It is preferred to use createSubscriber.

# Example
```jldoctest
julia> using RbO

julia> daisy = Subscriber("Daisy")
Subscriber("Daisy", "", MEAN_CALCULATOR::SubscriberType = 0)
```
"""
struct Subscriber
    name::String
    email::String
    subscribertype::SubscriberType
    #constructors
    Subscriber( name::String ) = new( name, "", MEAN_CALCULATOR )
    Subscriber( name::String, email::String ) = new( name, email, MEAN_CALCULATOR )
    Subscriber( name::String, email::String, subscribertype::SubscriberType ) = new( name, email, subscribertype )
end # defined Scubscriber object

"""
    struct Publisher

Returns a Publisher object.  It is preferred to use createPublisher.

# Example
```jldoctest
julia> using RbO

julia> chronicals = Publisher("The Duck City Chornicals", NEWSPAPER, Subscriber[])
Publisher("The Duck City Chornicals", NEWSPAPER::PublisherType = 0, Subscriber[])
```

"""
struct Publisher
    name::String
    publishertype::PublisherType
    list::Array{Subscriber, 1}
    #constructors
    Publisher( name::String ) = new( name, NEWSPAPER, [] )
    Publisher( name::String, publishertype::PublisherType) = new( name, publishertype, [] )
    Publisher( name::String, publishertype::PublisherType, list::Array{Subscriber, 1}) = new( name, publishertype, list )
end # defined Publisher object

"""
    struct Message

Returms a Message object.  It is preferred to use createMessage.

# Example
```jldoctest
julia> using RbO

julia> message = Message( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )
Message("Weather station", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])

```
"""
struct Message <: Information
    header::String
    subject::String
    body::Array{Float64, 1}
end # defined Message object
