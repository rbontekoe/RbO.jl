# db.jl
#using SQLite, DataFrames

# Database item
struct DatabaseItem{T <: DomainObject}
   time::Float64
   agent::String
   action::String
   key::String
   item::T
end # end DatabaseItem

# Connect
"""
    connect(path::String)::SQLite.DB

Returns a database.

# Example
```jldoctest
julia> using RbO

julia> db = connect("./rbo.sqlite")
SQLite.DB("./rbo.sqlite")
```
"""
connect(path::String)::SQLite.DB = SQLite.DB(path)

"""
    connect()::SQLite.DB

Returns an in-memory database.

# Example
```jldoctest
julia> using RbO

julia> db = connect()
SQLite.DB(in-memory)
```
"""
connect() = SQLite.DB()::SQLite.DB

# Create
"""
    create( db::SQLite.DB, table::String, domainItems::Array{Subscriber, 1} )

Store subscribes in a database table.

# Example
```jldoctest
julia> using RbO

julia> daisy = createSubscriber( "Daisy" );

julia> mickey = createSubscriber( "Mickey" );

julia> data = [ daisy, mickey ];

julia> db = connect()
SQLite.DB(in-memory)

julia> create( db, "subscribers", data )
"subscribers"
```
"""
create( db::SQLite.DB, table::String, domainItems::Array{Subscriber, 1} ) = begin
   #dbi = [ createDatabaseItem(i, "AB9F", "CREATE") for i in domainItems]
   dbi = [ createDatabaseItem( i ; action="CREATE" ) for i in domainItems]
   DataFrame( dbi ) |> SQLite.load!(db, table)
end # end create

"""
    create( db::SQLite.DB, table::String, domainItems::Array{Publisher, 1} )

Store publishers in a database table.

# Exampple
```jldoctest
julia> using RbO

julia> nyt = createPublisher( "The New York Times" );

julia> db = connect()
SQLite.DB(in-memory)

julia> create(db, "publishers", [ nyt ])
"publishers"
```
"""
create( db::SQLite.DB, table::String, domainItems::Array{Publisher, 1} ) = begin
   #dbi = [ createDatabaseItem(i, "AB9F", "CREATE") for i in domainItems]
   dbi = [ createDatabaseItem( i; action="CREATE" ) for i in domainItems]
   DataFrame( dbi ) |> SQLite.load!(db, table)
end # end create

"""
    create( db::SQLite.DB, table::String, domainItems::Array{Message, 1} )

Store publishers in a database table.
"""
create( db::SQLite.DB, table::String, domainItems::Array{Message, 1} ) = begin
   #dbi = [ createDatabaseItem(i, "AB9F", "CREATE") for i in domainItems]
   dbi = [ createDatabaseItem( i; action="CREATE" ) for i in domainItems]
   DataFrame( dbi ) |> SQLite.load!(db, table)
end # end create

# gather (read)
"""
    gather( db::SQLite.DB, table::String )::DataFrame

Returns a dataframe with all entries

```julia
julia> using RbO

julia> daisy = createSubscriber( "Daisy" )
Subscriber("14400338531749444750", "Daisy", "", MEAN_CALCULATOR::SubscriberType = 0)

julia> mickey = createSubscriber( "Mickey" )
Subscriber("7987502302757180929", "Mickey", "", MEAN_CALCULATOR::SubscriberType = 0)

julia> db = connect()
SQLite.DB(in-memory)

julia> create( db, "subscribers", [ daisy, mickey ] )
"subscribers"

julia> gather(db, "subscribers")
┌ Warning: `T` is deprecated, use `nonmissingtype` instead.
│   caller = compacttype(::Type, ::Int64) at show.jl:39
└ @ DataFrames ~/.julia/packages/DataFrames/XuYBH/src/abstractdataframe/show.jl:39
2×5 DataFrames.DataFrame
│ Row │ time      │ agent   │ action  │ key                  │ item                                                             │
│     │ Float64⍰  │ String⍰ │ String⍰ │ String⍰              │ Union{Missing, Subscriber}                                       │
├─────┼───────────┼─────────┼─────────┼──────────────────────┼──────────────────────────────────────────────────────────────────┤
│ 1   │ 1.56812e9 │ AB9F    │ CREATE  │ 14400338531749444750 │ Subscriber("14400338531749444750", "Daisy", "", MEAN_CALCULATOR) │
│ 2   │ 1.56812e9 │ AB9F    │ CREATE  │ 7987502302757180929  │ Subscriber("7987502302757180929", "Mickey", "", MEAN_CALCULATOR) │
```
"""
gather( db::SQLite.DB, table::String)::DataFrame = SQLite.Query( db, "select * from $table" ) |> DataFrame

"""
    gather( db::SQLite.DB, table::String, condition::String )::DataFrame

Return a DataFrame with all entries.

# Example
```julia
julia> using RbO

julia> daisy = createSubscriber( "Daisy" )
Subscriber("5270518311956369638", "Daisy", "", MEAN_CALCULATOR::SubscriberType = 0)

julia> mickey = createSubscriber( "Mickey" )
Subscriber("8580492032810188742", "Mickey", "", MEAN_CALCULATOR::SubscriberType = 0)

julia> db = connect()
SQLite.DB(in-memory)

julia> create( db, "subscribers", [ daisy, mickey ] )
 "subscribers"

julia> gather( db, "subscribers", "key = '" * daisy.id * "'" )
1×5 DataFrames.DataFrame
│ Row │ time      │ agent   │ action  │ key                 │ item                                                            │
│     │ Float64⍰  │ String⍰ │ String⍰ │ String⍰             │ Union{Missing, Subscriber}                                      │
├─────┼───────────┼─────────┼─────────┼─────────────────────┼─────────────────────────────────────────────────────────────────┤
│ 1   │ 1.56812e9 │ AB9F    │ CREATE  │ 5270518311956369638 │ Subscriber("5270518311956369638", "Daisy", "", MEAN_CALCULATOR) │
```
"""
gather( db::SQLite.DB, table::String, condition::String )::DataFrame = SQLite.Query( db, "select * from $table where $condition" )  |> DataFrame

# dataItem - internal function
const agent = "AB9F"
createDatabaseItem( item::Any; agent="AB9F", action="CREATE" ) = DatabaseItem( time(), agent, action, item.id, item )

# update
"""
    update( db::SQLite.DB, table::String, domainItems::Array{Subscribers, 1} )


# Example
```Julia
julia> using RbO

julia> daisy = createSubscriber( "Daisy" )
Subscriber("5270518311956369638", "Daisy", "", MEAN_CALCULATOR::SubscriberType = 0)

julia> mickey = createSubscriber( "Mickey" )
Subscriber("8580492032810188742", "Mickey", "", MEAN_CALCULATOR::SubscriberType = 0)

julia> db = connect()
SQLite.DB(in-memory)

julia> create( db, "subscribers", [ daisy, mickey ] )
 "subscribers"

julia> gather( db, "subscribers", "key = '" * daisy.id * "'" )
1×5 DataFrames.DataFrame
│ Row │ time      │ agent   │ action  │ key                 │ item                                                            │
│     │ Float64⍰  │ String⍰ │ String⍰ │ String⍰             │ Union{Missing, Subscriber}                                      │
├─────┼───────────┼─────────┼─────────┼─────────────────────┼─────────────────────────────────────────────────────────────────┤
│ 1   │ 1.56812e9 │ AB9F    │ CREATE  │ 5270518311956369638 │ Subscriber("5270518311956369638", "Daisy", "", MEAN_CALCULATOR) │

daisy = updateSubscriber( daisy, "Daisy Duck", "daisy@duckcity.com", daisy.subscribertype )
Subscriber("5270518311956369638", "Daisy Duck", "daisy@duckcity.com", MEAN_CALCULATOR::SubscriberType = 0)

julia> update( db, "subscribers", [daisy] )
"subscribers"

julia> gather( db, "subscribers", "key = '" * daisy.id * "'" )
2×5 DataFrames.DataFrame
│ Row │ time      │ agent   │ action  │ key                 │ item                                                                                   │
│     │ Float64⍰  │ String⍰ │ String⍰ │ String⍰             │ Union{Missing, Subscriber}                                                             │
├─────┼───────────┼─────────┼─────────┼─────────────────────┼────────────────────────────────────────────────────────────────────────────────────────┤
│ 1   │ 1.56812e9 │ AB9F    │ CREATE  │ 5270518311956369638 │ Subscriber("5270518311956369638", "Daisy", "", MEAN_CALCULATOR)                        │
│ 2   │ 1.56812e9 │ AB9F    │ UPDATE  │ 5270518311956369638 │ Subscriber("5270518311956369638", "Daisy Duck", "daisy@duckcity.com", MEAN_CALCULATOR) │
```
"""
update( db::SQLite.DB, table::String, domainItems::Array{Subscriber, 1} ) = begin
   dbi = [ createDatabaseItem(i, action="UPDATE") for i in domainItems]
   DataFrame( dbi ) |> SQLite.load!(db, table)
end # end update

"""
    update( db::SQLite.DB, table::String, domainItems::Array{Publishers, 1} )

Update publishers in a database table.
"""
update( db::SQLite.DB, table::String, domainItems::Array{Publisher, 1} ) = begin
   dbi = [ createDatabaseItem(i, action="UPDATE") for i in domainItems]
   DataFrame( dbi ) |> SQLite.load!(db, table)
end # end update

"""
    update( db::SQLite.DB, table::String, domainItems::Array{Message, 1} )

Update messages in a database table.
"""
update( db::SQLite.DB, table::String, domainItems::Array{Message, 1} ) = begin
   dbi = [ createDatabaseItem(i, action="UPDATE") for i in domainItems]
   DataFrame( dbi ) |> SQLite.load!(db, table)
end # end update
