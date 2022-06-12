println("Setting up Julia for you.")
using Pkg
Pkg.add("IJulia"); Pkg.build("IJulia")

# I am not sure I need these build parts. It was necessary for the kernel above, and I 
# don't want to wait in Jupyter lab for them if it builds on first load.
Pkg.add("Plots"); Pkg.build("Plots")
Pkg.add("ForwardDiff"); Pkg.build("ForwardDiff")

using Plots, ForwardDiff

println("Finished setting up Julia!")