using POMDPGallery
using Base.Test
using Plots

try
    pyplot()
catch ex
    warn("PyPlot is not working. Attempting to install it.")
    ENV["PYTHON"]=""
    Pkg.build("PyCall")
    Pkg.build("PyPlot")
end

@test run_scripts(allow_failure=["ContinuumWorld"])
@test gen_readme("/tmp/test_README.md")

@test readstring("/tmp/test_README.md") == readstring(Pkg.dir("POMDPGallery", "README.md"))
