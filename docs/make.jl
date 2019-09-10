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
        "API methods" => "module_b.md",
        "Database methods" => "module_b2.md",
        "Domain Items" => "module_c.md",
        "Examples" => "module_d.md"
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
