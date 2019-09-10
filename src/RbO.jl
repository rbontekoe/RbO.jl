# main module  - rbontekoe@appligate.nl
module RbO

    using SQLite, DataFrames

    # Domain objects
    export createPublisher, createSubscriber, subscribe, unsubscribe, createMessage, sendMessage

    # Database functions
    export connect, create, gather, update, delete

    # Additional
    export updateSubscriber, updatePublisher, updateMessage

    include("./api/api.jl")

end #end of RobO.jl
