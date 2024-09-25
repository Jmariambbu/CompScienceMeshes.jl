using CompScienceMeshes
using BenchmarkTools
##
#Example usage
println("Edge length:", 0.05)
println("Regular tetrahedral mesh:")
@time tt = tetmesh_cuboid(1.0, 1.0, 1.0, 0.05);
@benchmark tt
println("CompScienceMeshes tetrahedral mesh:")
@time t = tetmeshcuboid(1.0, 1.0, 1.0, 0.05);
@benchmark t

##
length(tt.vertices)
length(t.vertices)
length(tt.faces)
length(t.faces)

##

h = [1.0, 0.1, 0.01]
for i in 1:length(h)
    println("Edge length:", h[i])
    println("Number of vertices:", length(tetmesh_cuboid(1.0, 1.0, 1.0, h[i]).vertices))
    println("Number of faces:", length(tetmesh_cuboid(1.0, 1.0, 1.0, h[i]).faces))
end

##

println("Edge length:", 0.01)
println("Regular mesh:")
@time tetmesh_cuboid(1.0, 1.0, 1.0, 0.01);
println("CompScience:")
@time tetmeshcuboid(1.0, 1.0, 1.0, 0.01);



##
