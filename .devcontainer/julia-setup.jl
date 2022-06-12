println("Setting up Julia for you.")
using Pkg
Pkg.add("IJulia"); Pkg.build("IJulia")


# these are based on our work at 
# https://aiche.onlinelibrary.wiley.com/action/downloadSupplement?doi=10.1002%2Faic.17653&file=aic17653-sup-0001-Supinfo.pdf
# I am not sure I need these build parts. It was necessary for the kernel above, and I 
# don't want to wait in Jupyter lab for them if it builds on first load.
Pkg.add("Plots"); Pkg.build("Plots")
Pkg.add("GRUtils"); Pkg.build("GRUtils")
Pkg.add("DifferentialEquations"); Pkg.build("DifferentialEquations")
Pkg.add("DiffEqSensitivity"); Pkg.build("DiffEqSensitivity")
Pkg.add("ForwardDiff"); Pkg.build("ForwardDiff")
Pkg.add("LaTeXStrings"); Pkg.build("LaTeXStrings")

println("Finished setting up Julia!")