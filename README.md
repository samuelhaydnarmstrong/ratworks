# Ratworks

## Running

To run the build locally it must be exported from Godot using the HTML exporter. If you're doing a new build then clear down the folder first.

## Deploying

1. Clear down everything already in the `build` folder
2. Export the project from Godot using the Web preset (without Debug) into the `build` folder
3. Rename the HTML file to `index.html`, it's probably exported as `ratworks.html`. Would be good to fix this somehow.
4. Push to Github. Vercel should automatically pick up the merge and deploy it. Note that it doesn't actually use `serve` it just statically serves the files itself.
