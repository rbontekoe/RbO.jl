# Examples

## test.jl

Code to test RbO.jl

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

Script to create the User Manual

```
using Documenter
using RbO, Statistics
using Test

doctest(RbO)

makedocs(
    sitename = "RbO.jl",
    format = Documenter.HTML(),
    modules = [RbO],
    pages = [
        "User Manual" => "index.md",
        "Installing the module" => "module_a.md",
        "API" => "module_b.md",
        "Domain Items" => "module_c.md",
        "Examples" => "module_d.md"
    ]
)
```

## doc.jl

Script to create the Julia Notebook

```Julia
# Uncomment the next line when RbO has been cloned.
#push!(LOAD_PATH, "/home/rob/julia_projects/RbO.jl/src/")
include("./test.jl")
using Literate
Literate.notebook("./test.jl", "."; documenter=false)
```

## Julia Notebook
You can find an example of the code in a Julia Notebook on GitHub.
See: <https://github.com/rbontekoe/RbO.jl/blob/master/test.ipynb>

## References
- [Parallel & Distributed Computing] (https://github.com/crstnbr/JuliaWorkshop19/blob/master/3_Three/1_parallel_computing.ipynb)
