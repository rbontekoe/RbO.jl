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