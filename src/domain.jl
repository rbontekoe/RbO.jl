# domain.jl - rbontekoe@appligate.nl

abstract type Information end

"""
PublisherType

Values:
- NEWSPAPER
- MAGAZINE
- SOCIAL_MEDIA

"""
@enum PublisherType begin
    NEWSPAPER
    MAGAZINE
    SOCIAL_MEDIA
end #defined enumeration for Publisher types

@enum SubscriberType begin
    SUM_CALCULATOR
    AVG_CALCULATOR
    PLOTTER
end #defined enumeration for Subscriber types


#TODO #defined Infrastructure functions


struct Subscriber
    name::String
    email::String
    subscribertype::SubscriberType
    #constructors
    Subscriber(name::String) = new(name, "", SUM_CALCULATOR)
    Subscriber(name::String, email::String) = new(name, email, SUM_CALCULATOR)
    Subscriber(name::String, email::String, subscribertype::SubscriberType ) = new(name, email, subscribertype)
end #define Scubscriber object

struct Publisher
    name::String
    publishertype::PublisherType
    list::Array{Subscriber, 1}
end #defined Publisher object

struct Message <: Information
    header::String
    subject::String
    body::Array{Float64, 1}
end #defined Message object
