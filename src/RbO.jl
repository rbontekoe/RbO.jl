# main module  - rbontekoe@appligate.nl
module RbO

    greet() = print("RbO")

    using SQLite, DataFrames

    # Domain objects
    export createPublisher, createSubscriber, subscribe, unsubscribe, createMessage, sendMessage

    # Database functions
    export connect, create, gather, update, delete

    # Additional
    export updateSubscriber, updatePublisher, updateMessage

    include("./api/api.jl")
    include("./infrastructure/db.jl")

end #end of RobO.jl
