# push!(LOAD_PATH, "/home/rob/julia_projects/RbO.jl/src/")
using Test, SQLite, DataFrames
include("../src/api/api.jl")

# TEST MODEL
@testset "PublisherType test" begin
    @test PublisherType(0) == NEWSPAPER
    @test PublisherType(1) == MAGAZINE
    @test PublisherType(2) == SOCIAL_MEDIA
end

@testset "SubscriberType test" begin
    @test SubscriberType(0) == MEAN_CALCULATOR
    @test SubscriberType(1) == STD_CALCULATOR
    @test SubscriberType(2) == PLOTTER
end

@testset "Subscriber name test" begin
    scrooge = createSubscriber("Scrooge McDuck")
    @test scrooge.name == "Scrooge McDuck"
    @test scrooge.email == ""
    @test scrooge.subscribertype == MEAN_CALCULATOR
end

@testset "Subscriber empty name test" begin
    @test_throws MissingException("Publisher name is mandatory") createSubscriber("")
end

@testset "Subscriber name, and email test" begin
    scrooge = createSubscriber("Scrooge McDuck", "scrooge@duckcity.com")
    @test scrooge.name == "Scrooge McDuck"
    @test scrooge.email == "scrooge@duckcity.com"
    @test scrooge.subscribertype == MEAN_CALCULATOR
end

@testset "Subscriber name, email, and type test" begin
    scrooge = createSubscriber("Scrooge McDuck", "scrooge@duckcity.com", PLOTTER)
    @test scrooge.name == "Scrooge McDuck"
    @test scrooge.email == "scrooge@duckcity.com"
    @test scrooge.subscribertype == PLOTTER
end

@testset "Update subscribers test" begin
    daisy = createSubscriber( "Daisy" )
    id = daisy.id
    daisy = updateSubscriber( daisy, "Daisy Duck", "daisy@duckcity.com", PLOTTER )
    @test id == daisy.id
    @test daisy.name == "Daisy Duck"
    @test daisy.email == "daisy@duckcity.com"
    @test daisy.subscribertype == PLOTTER
end

@testset "Publisher name test" begin
    nyt = createPublisher("NYT")
    @test nyt.name == "NYT"
    @test nyt.publishertype == NEWSPAPER
    @test nyt.list == []
end

@testset "Update publisher test" begin
    nyt = createPublisher("NYT")
    id = nyt.id
    nyt = updatePublisher( nyt, "The New York Times", MAGAZINE )
    @test id == nyt.id
    @test nyt.name == "The New York Times"
    @test nyt.publishertype == MAGAZINE
end

@testset "Publisher empty name test" begin
    @test_throws MissingException("Publisher name is mandatory") createPublisher("")
end

@testset "Publisher name, publishertype, and list test" begin
    nyt = createPublisher("NYT", MAGAZINE)
    @test nyt.name == "NYT"
    @test nyt.publishertype == MAGAZINE
    @test nyt.list == []
end

@testset "Add subscriber" begin
    nyt = createPublisher("NYT", MAGAZINE)
    scrooge = createSubscriber("Scrooge McDuck", "scrooge@duckcity.com")
    subscribe(nyt, scrooge)
    @test nyt.list[1] == scrooge
    @test nyt.list[1].name == "Scrooge McDuck"
    @test nyt.list[1].email == "scrooge@duckcity.com"
end

@testset "Remove subscriber" begin
    nyt = createPublisher("NYT", MAGAZINE)
    scrooge = createSubscriber("Scrooge McDuck", "scrooge@duckcity.com")
    subscribe(nyt, scrooge)
    @test nyt.list[1] == scrooge
    nyt = unsubscribe(nyt, scrooge)
    @test nyt.list == []
end

@testset "Create Message" begin
    message = createMessage("Wether", "Temperatures", [24.0, 24.5, 25.0])
    @test message.header == "Wether"
    @test message.subject == "Temperatures"
    @test message.body == [24.0, 24.5, 25.0]
end

@testset "Calculate the average test" begin
    processMessage( s::Subscriber, n::Publisher, m::Message ) =
        (s.subscribertype == MEAN_CALCULATOR) ? sum(m.body) / length(m.body) : 0

    n = createPublisher( "The Duck Chronicals" )
    s = createSubscriber( "Donald Duck", "donald@duckcity.com", MEAN_CALCULATOR )
    subscribe(n, s)

    m = createMessage( "Weather station", "Temperatures", [10.0, 12.0, 9.0, 14.0, 8.0] )

    avg = processMessage(s, n, m)

    @test avg == 10.6
end

# TEST DATABASE OPERATIONS

@testset "In-memory database test" begin
    db = connect()
    @test db.file == ":memory:"
end

@testset "Store subscriber in database" begin
    db = connect()
    daisy = createSubscriber("Daisy")
    id = daisy.id
    name = daisy.name
    email = daisy.email
    subscribertype = daisy.subscribertype
    update( db, "subscribers", [daisy] )
    r = gather( db, "subscribers", "key = '" * daisy.id * "'" ).item
    @test r[1].id == id
    @test r[1].name == name
    @test r[1].email == email
    @test r[1].subscribertype == subscribertype
end

@testset "Store publisher in database" begin
    db = connect()
    nyt = createPublisher("The New York Times")
    id = nyt.id
    name = nyt.name
    publishertype = nyt.publishertype
    update(db, "publishers", [nyt])
    r = gather(db, "publishers", "key = '" * nyt.id * "'").item
    @test r[1].id == id
    @test r[1].name == name
    @test r[1].publishertype == publishertype
end

@testset "Convert name of subscribers to uppercase and store in database" begin
    db = connect()
    daisy = createSubscriber( "Daisy" )
    donald = createSubscriber( "Donald" )
    update( db, "subscribers", [daisy, donald] )
    r = gather( db, "subscribers" )
    s = map( i -> updateSubscriber( i, uppercase(i.name), i.email, i.subscribertype ), r.item )
    update( db, "subscribers", s )
    r = gather( db, "subscribers" )
    t = map( i -> last( gather( db, "subscribers", "key = '$i'" ) ).item, unique(r.key) )
    @test t[1].name == "DAISY"
    @test t[2].name == "DONALD"
end

@testset "Store messages in database" begin
    db = connect()
    message = createMessage( "Weather", "", [19.0, 22.5, 24.5] )
    id = message.id
    header = message.header
    subject = message.subject
    body = message.body
    update(db, "messages", [message])
    r = gather(db, "messages", "key = '" * message.id * "'").item
    @test r[1].id == id
    @test r[1].header == header
    @test r[1].subject == subject
    @test r[1].body == body
end
