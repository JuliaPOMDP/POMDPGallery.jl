module POMDPGallery

using Pkg

export gen_readme, run_scripts

function gen_readme(output=joinpath(dirname(@__FILE__()), "..", "README.md"))
    readme = IOBuffer()
    print(readme, """
        # POMDPGallery

        [![Build Status](https://travis-ci.org/JuliaPOMDP/POMDPGallery.jl.svg?branch=master)](https://travis-ci.org/JuliaPOMDP/POMDPGallery.jl)

        A gallery of models written for [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) with visualizations. You should be able to copy and paste the code below each visualization to run it on your local machine.

        For instructions on how to add new models, see [INSTRUCTIONS.md](INSTRUCTIONS.md).

        """)

    problemsdir = joinpath(dirname(@__FILE__()), "..", "problems")
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
    println(file, String(take!(readme)))
    close(file)
    return true
end

function run_scripts(;allow_failure=String[])
    problemsdir = joinpath(dirname(@__FILE__()), "..", "problems")
    problems = readdir(problemsdir)
    passed = similar(problems, Bool)
    for (i, problem) in enumerate(problems)
        problemdir = joinpath(problemsdir, problem)
        script = joinpath(problemdir, "script.jl")
        # TODO: run in parallel
        runs = """cd("$problemdir"); include("$script")"""
        try
            run(`julia --project=$problemdir -e $runs`)
        catch ex
            if problem in allow_failure
                warn("Ignored error while testing $problem.")
                showerror(STDOUT, ex)
                passed[i] = false
                continue
            else
                rethrow(ex)
            end
        end
        passed[i] = true
    end
    if !isempty(allow_failure)
        println("""\n\n\n
                =====================
                POMDPGallery Summary:
                =====================

                """)
        for i in 1:length(problems)
            print(problems[i]*": ")
            if passed[i]
                println("passed")
            else
                println("FAILED")
            end
        end
        println("\n\n")
    end
    return true
end

end # module
