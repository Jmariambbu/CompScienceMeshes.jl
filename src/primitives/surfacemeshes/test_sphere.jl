using CompScienceMeshes
using BenchmarkTools
##
radius = 1.0
l = [1.0, 0.8, 0.6, 0.4, 0.2, 0.1, 0.08, 0.06, 0.05, 0.04, 0.02] 
for i in 1:2:length(l)
    println("Edge length:", l[i])
    println("Number of vertices:", length(mesh_sphere(radius, l[i]).vertices))
    println("Number of faces:", length(mesh_sphere(radius, l[i]).faces))
end

##
println("Edge length:", 0.1)
println("Delaunay 2D")
@time mesh_sphere(radius, 0.1, delaunay =:(2D));
println("Delaunay 3D")
@time mesh_sphere(radius, 0.1, delaunay =:(3D));
println("CompScienceMeshes")
@time meshsphere(radius, 0.1);

##

##
