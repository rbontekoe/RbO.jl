push!(LOAD_PATH, "/home/rob/julia_projects/RbO.jl/src/")

using  RbO

#db = connect("./rbo.sqlite")
db = connect()

# create subscribers
const daisy = createSubscriber( "Daisy" )
const mickey = createSubscriber( "Mickey" )
const scrooge = createSubscriber( "Scrooge McDuck", "scrooge@duckcity.com", PLOTTER )

# store in DatabaseItem
data = [daisy, mickey, scrooge]
create(db , "subscribers", data)

# read data back
r = gather(db, "subscribers")
println(r)

# update subscriber
daisy = updateSubscriber(daisy, "Daisy Duck", "daisy@duckcity.com", PLOTTER)
data = [daisy]
update(db, "subscribers", data)

# read data back (subscriber should be added, action UPDATE)
r = gather(db, "subscribers")
println(r)

# read selective
r = gather(db, "subscribers", "key = '" * daisy.id * "'")
println(r)

# create Publisher and add subscriber
const nyt = createPublisher( "New York Times")
subscribe(nyt, daisy)

# store in DatabaseItem
data = [nyt]
create(db, "publishers", data)

# read back
r = gather(db, "publishers")
println(r)

# update Publisher
nyt = updatePublisher(nyt, "The New York Times", NEWSPAPER)
update(db, "publishers", [nyt])

# read publisher from database
r = gather(db, "publishers")
println(r)

# add subscriber to publisher
nyt = subscribe(nyt, scrooge)
update(db, "publishers", [nyt])

# read back
r = gather(db, "publishers")
println(r)

## MANIPULTATIONS

# Reading all subscribers
r = gather(db, "subscribers")

# Convert name of subscriber to uppercase and store in database
s = map(i -> updateSubscriber(i, uppercase(i.name), i.email, i.subscribertype), r.item)
update(db, "subscribers", s)

# reading back subscrivbers
r = gather(db, "subscribers")
println(r)

# list of the latest mutations (last added subscribers)
using DataFrames
t = map( i -> last(gather( db, "subscribers", "key = '$i'" )).item, unique(r.key) ) |> DataFrame
println(t)

# MESSAGE tests
message = createMessage( "Wether", "Temperatures", [19.0, 23.0, 24.5] )
create( db, "messages", [message] )
r = gather( db, "messages" )
println( r )

message = updateMessage( message, "Weather", "", [19.0, 22.5, 24.5] )
update( db, "messages", [message] )
r = gather( db, "messages" )
println( r )
