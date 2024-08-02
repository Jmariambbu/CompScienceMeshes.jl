using Plotly
using CompScienceMeshes
using BenchmarkTools
##
#Example usage
@time tt = tetmesh_cuboid(2.0, 2.0, 2.0, 0.5)
@benchmark tt
@time t = tetmeshcuboid(2.0, 2.0, 2.0, 0.5)
@benchmark t

##
length(tt.vertices)
length(t.vertices)
length(tt.faces)
length(t.faces)

##

