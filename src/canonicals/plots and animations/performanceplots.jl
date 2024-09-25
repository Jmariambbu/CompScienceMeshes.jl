using CompScienceMeshes
using Plots
using BenchmarkTools
##
#mesh_rectangle
#time comparison
Plots.plot()
h = [0.5, 0.1, 0.05, 0.01, 0.005, 0.001, 0.0005, 0.0001]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, @belapsed meshrectangle(1.0, 1.0, t))
    append!(yr, @belapsed mesh_rectangle(1.0, 1.0, t))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", 
marker = true, xticks = (h, string.(h)), minorticks = false)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, xaxis = :flip, yscale =:log10, 
legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "Time in s")
Plots.yticks!([10.0^(i) for i in -6:1])
##
#alloc comparison
#requires Julia v1.9
Plots.plot()
h = [1.0, 0.5, 0.25, 0.2, 0.1, 0.05, 0.025]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, @allocations meshrectangle(1.0, 1.0, t))
    append!(yr, @allocations mesh_rectangle(1.0, 1.0, t))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true, 
xticks = (h, string.(h)), minorticks = false)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, xaxis = :flip, yscale =:log10, 
legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "No. of Allocs")
##
#memory comparison
Plots.plot()
h = [1.0, 0.5, 0.25, 0.2, 0.1, 0.05, 0.025]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, @allocated meshrectangle(1.0, 1.0, t))
    append!(yr, @allocated mesh_rectangle(1.0, 1.0, t))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true, 
xticks = (h, string.(h)), minorticks = false)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, xaxis = :flip, yscale =:log10, 
legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "Memory")
##
#faces and edge length comparison
Plots.plot()
h = [1.0, 0.5, 0.25, 0.2, 0.1, 0.05, 0.025]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, length(meshrectangle(1.0, 1.0, t).faces))
    append!(yr, length(mesh_rectangle(1.0, 1.0, t).faces))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true, 
markersize = 8, xticks = (h, string.(h)), minorticks = false)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, xaxis = :flip, yscale =:log10, 
legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "No. of faces")



##
#mesh_cuboid
#time comparison
Plots.plot()
h = [1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01, 0.005]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, @belapsed meshcuboid(1.0, 1.0, 1.0, t))
    append!(yr, @belapsed mesh_cuboid(1.0, 1.0, 1.0, t))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, xaxis = :flip, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "Time in s")
Plots.xticks!(h, string.(h))
Plots.yticks!([10.0^(i) for i in -6:1])
##
#alloc comparison
Plots.plot()
h = [1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01, 0.005]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, @allocations meshcuboid(1.0, 1.0, 1.0, t))
    append!(yr, @allocations mesh_cuboid(1.0, 1.0, 1.0, t))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, xaxis = :flip, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "No. of Allocs")
Plots.xticks!(h, string.(h))
Plots.yticks!([10.0^(i) for i in 0:3:9])
##
#memory comparison
Plots.plot()
h = [1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01, 0.005]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, @allocated meshcuboid(1.0, 1.0, 1.0, t))
    append!(yr, @allocated mesh_cuboid(1.0, 1.0, 1.0, t))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, xaxis = :flip, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "Memory")
Plots.xticks!(h, string.(h))
Plots.yticks!([10.0^(i) for i in 0:3:9])
##
#faces comparison
Plots.plot()
h = [1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, length(meshcuboid(1.0, 1.0, 1.0, t).faces))
    append!(yr, length(mesh_cuboid(1.0, 1.0, 1.0, t).faces))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, xaxis = :flip, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "No. of faces")
Plots.xticks!(h, string.(h))


##
#mesh_sphere
#time comparison
Plots.plot()
radius = 1.0
l = [1.0, 0.8, 0.6, 0.4, 0.2, 0.1, 0.08, 0.06, 0.04, 0.02] 
s1 = []
s2 = []
s3 = []
for (i, len) in enumerate(l)
    h = len
    append!(s1, @belapsed mesh_sphere(radius, h, delaunay =:(2D)));
    append!(s2, @belapsed mesh_sphere(radius, h, delaunay =:(3D)));
    append!(s3, @belapsed meshsphere(radius, h));
end
p = Plots.plot(l, s3, label = "CompScienceMeshes", marker = true)
Plots.plot!(l, s1, label = "Delaunay 2D", marker = true)
Plots.plot!(l, s2, label = "Delaunay 3D", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "Time in s")
Plots.xticks!(l, string.(l))
Plots.yticks!([10.0^(i) for i in -6:1])
Plots.plot!(xaxis =:flip)
##
#alloc comparison
Plots.plot()
radius = 1.0
l = [1.0, 0.8, 0.6, 0.4, 0.2, 0.1, 0.08, 0.06, 0.04] 
s1 = []
s2 = []
s3 = []
for (i, len) in enumerate(l)
    h = len
    append!(s1, @allocations mesh_sphere(radius, h, delaunay =:(2D)));
    append!(s2, @allocations mesh_sphere(radius, h, delaunay =:(3D)));
    append!(s3, @allocations meshsphere(radius, h));  
end
p = Plots.plot(l, s3, label = "CompScienceMeshes", marker = true)
Plots.plot!(l, s1, label = "Delaunay 2D", marker = true)
Plots.plot!(l, s2, label = "Delaunay 3D", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "No. of Allocs")
Plots.xticks!(l, string.(l))
#Plots.yticks!([10.0^(i) for i in -6:1])
Plots.plot!(xaxis =:flip)
##
#memory comparison
Plots.plot()
radius = 1.0
l = [1.0, 0.8, 0.6, 0.4, 0.2, 0.1, 0.08, 0.06, 0.04] 
s1 = []
s2 = []
s3 = []
for (i, len) in enumerate(l)
    h = len
    append!(s1, @allocated mesh_sphere(radius, h, delaunay =:(2D)));
    append!(s2, @allocated mesh_sphere(radius, h, delaunay =:(3D)));
    append!(s3, @allocated meshsphere(radius, h));  
end
p = Plots.plot(l, s3, label = "CompScienceMeshes", marker = true)
Plots.plot!(l, s1, label = "Delaunay 2D", marker = true)
Plots.plot!(l, s2, label = "Delaunay 3D", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "Memory")
Plots.xticks!(l, string.(l))
#Plots.yticks!([10.0^(i) for i in -6:1])
Plots.plot!(xaxis =:flip)
##
#faces comparison
Plots.plot()
radius = 1.0
l = [1.0, 0.8, 0.6, 0.4, 0.2, 0.1, 0.08, 0.06, 0.04] 
s1 = []
s2 = []
s3 = []
for (i, len) in enumerate(l)
    h = len
    append!(s1, length(mesh_sphere(radius, h, delaunay =:(2D)).faces));
    append!(s2, length(mesh_sphere(radius, h, delaunay =:(3D)).faces));
    append!(s3, length(meshsphere(radius, h).faces));  
end
p = Plots.plot(l, s3, label = "CompScienceMeshes", marker = true)
Plots.plot!(l, s1, label = "Delaunay 2D", marker = true, markersize = 6)
Plots.plot!(l, s2, label = "Delaunay 3D", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "No. of faces")
Plots.xticks!(l, string.(l))
Plots.plot!(xaxis =:flip)




##
#mesh_icosphere
#marker for time
t = 0
a = []
x = [i for i in 0:100:600]
x[1] = 1
for i in x
    t = i
    append!(a, @belapsed icosphere(t))
end
Plots.plot()
p = Plots.plot(x, a, marker = true)
Plots.plot!(xscale=:linear, yscale =:linear, 
minorticks = false, legend = false, 
guidefontsize = 15, xguide = "No. of divisions", yguide = "Time in s")
Plots.xticks!(x, string.(x))
##
#marker for allocs
t = 0
a = []
x = [i for i in 0:100:600]
x[1] = 1
for i in x
    t = i
    append!(a, @allocations icosphere(t))
end
Plots.plot()
p = Plots.plot(x, a, marker = true)
Plots.plot!(xscale=:linear, yscale =:log, 
minorticks = false, legend = false, 
guidefontsize = 15, xguide = "No. of divisions", yguide = "No. of allocations")
Plots.xticks!(x, string.(x))
##
#memory marker
t = 0
a = []
x = [i for i in 0:100:600]
x[1] = 1
for i in x
    t = i
    append!(a, @allocated icosphere(t))
end
Plots.plot()
p = Plots.plot(x, a, marker = true)
Plots.plot!(xscale=:linear, yscale =:log, 
minorticks = false, legend = false, 
guidefontsize = 15, xguide = "No. of divisions", yguide = "Memory")
Plots.xticks!(x, string.(x))
##
#no. of faces
t = 0
a = []
x = [i for i in 0:10:50]
x[1] = 1
for i in x
    t = i
    append!(a, length(icosphere(t).faces))
end
Plots.plot()
p = Plots.plot(x, a, marker = true)
Plots.plot!(xscale=:linear, yscale =:linear, 
minorticks = false, legend = false, 
guidefontsize = 15, xguide = "No. of divisions", yguide = "No. of faces")
Plots.xticks!(x, string.(x))

##
#time comparison
Plots.plot()
h = [1.0, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, @belapsed tetmeshcuboid(1.0, 1.0, 1.0, t))
    append!(yr, @belapsed tetmesh_cuboid(1.0, 1.0, 1.0, t))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, xaxis = :flip, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "Time in s")
Plots.xticks!(h, string.(h))
Plots.yticks!([10.0^(i) for i in -6:1])
##  
#alloc comparison
Plots.plot()
h = [1.0, 0.5, 0.2, 0.1, 0.05, 0.02]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, @allocations tetmeshcuboid(1.0, 1.0, 1.0, t))
    append!(yr, @allocations tetmesh_cuboid(1.0, 1.0, 1.0, t))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, xaxis = :flip, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "No. of Allocs")
Plots.xticks!(h, string.(h))
##
#memory comparison
Plots.plot()
h = [1.0, 0.5, 0.2, 0.1, 0.05, 0.02]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, @allocated tetmeshcuboid(1.0, 1.0, 1.0, t))
    append!(yr, @allocated tetmesh_cuboid(1.0, 1.0, 1.0, t))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, xaxis = :flip, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "Memory")
Plots.xticks!(h, string.(h))
##  
#faces comparison
Plots.plot()
h = [1.0, 0.5, 0.2, 0.1, 0.05, 0.02]
t = 0
yc = []
yr = []
for i in 1:length(h)
    t = h[i]
    append!(yc, length(tetmeshcuboid(1.0, 1.0, 1.0, t).faces))
    append!(yr, length(tetmesh_cuboid(1.0, 1.0, 1.0, t).faces))
end
p = Plots.plot(h, yc, label = "CompScienceMeshes", marker = true)
Plots.plot!(h, yr, label = "This work", marker = true)
Plots.plot!(xscale=:log10, yscale =:log10, xaxis = :flip, 
minorticks = false, legend_font = 10, legend_position = :topleft, 
guidefontsize = 15, xguide = "Edge length", yguide = "No. of faces")
Plots.xticks!(h, string.(h))
##