# main module  - rbontekoe@appligate.nl
module RbO

    export createPublisher, createSubscriber, subscribe, unsubscribe, createMessage, sendMessage

    include("api.jl")
    include("domain.jl")

end #end of RobObserverModel.jl
