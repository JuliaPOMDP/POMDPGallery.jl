# How to add a new model to the gallery

1. Make sure you start from the master branch.
1. Create a directory in `problems` and put the files `description.txt`, `script.jl`, and `url.txt` in it. See [problems/LaserTag](problems/LaserTag) for an example.
    - `url.txt` should be the URL for a git repository (or other website) for the model.
    - `description.txt` should be a short description of the problem
    - `script.jl` should be a short Julia script that downloads the model and shows how to simulate it and how to create `out.gif`
2. Use Pkg to create a `Project.toml` and `Manifest.toml` to specify the dependency environment.
2. Generate `README.md` by running `POMDPGallery.gen_readme()`.
3. Submit a pull request with all of the new and updated files.
