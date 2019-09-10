# Installing the module
The module can be added or cloned from GitHub: https://github.com/rbontekoe/RbO.jl.

## Example of adding the module
| Step | Action | Comment |
| :--- | :--- | :--- |
| 1 | julia> ] | Open Package manager. |
| 2 | (v1.1) pkg> add https://github.com/rbontekoe/RbO.jl | Add RbO.jl |
| 3 | (v1.1) pkg> Ctrl-C | Return to Julia. |
| 4 | julia> using RbO | Activate RbO. |


## Example of cloning the module
Step | Action | Comment |
| :--- | :--- | :--- |
| 1 | $ mkdir julia_projects |
| 2 | $ cd julia_projects |
| 3 | $ git clone https://github.com/rbontekoe/RbO.jl.git |  Download the package RbO. |
| 4 | $ cd RbO.jl | Go to RbO.jl directory. |
| 5 | $ julia | Start Julia |
| 6 | julia> push!(LOAD_PATH, "/home/rob/julia\_projects/RbO.jl/src/") | Declare path. |
| 7 | julia> using RbO | Activate package |
