module POMDPGallery

export gen_readme, run_scripts

function gen_readme(output=Pkg.dir("POMDPGallery", "README.md"))
    readme = IOBuffer()
    print(readme, """
        # POMDPGallery

        A gallery of models written for [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) with visualizations.

        For instructions on how to add new models, see [INSTRUCTIONS.md](INSTRUCTIONS.md).

        """)

    problemsdir = Pkg.dir("POMDPGallery", "problems")
    for problem in readdir(problemsdir)
        problemdir = joinpath(problemsdir, problem)
        url = strip(readstring(joinpath(problemdir, "url.txt")))
        desc = readstring(joinpath(problemdir, "description.txt"))

        println(readme, "## [$problem]($url)\n")
        println(readme, desc*"\n")

        println(readme, "![$problem](problems/$problem/out.gif)\n")
        println(readme, """
            ```julia
            $(strip(readstring(joinpath(problemdir, "script.jl"))))
            ```

            """)
    end
    file = open(output, "w")
    println(file, takebuf_string(readme))
    close(file)
    return true
end

function run_scripts(;allow_failure=String[])
    problemsdir = Pkg.dir("POMDPGallery", "problems")
    for problem in readdir(problemsdir)
        problemdir = joinpath(problemsdir, problem)
        script = joinpath(problemdir, "script.jl")
        # TODO: run in parallel
        runs = """cd("$problemdir"); include("$script")"""
        try
            run(`julia -e $runs`)
        catch ex
            if problem in allow_failure
                warn("Ignored error while testing $problem.")
                showerror(STDOUT, ex)
            else
                rethrow(ex)
            end
        end
    end
    return true
end

end # module
