using POMDPGallery
using Test
# using Plots

# try
#     pyplot()
# catch ex
#     warn("PyPlot is not working. Attempting to install it.")
#     ENV["PYTHON"]=""
#     Pkg.build("PyCall")
#     Pkg.build("PyPlot")
# end

# @test run_scripts(allow_failure=["LaserTag"])
@test run_scripts()
@test gen_readme("/tmp/test_README.md")

@test read("/tmp/test_README.md", String) == read(joinpath(dirname(pathof(POMDPGallery)), "..", "README.md"), String)
