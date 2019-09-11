# domain.jl - rbontekoe@appligate.nl

## API Functions
function createSubscriber end
function createPublisher end
function subscribe end
function unsubscribe end
function createMessage end
function sendMessage end

function updateSubscriber end
function updatePublisher end
function updateMessage end

## Database CRUD functions
function connect end
function create end
function gather end # read is already used
function update end
function delete end

## Abstract types
abstract type DomainObject end
abstract type Information <: DomainObject end

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
    struct Subscriber <: DomainObject

Returns a Subscriber. It is preferred to use createSubscriber.

# Example

```julia
julia> using RbO

julia> daisy = Subscriber("Daisy")
Subscriber("13648859580074120351", "Daisy", "", MEAN_CALCULATOR::SubscriberType = 0)
```
"""
struct Subscriber <: DomainObject
    id::String
    name::String
    email::String
    subscribertype::SubscriberType
    #constructors
    Subscriber( name::String ) = new( createKey(name), name, "", MEAN_CALCULATOR )
    Subscriber( name::String, email::String ) = new( createKey(name), name, email, MEAN_CALCULATOR )
    Subscriber( name::String, email::String, subscribertype::SubscriberType ) = new( createKey(name), name, email, subscribertype )
    Subscriber( id::String, name::String, email::String, subscribertype::SubscriberType ) = new( id , name, email, subscribertype )
end # defined Scubscriber object

"""
    struct Publisher <: DomainObject

Returns a Publisher object.  It is preferred to use createPublisher.

# Example
```julia
julia> using RbO

julia> chronicals = Publisher("The Duck City Chornicals", NEWSPAPER, Subscriber[])
Publisher("3207093602141662250", "The Duck City Chornicals", NEWSPAPER::PublisherType = 0, Subscriber[])
```

"""
struct Publisher <: DomainObject
    id::String
    name::String
    publishertype::PublisherType
    list::Array{Subscriber, 1}
    #constructors
    Publisher( name::String ) = new( createKey(name), name, NEWSPAPER, [] )
    Publisher( name::String, publishertype::PublisherType) = new( createKey(name), name, publishertype, [] )
    Publisher( name::String, publishertype::PublisherType, list::Array{Subscriber, 1}) = new( createKey(name), name, publishertype, list )

    Publisher( id::String, name::String, publishertype::PublisherType, list::Array{Subscriber, 1} ) = new( id , name, publishertype, list )
end # defined Publisher object

"""
    struct Message <: Information

Returns a Message object.  It is preferred to use createMessage.

# Example
```julia
julia> using RbO

julia> message = Message( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )
Message("6473886582379654438", "Weather station", "Temperatures", [10.9, 12.0, 10.5, 12.7, 10.2])
```
"""
struct Message <: Information
    id::String
    header::String
    subject::String
    body::Array{Float64, 1}
    # constructors
    Message( header::String, subject::String, body::Array{Float64, 1} ) = new( createKey(header), header, subject, body )

    Message( id, header, subject, body ) = new( id, header, subject, body )
end # defined Message object
