module POMDPGallery

export gen_readme, run_scripts

function gen_readme(output=joinpath(dirname(@__FILE__()), "..", "README.md"))
    readme = IOBuffer()
    print(readme, """
        # POMDPGallery

        [![Build Status](https://travis-ci.org/JuliaPOMDP/POMDPGallery.jl.svg?branch=master)](https://travis-ci.org/JuliaPOMDP/POMDPGallery.jl)

        A gallery of models written for [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) with visualizations. You should be able to copy and paste the code below each visualization to run it on your local machine.

        For instructions on how to add new models, see [INSTRUCTIONS.md](INSTRUCTIONS.md).

        For the older version of this package with julia-0.6 models, see [this branch](https://github.com/JuliaPOMDP/POMDPGallery.jl/tree/julia-0.6).
        """)

    problemsdir = joinpath(dirname(@__FILE__()), "..", "problems")
    for problem in readdir(problemsdir)
        problemdir = joinpath(problemsdir, problem)
        url = strip(read(joinpath(problemdir, "url.txt"), String))
        desc = read(joinpath(problemdir, "description.txt"), String)

        println(readme, "## [$problem]($url)\n")
        println(readme, desc*"\n")

        println(readme, "![$problem](problems/$problem/out.gif)\n")
        println(readme, """
            ```julia
            $(strip(read(joinpath(problemdir, "script.jl"), String)))
            ```

            """)
    end
    file = open(output, "w")
    println(file, String(take!(readme)))
    close(file)
    return true
end

function run_scripts(;allow_failure=String[])
    pkgdir = joinpath(dirname(@__FILE__()), "..")
    problemsdir = joinpath(pkgdir, "problems")
    problems = readdir(problemsdir)
    results = similar(problems, Any)

    # @sync for (i, problem) in enumerate(problems)
    for (i, problem) in enumerate(problems)
        # @async begin
        begin
            println("Launching $problem...")
            problemdir = joinpath(problemsdir, problem)
            script = joinpath(problemdir, "script.jl")
            runs = """cd("$problemdir"); using Pkg; Pkg.activate("."); Pkg.instantiate(); include("$script")"""
            # outfile = joinpath(problemdir, "stdout.log")
            # errfile = joinpath(problemdir, "stderr.log")
            # pipe = pipeline(`julia --project=$pkgdir -e $runs`, stdout=outfile, stderr=errfile)
            # procs[i] = run(pipe, wait=false)
            # wait(procs[i])
            results[i] = try
                run(`julia --project=$pkgdir -e $runs`)
            catch ex
                ex
            end

            println("Finished $problem: $(passed(results[i]) ? "passed" : "FAILED")")
            # if !success(procs[i])
            #     println("""
            #             ====================
            #             stderr for $problem:
            #             ====================
            #             """)
            #     println(read(outfile, String))
            #     println("""
            #             ====================
            #             stdout for $problem:
            #             ====================
            #             """)
            #     println(read(errfile, String))
            # end
        end
    end

    pass = true
    println("""\n\n\n
            =====================
            POMDPGallery Summary:
            =====================

            """)
    for i in 1:length(problems)
        print(problems[i]*": ")
        if passed(results[i])
            println("passed")
        else
            println("FAILED")
            if !(problems[i] in allow_failure)
                pass = false
            end
        end
    end
    println("\n\n")

    return pass
end

passed(proc) = success(proc)
passed(ex::ProcessFailedException) = false

end # module
