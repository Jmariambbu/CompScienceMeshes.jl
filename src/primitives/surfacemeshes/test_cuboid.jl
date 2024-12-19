using BEAST
using CompScienceMeshes
using Test
using Printf
using Plots
using BenchmarkTools

mesh = mesh_cuboid(1.0, 1.0, 1.0, 0.01)

nedges = length(BEAST.raviartthomas(mesh).pos) 

@test length(mesh.vertices) - nedges + length(mesh.faces) == 2

@time m_c = mesh_cuboid(1.0, 1.0, 1.0, 0.1);
@time mc= meshcuboid(1.0, 1.0, 1.0, 0.1);

##
#Comparison for number of vertices and faces

l = [0.1, 0.01, 0.001]

for i in 1:length(l)
    println("Edge length:", l[i])
    println("Number of vertices:", length(mesh_cuboid(1.0, 1.0, 1.0, l[i]).vertices))
    println("Number of faces:", length(mesh_cuboid(1.0, 1.0, 1.0, l[i]).faces))
end
##
#Comparison for average time
edge_len = [0.5, 0.1, 0.01]

h = 0
y1 = []
y2 =[]
for i in 1:length(edge_len)
    h = edge_len[i]

  append!(y1, @belapsed meshcuboid(1.0, 1.0, 1.0, h));
  append!(y2, @belapsed mesh_cuboid(1.0, 1.0, 1.0, h));
end

#for i in 1:length(edge_len)
    println("Edge length:\n", 0.005)
    # Case
    println("CompScienceMeshes:")
    @time meshcuboid(1.0, 1.0, 1.0, 0.005)
    println("Regular meshes:")
    @time mesh_cuboid(1.0, 1.0, 1.0, 0.005)
    
#end

##

