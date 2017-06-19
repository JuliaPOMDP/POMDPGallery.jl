# How to add a new model to the gallery

## Overview

1. Make sure you start from the master branch.
1. Create a directory in `problems` and put `description.txt`, `script.jl`, `url.txt`, and `out.gif` in it.
2. Generate `README.md` by running `POMDPGallery.gen_readme()`.
3. Submit a pull request with all of the new and updated files.

## More detailed instructions

Throughout all instructions, replace YOUR_NEW_MODEL with the name of your model, e.g. LaserTag

1. Run the following commands in Julia to prepare to add a new model
    ```julia
    Pkg.add("POMDPGallery")
    Pkg.checkout("POMDPGallery")
    cd(Pkg.dir("POMDPGallery"))
    ;git checkout -b YOUR_NEW_MODEL_branch
    ;mkdir problems/YOUR_NEW_MODEL
    ```
    You have now checked out a branch for adding your new model. See the [Code Changes section of the Julia documentation](https://docs.julialang.org/en/stable/manual/packages/#code-changes) for more info.

3. In that directory, create the files `description.txt`, `script.jl`, and `url.txt`. See [problems/LaserTag](problems/LaserTag) for an example.
    - `url.txt` should be the URL for a git repository (or other website) for the model.
    - `description.txt` should be a short description of the problem
    - `script.jl` should be a short Julia script that downloads the model and shows how to simulate it and ideally how to create `out.gif`

4. Run `script.jl` in your problem directory to create `out.gif` in the problem directory (or manually put `out.gif` in your problem directory if it is not created by `script.jl`).

5. Generate `README.md` with the following commands in julia.

    ```julia
    using POMDPGallery
    gen_readme()
    ```

6. Test and commit the changes by running the following commands in Julia:

    ```julia
    Pkg.test("POMDPGallery")
    cd(Pkg.dir("POMDPGallery", "problems", "YOUR_NEW_MODEL"))
    ;git add description.txt script.jl url.txt out.gif
    ;git commit -a -m "Added YOUR_NEW_MODEL"
    ```

7. Create a pull request with the following Julia commands.

    ```julia
    using PkgDev
    PkgDev.submit("POMDPGallery")
    ```

See the [Code Changes section of the Julia documentation](https://docs.julialang.org/en/stable/manual/packages/#code-changes) for more info.
