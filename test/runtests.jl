using Test
include("../src/api.jl")

@testset "PublisherTyRbo.rupe test" begin
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

@testset "Publisher name test" begin
    nyt = createPublisher("NYT")
    @test nyt.name == "NYT"
    @test nyt.publishertype == NEWSPAPER
    @test nyt.list == []
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

@testset "Calculate the average" begin
    processMessage( s::Subscriber, n::Publisher, m::Message ) =
        (s.subscribertype == MEAN_CALCULATOR) ? sum(m.body) / length(m.body) : 0

    n = createPublisher( "The Duck Chronicals" )
    s = createSubscriber( "Donald Duck", "donald@duckcity.com", MEAN_CALCULATOR )
    subscribe(n, s)

    m = createMessage( "Weather station", "Temperatures", [10.0, 12.0, 9.0, 14.0, 8.0] )

    avg = processMessage(s, n, m)

    @test avg == 10.6
end
