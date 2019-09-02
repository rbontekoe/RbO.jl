# RbO.jl

# Home

## Introduction
Recently I focussed on the Julia programming language again. To get more experience, I created the project 'rbontekoe/RbO.jl.'

Also, I decided to use Documenter.jl to create the documentation for the project, after looking at a [video] (https://www.youtube.com/watch?v=m3c8Z6HBn48) that explains its features. I was impressed when Morton Phiibleht told about the possibility to test the code example automatically during the creation of the manual. The result is this manual.

For the creation of the Julia notebook, I used Literate.jl, after watching this [video](https://www.youtube.com/watch?v=Tfp1WEdYfqk&t=333s).

# Installing the module
The module can be added or cloned from GitHub: https://github.com/rbontekoe/RbO.jl.

## Example of adding the module
```
julia> ]

(v1.1) pkg> add https://github.com/rbontekoe/RbO.jl

(v1.1) pkg> Ctrl-C

julia> using RbO
```

## Example of cloning the module
```
$ mkdir julia_projects

$ cd julia_projects

$ git clone https://github.com/rbontekoe/RbO.jl.git

$ cd RbO.jl

$ julia

julia> push!(LOAD_PATH, "/home/rob/julia_projects/RbO.jl/src/")

julia> using RbO
```

# Public interface
I have taken the Observer Pattern as the goal to implement the project. The main objects are Publisher and Subscriber. The Publisher delivers a message to the Subscribers. The information consists of temperatures that were measured.

## Exports
**API methods**
- createSubscriber, createPublisher, createMessage, sendMessage
**Domain objects**
- Subscriber, Publisher, Message
**SubscriberType values**
- MEAN\_CALCULATOR, STD\_CALCULATOR, PLOTTER
**PublisherType values**
- NEWSPAPER, MAGAZINE, SOCIAL_MEDIA

## createSubscriber
```@docs
createSubscriber
```

## createPublisher
```@docs
createPublisher
```

## subscribe
```@docs
subscribe
```

## unsubscribe
```@docs
unsubscribe
```
!!! note
    Publisher is an immutable object. 'unscubscribe' creates a new Publisher object, and is reassigned to the variable 'chronicals'.


## createMessage
```@docs
createMessage
```

## sendMessage
```@docs
sendMessage
```

# Domain Items

## Subscriber
```@docs
Subscriber
```
## SubscriberType
```@docs
SubscriberType
```
## Publisher
```@docs
Publisher
```
## PublisherType
```@docs
PublisherType
```
## Message
```@docs
Message
```

# Examples

## test.jl

Code to test RbO

```julia
using RbO, Plots, Statistics
pyplot()

# ### Create subscribers
daisy = createSubscriber( "Daisy Duck", "daisy@duckcity.com" )
donald = createSubscriber( "Donald Duck", "donald@duckcity.com", STD_CALCULATOR )
scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER )
mickey = createSubscriber( "Micky Mouse" )

# ### Create newspapers and magazines
chronicals = createPublisher( "the Duck Chronicals" )

# Add subscribers to the Duck Chronicals
subscribe( chronicals, daisy )
subscribe( chronicals, donald )
subscribe( chronicals, scrooge )
subscribe( chronicals, mickey )

# Unsubscribe Mickey Mouse
chronicals = unsubscribe(chronicals, mickey)

# ### Define message for the Duck Chronical subscribers
message = createMessage( "Weather station", "Temperatures", [10.9, 12, 10.5, 12.7, 10.2] )

# ### Print the messages
paper = chronicals

# List with the subscribers of a newspaper or magazine
sm = map( x -> x.email == "" ? x.name : x.name * " - " * x.email, paper.list )

# Print the subscribers
len =  length( "Subscribers of " * paper.name * string(paper.publishertype )) + 5

println( "\n" * "="^len )
title = titlecase( string( paper.publishertype ) )
println( " Subscribers of " * paper.name * " - " * map(x -> x == '_' ? ' ' : x , title ) )
println( "="^len )
for subscriber in sm
    println( " " * subscriber )
end
println( '='^len )

# ### Define the function 'processMessage' to process data depending on SubsriberType
#result = []
processMessage( s::Subscriber, n::Publisher, m::Message ) = begin
    if s.subscribertype == STD_CALCULATOR
        println( s.name * ":\t the standard deviation of the last five temperatures is: " * string( round( std(m.body); digits=2) ) * " °C" )
    elseif s.subscribertype == MEAN_CALCULATOR
        #println( s.name * ":\t the average of the last five temperatures is: " * string(sum(m.body) / length(m.body)) * " °C" )
        println( s.name * ":\t the average of the last five temperatures is: " * string( mean( m.body ) ) * " °C" )
    elseif s.subscribertype == PLOTTER
        println( s.name * ":\t the dataset with the last five temperatures is: " * string( m.body ) )
        global result = m.body
    end
end

# ### Notify scubscribers
sendMessage( chronicals, message, processMessage )

# ### Plot data
plot( result )

```

## make.jl
```
using Documenter
using RbO, Statistics
using Test

doctest(RbO)

makedocs(
    sitename = "RbO",
    format = Documenter.HTML(),
    modules = [RbO],
    pages = [
        "User Manual" => "index.md",
        "Building applications with Julia" => "course.md"
    ]
)
```

## doc.jl

Code to create the Julia Notebook

```
# Uncomment the next line when RbO has been cloned.
#push!(LOAD_PATH, "/home/rob/julia_projects/RbO.jl/src/")
include("./test.jl")
using Literate
Literate.notebook("./test.jl", "."; documenter=false)
```

## Julia Notebook
You can find an example of the code in a Julia Notebook on GitHub.
See: <https://github.com/rbontekoe/RbO.jl/blob/master/test.ipynb>
