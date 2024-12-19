using CompScienceMeshes
using Test
using BenchmarkTools
using Printf

##
#Comparison for number of vertices and faces

l = [0.1, 0.01, 0.001]
for i in 1:length(l)
    refrect = meshrectangle(1.0, 1.0, l[i])
    rect = mesh_rectangle(1.0, 1.0, l[i])
    @test length(refrect.vertices) == length(rect.vertices)
    isapprox( refrect.vertices, rect.vertices)
    @test refrect.faces == rect.faces
end

##
#Comparison for benchmarking
println("CompScienceMeshes:")
@benchmark refrect
println("Regular meshes:")
@benchmark rect

## 
#Comparison for average time
edge_len = [10.0^(-i) for i in 1:3]
h = 0
for i in 1:3
    #@printf("Edge length:%.3f\n", edge_len[i])
    # Case
    h = edge_len[i]
    #println("CompScienceMeshes:")
    @btime refrect = meshrectangle(1.0, 1.0, h);
    #println("Regular meshes:")
    @btime rect = mesh_rectangle(1.0, 1.0, h);
end

##
