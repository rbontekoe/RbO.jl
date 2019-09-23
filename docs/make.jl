# push!(LOAD_PATH, "/home/rob/julia_projects/RbO.jl/src/")
using Documenter
using RbO, Statistics
using Test

doctest(RbO)

makedocs(
    sitename = "RbO.jl",
    format = Documenter.HTML(),
    modules = [RbO],
    pages = [
        "User Manual" => "index.md",
        "Installing the module" => "module_a.md",
        "Public Interface" => [
            "API methods" => "module_b.md",
            "Infrascructure methods" => "module_b2.md",
            "Domain items" => "module_c.md",
            "Example" => "module_b3.md"
        ],
        "Appendix" => "module_d.md"
    ]
)

# "Building applications with Julia" => "course.md"

#=deploydocs(
    repo = "github/rbontekoe/RbO.jl.git"
)=#

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
