using POMDPGallery
using Base.Test

@test run_scripts()
@test gen_readme("/tmp/test_README.md")
