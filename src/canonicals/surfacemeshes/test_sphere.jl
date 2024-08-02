using CompScienceMeshes
using BenchmarkTools
##
radius = 1.0
l = [1.0, 0.8, 0.6, 0.4, 0.2, 0.1, 0.08, 0.06, 0.05, 0.04, 0.02] 


for (i, len) in enumerate(l)

    println("\n length of element = ", len)
    println("\t mesh using 2D delaunay")
    @time s1 = mesh_sphere(radius, len, delaunay =:(2D));
    println("\t mesh using 3D delaunay")
    @time s2 = mesh_sphere(radius, len, delaunay =:(3D));
    println("\t mesh using CompScienceMeshes")
    @time s3 = meshsphere(radius, len);
    
end
##
