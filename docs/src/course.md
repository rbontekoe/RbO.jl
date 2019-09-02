# Tutorial

## Building applications with Julia

## Introduction
I switched to Julia because it is easy to use, and an active community supports it. Also, I like how easy you can create documentation and help with Julia, as well as testing your application. It changed my mind when I discovered that in your documentation code fragments can automatically be tested during the creation of the document. Creating this tutorial is to check whether I can explain what I have learned from this project.

## Tutorial Description

### Target audience
The target audience for the tutorial **Building applications with Julia** is application developers who want to use Julia in a structured way.

### Summary description
Students will learn the technique to create a module that can to be used in container-based applications. The tutorial starts creating the domain layer. Besides the domain objects, we defined functions for the API layer and the Infrastructure layer. Students learn to create documentation for the application that also tests the code examples.

### Tutorial format and duration
tbd

### Tutorial goals
By the end of the tutorial, you should be able to:
- Create a model with Domain, API, and Infrastructure layers.
- Create a Julia module.
- Create the documentation for your module.
- Let the application communicate over a network.

# Module A: Creating the model

## The Domain layer
!!! note

    The design is based on the **Domain Driven Design and the Onion Pattern**. This [link] (https://www.infoq.com/news/2014/10/ddd-onion-architecture/) explains the pattern. Accordingly, we have split the code over three scripts (under the src directory):
    - domain.jl
    - api.jl
    - infrastructure.api

    You can find the code on [GitHub] (https://github.com/rbontekoe/RbO.jl).

We have chosen a simple model. Publishers send messages to subscribers. You can think an IoT application that consists of Raspberry Pi Zeros as publishers that send room temperatures to a central system, the subscriber. In Julia, you define objects as structs.
```
struct Subscriber
    name
    email
end # defined Subscriber object
```
A struct is an immutable object. So, you can't change its properties afterward. You can only read the values.
```
# Create a subscriber
daisy = Subscriber("Daisy", "daisy@duckcity.com")

# Print the name of the subscriber to the console
println( daisy.name )

# Reassign to change the object properties.
daisy = Subscriber("Daisy Duck", "daisy@duckcity.com")
```
!!! note

    When you prepend the keyword struct with 'mutable', you can alter its values.

## Delaring enumerator data types
We could have subscribers who can do different jobs, e.g., calculate the average temperature of a data set, plotting it, or even determine trends. Because we want to define the possible values clearly, we use enumerator data types.
```
@enum SubscriberType begin
    MEAN_CALCULATOR
    STD_CALCULATOR
    PLOTTER
end # defined enumeration for Subscriber type
```
We incorporate it into our Subscriber struct as follows, where we now also declare the data type of a property.  To state the data type of a variable, you append to it a pair of colons (::) followed by the name of the Type.
```
struct Subscriber
    name::String
    email::String
    subscribertype::SubscriberType
end # defined Subscriber object
```

## Functions for the API layer
We make use of an API layer to make it easier for the users to work with our model. The API functions can be the best defined in the Domain layer and implemented in the API layer. We declare the next services.
```
function createSubscriber end
function createPublisher end
function subscribe end
function unsubscribe end
function createMessage end
function sendMessage end
```

We implement the functions in the API layer.

## Functions for the Infrastructure layer
The infrastructure layer is our connection to the outer world. To be able to connect to different interfaces, we make use of the adapters. For example, to save the message, we can define adapters for in-memory storage or in a database.
```
function createDbConnection end
function create end
function read end
function update end
function delete end
```
We implement the functions in the Infrastructure layer.

# Module B: Implementing the model

## Application structure
```
RbO.jl
--src
    |--api.jl
    |--domain.jl
    |--infrastructure.jl
    |--RbO.jl
--test
    |--runtests.jl
```

## Implementing the Domain in domain.jl
We refer to [github](https://github.com/rbontekoe/RbO.jl) for an overview of our business model. Here we show the implementation of the Subscriber, including the help documentation.
```
"""
    struct Subscriber

# Arguments
- name::String
- email::String
- subscribertype::SubscriberType

Instanstiation: see: : [`createSubscriber()`](@ref)
Reference: RbO.Subscriber

# Example
julia> daisy = Subscriber("Daisy")
"""
struct Subscriber
    name::String
    email::String
    subscribertype::SubscriberType
    #constructors
    Subscriber( name::String ) = new( name, "", MEAN_CALCULATOR )
    Subscriber( name::String, email::String ) = new( name, email, MEAN_CALCULATOR )
    Subscriber( name::String, email::String, subscribertype::SubscriberType ) = new( name, email, subscribertype )
end # defined Subscriber object
```

## Implementing the API in api.jl
To make it easier for the user of our model, we offer an API. There are three ways the user can instantiate a Subscriber object. The three ways are:
```
createSubscriber( name::String ) ::Subscriber =
    Subscriber( name )

createSubscriber( name::String, email::String ) ::Subscriber =
    Subscriber( name, email )

createSubscriber( name::String, email::String, subscribertype::SubscriberType )::Subscriber =
    Subscriber( name, email, subscribertype )
```

## Implementing the Infrastructure in infrastructure.jl
tbd

# Module C: Creating the Module RbO
Users can use packages with the 'using'-command, after they are imported, either from the Julia repository or GitHub. The import a package you need 'add'-command from the Package Manager. You activate the Package Manager with the closing brackets (]). When you import the package from GitHub you use the URL of the package name extended with .jl.

```
julia> ]

(v1.1) pkg> add Statistics

(v1.1) pkg> add https://github.com/rbontekoe/RbO.jl
```
To create a package you need to do two steps:
1. Install git.
2. Start with an empty directory.
3. Create the right package structure.
4. Define your package as a module.

## 1. Install git

| Step | Action | Comment |
| :--- | :--- | :--- |
| 1 | $ sudo apt install git | Installs git. |
| 2 | $ git | Shows the commands. |


## 2. Start with an empty directory

Start with an empty directory that have the name of the package, .e.g., RbO.jl

| Step | Action | Comment |
| ---: | :--- | :--- |
| 1 | $ mkdir julia_projects | The master directory for our projects. |
| 2 | $ cd julia_projects | Steps into julia_projects. |
| 3 | $ mkdir RbO.jl | A directory with the name of the package .jl is mandatory. |
| 4 | $ cd RbO.jl |   |
| 5 | $ git init | It initializes git for the directory RbO. |
| 6 | $ echo "# RbO.jl" >> README.md | Create a markdown file with an H1 header.  |
| 7 | $ git status | It shows all the changed files in red. |
| 8 | $ git add README.md | Makes the file ready for a commit. |
| 9 | $ git status | All the files to be committed are in green. |
| 10 | $ git commit "First commit" | Adds a comment. |
| 11 | $ git remote add origin https://github.com/rbontekoe/RbO.jl.git | The repository you created on GitHub. |
| 12 | $ git push -u origin master | It pushes the committed files to GitHub. |

!!! note

    GitHub asks for your username and password when you want to upload changes.

## 3. Create the right package structure

You can create now the other directories and files of your module, e.g.:
```
RbO.jl
--src
    |--api.jl
    |--domain.jl
    |--infrastructure.jl
    |--RbO.jl
--test
    |--runtests.jl
--README.md
```

### Commit changes as follows.

| Step | Action | Comment |
| ---: | :--- | :--- |
| 1 | $ git status | It shows all changes. |
| 2 | $ git add <file> | It adds the files to have to be committed. |
| 3 | $ git commit -m "Comment changes" | It indicates what you have changed. |
| 4 | $ git push | It pushes changes to GitHub.   |

## 4. Define your package as a module

RbO.jl the file that defines the module. A module is the code between 'module' and 'end'.
```
# main module
module RbO

    export createPublisher, createSubscriber, subscribe, unsubscribe, createMessage, sendMessage

    include("api.jl")

end # end of RbO.jl

```

With include("api.jl") we make the API layer accessible for the module. The API layer has access to the domain items by doing the same:

```
include("domain.jl").
```

With 'export' we declare which functions of the API layer the user is allowed to access.

### Upload changes after the first timme

| Step | Action | Comment |
| ---: | :--- | :--- |
| 1 | $ cd julia-projects/RbO.jl | Goes to Rbo.jl. |
| 2 | $ git status | It shows the changes. |
| 3 | $ git add <file> | It commits a file. |
| 4 | $ git commit -m "Update of the model" | It adds a comment. |
| 5 | $ git push | It pushes the changes to GitHub. |

## Testing your code
During development, we want to test our code. To make our module available, we should tell Julia where it can find RbO.jl. We can define it by extending the load path:

```
julia> push!(LOAD_PATH, "/home/rob/julia_projects/RbO.jl/src/")
4-element Array{String,1}:
 "@"                                   
 "@v#.#"                               
 "@stdlib"                             
 "/home/rob/julia_projects/RbO.jl/src/"

 julia> using RbO

```

## Make the package available for your users

In Julia the user can install the package as follows.

| Step | Action | Comment |
| ---: | :--- | :--- |
| 1 | $ julia | Start Julia. |
| 2 | julia> ] | Activate the package manager. |
| 3 | (v1.1) pkg> add https://github.com/rbontekoe/RbO.jl | **mport the package. |
| 4 | (v1.1) pkg> Ctrl-C | Return to julia. |
| 5 | julia> using RbO | Activate the package. |
| 6 | julia> daisy = createSubscriber("Daisy") | Response: Subscriber("Daisy", "", MEAN_CALCULATOR::SubscriberType = 0) |
| 7 | julia> println(daisy.name) | The display shows: Daisy |

!!! note

    When you double press the **Tab**-button after a dot, you see the properties or methods you can use.

    daisy. <double tab> => email, name, and subscribertype

# Documentation

We are in favor of documenting our code. Documenter.jl is a package to create documentation. When looking at the features of documenter.jl, we notice:
- Markdown language.
- Uploading a module to GitHub, it adds the package automatically to your pages, e.g., rbontekoe.github.io/RbO.jl.
- You can specify that documenter runs all your tests successfully before it creates the documentation, e.g., doctest(RbO) in the file make.jl.
- You can determine that documenter tests the example code before it produces the manual, e.g.,  ```jldoctest``` blocks in the documentation.
- You can create your developer's user manual during development.

References
- [Mark Down Language Julia] (https://pkg.julialang.org/docs/julia/THl1k/1.1.1/stdlib/Markdown.html)
- [Documenter.jl] (https://juliadocs.github.io/Documenter.jl/stable/)

## Document structure
```
RbO.jl
    |--docs
        |--build
            |--index.html
        |--src
            |--index.md
        |--make.jl
    |--src
        |--api.jl
        |--domain.jl
        |--infrastructure.jl
        |--RbO.jl
    |--test
        |--runtests.jl
```

### DocumenterTools
The structure can created with the aid of DocumenterTools.jl"
```
use DocumenterTools

DocumenterTools.generate(RbO)
```

### index.md
The documentaion in markdow language. An fragment:

```
## createSubscriber
**createSubscriber( name [, email [, subscribertype]] )**

# Arguments
- `name::String`: name of the subscribers.
- `email::String`: email address of the subscribers
- `subscribertype::SubscriberType`: kind of subscriber, see exports.
```

``` ```
ABC
``` ```

A paragraph containing a ``` ```backtick``` character ```.

### make.jl
The file that creates the documentation.
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
        "1 - User manual" => "index.md",
    ]
)
```

# Installing Julia (and Atom and IJulia Notebook)

## Installing Julia 1.1.1 on Ubuntu 18.04.3 and

We work with Ubuntu 18.3. Ubuntu runs on an X86 processor, in our case a Lenovo Legion Y520 on a USB disk.

The steps to install Julia. See the Packt book [Julia 1.0 Programming] (https://subscription.packtpub.com/book/application_development/9781788998369/1/ch01lvl1sec12/installing-julia-from-binaries)
- $ sudo apt update
- $ sudo apt -y install build-essential
- $ mkdir testjulia
- $ cd testjulia
- $ wget https://julialang-s3.julialang.org/bin/linux/x64/1.1/julia-1.1.1-linux-x86_64.tar.gz
- $ tar xvfz julia-1.1.1-linux-x86_64.tar.gz
- $ sudo ln -s /home/rob/testjulia/julia-1.1.1/bin/julia /usr/local/bin/julia (file is located in /etc/envirionment)
- $ julia
- julia> Ctrl-D

Next, we have Atom installed as [IDE] (https://codeforgeek.com/install-atom-editor-ubuntu-14-04/)
- $ sudo add-apt-repository ppa:webupd8team/atom
- $ sudo apt update
- $ sudo apt install atom
- $ atom

Then install the package [Juno] (http://docs.junolab.org/latest/man/installation/)
- In Atom, go to Settings (Ctrl+,, or Cmd+, on macOS) and go to the "Install" panel.
- Type uber-juno into the search box and hit enter. Click the install button on the package of the same name.
- Atom will then set up Juno for you, installing the required Atom and Julia packages.

We also installed [IJulia Notebook] (http://docs.junolab.org/latest/man/installation/)
- $ julia
- julia> ] add IJulia
- julia> using IJulia
- julia> notebook()
- or
- julia> notebook(dir="./")

## Working with Atom
See also [Terminal and Editor] (http://tutorials.jumpstartlab.com/academy/workshops/terminal_and_editor.html)

Suppose you want to test the file test.jl in Atom. Perform the next steps.
- $ mkdir julia-projects
- $ cd julia-projects
- $ mkdir tests
- $ cd test
- $ touch test.jl
- $ atom
- Select Open a Project and navigate to the directory 'julia-projects'.
- Select the directory 'test' and click on OK.
- Select the empty file 'test.jl'.
- Copy the example code in the section Examples - test.jl to empty file.
- Before you test the code you have to import the packages RbO, Plots, and Statistics.
- julia> ]
- (v1.1) pkg> add https://github.com/rbontekoe/RbO.jl
- (v1.1) pkg> add Plots
- (v1.1) pkg> add Statistics
- Ctrl-C
- Now you can test the code line for line by pressing Shift-Enter.
- Or go the the menu 'Julia' and select the command 'Run All' (or the triangle in the navigation tree).

## Working with the Julia Package Manager
[A Brief Introduction to Package Management with Julia 1.0] (https://www.simonwenkel.com/2018/10/06/a-brief-introduction-to-package-management-with-julia.html)

Particularly noteworthy is the section 'Setting Up Projects' using the package manager 'activate ./'-command. Packages imported are only visible for the specified directory. It makes it easier to experiment with modules without creating a chaos of packages.
