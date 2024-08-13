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
s1 = []
s2 = []
s3 = []

for (i, len) in enumerate(l)

    append!(s1, @elapsed mesh_sphere(radius, len, delaunay =:(2D)));
    append!(s2, @elapsed mesh_sphere(radius, len, delaunay =:(3D)));
    append!(s3, @elapsed meshsphere(radius, len));
    
end

s1
s2
s3
plot()
p = plot(l, s3, label = "CompScienceMeshes", marker = true)
plot!(l, s1, label = "Delaunay 2D", marker = true)
plot!(l, s2, label = "Delaunay 3D", marker = true)

plot!(xscale=:log10, yscale =:log10, minorgrid =true)
xlabel!("edge length")
ylabel!("time (s)")
title!("Log-log plot for edge length and time elapsed")

plot(p)

##
