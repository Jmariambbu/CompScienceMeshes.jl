using CompScienceMeshes
using Test
using BenchmarkTools
using Printf
using Plots

##
#Comparison for number of vertices and faces
refrect = meshrectangle(1.0, 1.0, 0.1)
rect = mesh_rectangle(1.0, 1.0, 0.1)
l = [0.1, 0.01, 0.001]
for i in 1:length(l)
    println("Edge length:", l[i])
    println("Number of vertices:", length(mesh_rectangle(1.0, 1.0, l[i]).vertices))
    println("Number of faces:", length(mesh_rectangle(1.0, 1.0, l[i]).faces))
end
@test length(refrect.vertices) == length(rect.vertices)
isapprox( refrect.vertices, rect.vertices)
@test refrect.faces == rect.faces

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
    @printf("Edge length:%.3f\n", edge_len[i])
    # Case
    h = edge_len[i]
    println("CompScienceMeshes:")
    @btime refrect = meshrectangle(1.0, 1.0, h);
    println("Regular meshes:")
    @btime rect = mesh_rectangle(1.0, 1.0, h);
end

##

plot()
h = [0.5, 0.1, 0.05, 0.01, 0.005, 0.001, 0.0005, 0.0001]

yc = [@elapsed meshrectangle(1.0, 1.0, h[i]) for i in 1:length(h)]
yr = [@elapsed mesh_rectangle(1.0, 1.0, h[i]) for i in 1:length(h)]

yc
p = plot(h, yc, label = "CompScienceMeshes", marker = true)
plot!(h, yr, label = "Regular", marker = true)
plot!(xscale=:log10, yscale =:log10, minorgrid =true, xlim = [0.5*10.0^(-4), 0.9])
xlabel!("edge length")
ylabel!("time (s)")
title!("Log-log plot for edge length and time elapsed")
for i in 1:length(h)
    annotate!((h[i]), (yc[i]), text(yc[i], :top, 6))
    annotate!((h[i]), (yr[i]), text(yr[i], :top, 6))
end
plot(p)