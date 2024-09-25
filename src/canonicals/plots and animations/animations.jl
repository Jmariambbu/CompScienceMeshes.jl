using Plots

##
#rectangle
rec = mesh_rectangle(1.0, 1.0, 0.2)
M = Matrix{Float64}(undef, 3, 3)
l = length(rec.faces)
#odd faces
function plt1(j)
    x1 = []
    y1 = []
        for i in 1:3
            M[i, :] = rec.vertices[rec.faces[j]][i]
            append!(x1, M[i, 1])
            append!(y1, M[i, 2]) 
        end
        append!(x1, M[1, 1])
        append!(y1, M[1, 2])
        append!(x1, NaN)
        append!(y1, NaN)
        for i in 1: (length(x1) - 1)
            xp = [x1[i], x1[i + 1]]
            yp = [y1[i], y1[i + 1]]
            Plots.plot!(xp, yp, color =:red)
        end
end
#even faces
function plt2(j)
    x2 = []
    y2 = []
        for i in 1:3
            M[i, :] = rec.vertices[rec.faces[j]][i]
            append!(x2, M[i, 1])
            append!(y2, M[i, 2])  
        end
        append!(x2, M[1, 1])
        append!(y2, M[1, 2])
        append!(x2, NaN)
        append!(y2, NaN)
        for i in 1: (length(x2) - 1)
            xp = [x2[i], x2[i + 1]]
            yp = [y2[i], y2[i + 1]]
            Plots.plot!(xp, yp, color =:blue)
        end
end
Plots.plot()
#preferably using gr backend
#bounding box
function rectangle()
    x = [0, 1, 1, 0, 0]
    y = [0, 0, 1, 1, 0]
    return x, y
end
Plots.plot(rectangle(), color =:black)
#animation
anim = @animate for i = 1:l
    if (i%2) == 0
        plt2(i)
    else
        plt1(i)
    end
    Plots.plot!(legend = false, axis = false)
    Plots.title!("Meshing of a rectangle")
end
Plots.gif(anim, "animation_meshrectangle.gif", fps = 4)
##

#animation #1
#cuboid
cub = mesh_cuboid(1.0, 1.0, 1.0, 0.5)
M = Matrix{Float64}(undef, 3, 3)
M[3, :] = cub.vertices[cub.faces[1]][3]
l = length(cub.faces)
function plt2(j)
    x2 = []
    y2 = []
    z2 = []
        for i in 1:3
            M[i, :] = cub.vertices[cub.faces[j]][i]
            append!(x2, M[i, 1])
            append!(y2, M[i, 2])
            append!(z2, M[i, 3])
        end
        append!(x2, M[1, 1])
        append!(y2, M[1, 2])
        append!(z2, M[1, 3])
        append!(x2, NaN)
        append!(y2, NaN)
        append!(z2, NaN)
        Plots.plot3d!(x2, y2, z2, color =:red3, xlim = [0, 1], ylim = [0, 1], zlim = [0, 1])
end
Plots.plot3d()
#bounding box
function cuboid()
    x = [0, 1, 1, 0, 0, 0, 1, 1, 0, 0, NaN, 0, 0, NaN, 1, 1, NaN, 1, 1, NaN]
    y = [0, 0, 1, 1, 0, 0, 0, 1, 1, 0, NaN, 1, 1, NaN, 1, 1, NaN, 0, 0, NaN]
    z = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, NaN, 0, 1, NaN, 0, 1, NaN, 0, 1, NaN]
    return x, y, z
end
Plots.plot3d(cuboid(), color =:black)
cam = [(45, 45), (45, 10), (45, 10), (75, 45), (160, 10), (-75, 10)]
anim = @animate for i = 0:(l - 1)
    plt2(i + 1)
    if (i%8) == 0
        Plots.plot3d!(camera = cam[Int(i/8 + 1)])
    end
    Plots.plot3d!(legend = false, grid = true, axis = [])
    Plots.title!("Meshing of a cuboid")
end
Plots.gif(anim, "animation_meshcuboid.gif", fps = 4)
##
#animation 2
#mesh cuboid
cub = mesh_cuboid(1.0, 1.0, 1.0, 0.1)
M = Matrix{Float64}(undef, 3, 3)
Plots.plot3d()
x2 = []
y2 = []
z2 = []
function pltcub()
    for j in 1:length(cub.faces)
        for i in 1:3
            M[i, :] = cub.vertices[cub.faces[j]][i]
            append!(x2, M[i, 1])
            append!(y2, M[i, 2])
            append!(z2, M[i, 3])
        end
        append!(x2, M[1, 1])
        append!(y2, M[1, 2])
        append!(z2, M[1, 3])
        append!(x2, NaN)
        append!(y2, NaN)
        append!(z2, NaN)
    end
    return (x2, y2, z2)
end
p = Plots.plot3d!(pltcub())
anim = Animation()
for i in range(0, stop = 90, step = 2)
    u = Plots.plot3d!(p, camera = (i, i))
    Plots.plot3d!(xlims = [-0.05, 1.05], ylims = [-0.05, 1.05], 
        zlim = [-0.05, 1.05], legend = false, axis = false)
    Plots.title!("Meshing of a cuboid")
    Plots.frame(anim, u)
end 
Plots.gif(anim, "animation_meshcuboid2.gif", fps = 10) 
##

#sphere
ss = mesh_sphere(1.0, 0.8)
Plots.plot3d()
M = Matrix{Float64}(undef, 3, 3)
l = length(ss.faces)
function plt2(j, colour)
    x2 = []
    y2 = []
    z2 = []
        for i in 1:3
            M[i, :] = ss.vertices[ss.faces[j]][i]
            append!(x2, M[i, 1])
            append!(y2, M[i, 2])
            append!(z2, M[i, 3])
        end
        append!(x2, M[1, 1])
        append!(y2, M[1, 2])
        append!(z2, M[1, 3])
        append!(x2, NaN)
        append!(y2, NaN)
        append!(z2, NaN)
        Plots.plot3d!(x2, y2, z2, color = colour, xlim = [-1, 1],
        ylim = [-1, 1], zlim = [-1, 1])
end
#animation
anim = @animate for i = 0:(l - 1)
    if i < l/2
        plt2(i + 1, "blue")
        Plots.plot3d!(camera = (75, 75))
    else
        plt2(i + 1, "red")
        Plots.plot3d!(camera = (75, -75))
    end
    Plots.plot3d!(xlims = [-1.05, 1.05], ylims = [-1.05, 1.05], 
        zlim = [-1.05, 1.05], legend = false, axis = false)
    Plots.title!("Meshing of a sphere")
end
Plots.gif(anim, "animation_meshsphere.gif", fps = 4)
##

#icosphere
Plots.plot3d()
M = Matrix{Float64}(undef, 3, 3)
function plt(i)
    x2 = []
    y2 = []
    z2 = []
    ico = icosphere(i)
    for j in 1:length(ico.faces)
        for i in 1:3
            M[i, :] = ico.vertices[ico.faces[j]][i]
            append!(x2, M[i, 1])
            append!(y2, M[i, 2])
            append!(z2, M[i, 3])
        end
        append!(x2, M[1, 1])
        append!(y2, M[1, 2])
        append!(z2, M[1, 3])
        append!(x2, NaN)
        append!(y2, NaN)
        append!(z2, NaN)
    end
    return x2, y2, z2
end
#animation #1
anim = Animation()
for i = 1:5
    Plots.plot3d!()
    p = plot3d(plt(i), color =:black)
    Plots.plot3d!(camera = (15, 15))
    Plots.plot3d!(xlims = [-1.05, 1.05], ylims = [-1.05, 1.05], 
        zlim = [-1.05, 1.05], legend = false, axis = false)
    Plots.title!("Meshing of an icosphere")
    Plots.frame(anim, p)
end 
Plots.gif(anim, "animation_meshicosphere.gif", fps = 1) 
#animation #2
Plots.plot3d()
anim2 = Animation()
for (j, i) in enumerate([1, 2, 4])
    palette = [:red, :green, :blue]
    p = Plots.plot3d!(plt(i), color = palette[j])
    Plots.plot3d!(camera = (90, 90))
    Plots.plot3d!(xlims = [-1.0, 1.0], ylims = [-1.0, 1.0], 
        zlim = [-1.05, 1.05], legend = false, axis = false)
    Plots.title!("Meshing of an icosphere")
    Plots.frame(anim2, p)
end 
Plots.gif(anim2, "animation_meshicosphere2.gif", fps = 0.25) 

##
#tetrahedron
tt = tetmesh_cuboid(1.0, 1.0, 1.0, 1.0)
M = Matrix{Float64}(undef, 4, 3)
l = length(tt.faces)
tt.faces
function plt2(j)
    x2 = []
    y2 = []
    z2 = []
        for i in 1:4
            M[i, :] = tt.vertices[tt.faces[j]][i]
            append!(x2, M[i, 1])
            append!(y2, M[i, 2])
            append!(z2, M[i, 3])
        end  
        append!(x2, M[1, 1])
        append!(y2, M[1, 2])
        append!(z2, M[1, 3])
        append!(x2, M[3, 1])
        append!(y2, M[3, 2])
        append!(z2, M[3, 3])
        append!(x2, NaN)
        append!(y2, NaN)
        append!(z2, NaN)
        append!(x2, M[4, 1])
        append!(y2, M[4, 2])
        append!(z2, M[4, 3])
        append!(x2, M[2, 1])
        append!(y2, M[2, 2])
        append!(z2, M[2, 3])
        append!(x2, NaN)
        append!(y2, NaN)
        append!(z2, NaN)
    return x2, y2, z2
end
Plots.plot3d()
#bounding box
function cuboid()
    x = [0, 1, 1, 0, 0, 0, 1, 1, 0, 0, NaN, 0, 0, NaN, 1, 1, NaN, 1, 1, NaN]
    y = [0, 0, 1, 1, 0, 0, 0, 1, 1, 0, NaN, 1, 1, NaN, 1, 1, NaN, 0, 0, NaN]
    z = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, NaN, 0, 1, NaN, 0, 1, NaN, 0, 1, NaN]
    return x, y, z
end
Plots.plot3d(cuboid(), color =:black)
#animation #1
cam = [(15, 75), (15, 15), (75, 45)]
anim = @animate for i = 1:l    
    verts = plt2(i)
    j = Int(ceil(i/8))
    Plots.plot3d!(verts, camera = cam[j], 
        palette =[:purple, :red, :lightgreen, :teal, :darkblue, :yellow, :brown, :darkgreen])
    Plots.plot3d!(xlims = [-0.05, 1.05], ylims = [-0.05, 1.05], 
        zlim = [-0.05, 1.05], legend = false, axis = false)
    Plots.title!("Volumetric Meshing of a cuboid")
end
Plots.gif(anim, "animation_tetmeshcuboid.gif", fps = 0.5)

##
tt = tetmesh_cuboid(1.0, 1.0, 1.0, 0.5)
Plots.plot3d()
M = Matrix{Float64}(undef, 4, 3)
l = length(tt.faces)
tt.faces
function plt2()
    x2 = []
    y2 = []
    z2 = []
    for j in 1:length(tt.faces)
        for i in 1:4
            M[i, :] = tt.vertices[tt.faces[j]][i]
            append!(x2, M[i, 1])
            append!(y2, M[i, 2])
            append!(z2, M[i, 3])
        end    
        append!(x2, M[1, 1])
        append!(y2, M[1, 2])
        append!(z2, M[1, 3])
        append!(x2, M[3, 1])
        append!(y2, M[3, 2])
        append!(z2, M[3, 3])
        append!(x2, NaN)
        append!(y2, NaN)
        append!(z2, NaN)
        append!(x2, M[4, 1])
        append!(y2, M[4, 2])
        append!(z2, M[4, 3])
        append!(x2, M[2, 1])
        append!(y2, M[2, 2])
        append!(z2, M[2, 3])
        append!(x2, NaN)
        append!(y2, NaN)
        append!(z2, NaN)
    end
    return x2, y2, z2
end
#animation #2
anim = Animation()
for i in range(0, stop = 90, step = 2)  
    verts = plt2()  
    p = Plots.plot3d!(verts, camera = (i, i), color =:black)
    Plots.plot3d!(xlims = [-0.05, 1.05], ylims = [-0.05, 1.05], 
        zlim = [-0.05, 1.05], legend = false, axis = false)
    Plots.title!("Volumetric Meshing of a cuboid")
    Plots.frame(anim, p)
end
Plots.gif(anim, "animation_tetmeshcuboid2.gif", fps = 10)
##

#Visual comparison with existing CompScienceMeshes

##
using CompScienceMeshes
using Plotly   #to get wireframe
##
#animation interval
anim_interval = union(collect(range(10, 80, step = 10)), 
    collect(range(100, 170, step = 10)), collect(range(190, 260, step = 10)), 
    collect(range(280, 350, step = 10)))
    
##
#1 Rectangle
#assignment
rec1 = mesh_rectangle(1.0, 1.0, 0.1)
x1, y1, z1 = CompScienceMeshes.wireframe(rec1).x, 
CompScienceMeshes.wireframe(rec1).y, CompScienceMeshes.wireframe(rec1).z
rec2 = meshrectangle(1.0, 1.0, 0.1)
x2, y2, z2 = CompScienceMeshes.wireframe(rec2).x, 
CompScienceMeshes.wireframe(rec2).y, CompScienceMeshes.wireframe(rec2).z
#Plots
p1 = Plots.plot3d(x1, y1, z1, color =:black)
Plots.plot3d!(zlim = [-1.0, 1.0], axis = false, legend = false, 
gridalpha = 0.2, title = "Regular mesh of a rectangle", 
title_position =:left)
p2 = Plots.plot3d(x2, y2, z2, color =:black)
Plots.plot3d!(zlim = [-1.0, 1.0], axis = false, legend = false, 
gridalpha = 0.2, title = "'CompScienceMeshes' mesh of a rectangle", 
title_position =:left)
#animation: this work
anim = Plots.Animation()
angle = [i for i in 45:2:90]
angle = vcat(angle, reverse(angle))
for i in angle  
    p = Plots.plot3d!(p1, camera = (i, i))
    Plots.frame(anim, p)
end
Plots.gif(anim, "thisworkrect.gif", fps = 10)
#animation: CompScienceMeshes
anim2 = Plots.Animation()
for i in angle  
    p = Plots.plot3d!(p2, camera = (i, i))
    Plots.frame(anim2, p)
end
Plots.gif(anim2, "CSrect.gif", fps = 10)

##
#2 cuboid
cub1 = mesh_cuboid(1.0, 1.0, 1.0, 0.1)
x1, y1, z1 = CompScienceMeshes.wireframe(cub1).x,
CompScienceMeshes.wireframe(cub1).y, 
CompScienceMeshes.wireframe(cub1).z
cub2 = meshcuboid(1.0, 1.0, 1.0, 0.1)
x2, y2, z2 = CompScienceMeshes.wireframe(cub2).x,
CompScienceMeshes.wireframe(cub2).y, 
CompScienceMeshes.wireframe(cub2).z
#Plots
p1 = Plots.plot3d(x1, y1, z1, color =:black)
Plots.plot3d!(axis = false, legend = false, 
gridalpha = 0.2, title = "Regular mesh of a cuboid", 
title_position =:left)
p2 = Plots.plot3d(x2, y2, z2, color =:black)
Plots.plot3d!(axis = false, legend = false, 
gridalpha = 0.2, title = "'CompScienceMeshes' mesh of a cuboid", 
title_position =:left)
#animation: this work
anim = Plots.Animation()
for i in range(4, stop = 356, step = 4)  
    p = Plots.plot3d!(p1, camera = (i, i), grid = false)
    Plots.frame(anim, p)
end
Plots.gif(anim, "thisworkcub.gif", fps = 5)
#animation: CompScienceMeshes
anim2 = Plots.Animation()
for i in anim_interval   
    p = Plots.plot3d!(p2, camera = (i, i), grid = false)
    Plots.frame(anim2, p)
end
Plots.gif(anim2, "CScub.gif", fps = 5)

##
#3 sphere
s1 = mesh_sphere(1.0, 0.4, delaunay =:(2D))
x1, y1, z1 = CompScienceMeshes.wireframe(s1).x,
CompScienceMeshes.wireframe(s1).y, 
CompScienceMeshes.wireframe(s1).z
s2 = mesh_sphere(1.0, 0.4, delaunay =:(3D))
x2, y2, z2 = CompScienceMeshes.wireframe(s2).x,
CompScienceMeshes.wireframe(s2).y, 
CompScienceMeshes.wireframe(s2).z
s = meshsphere(1.0, 0.4) 
x, y, z = CompScienceMeshes.wireframe(s).x,
CompScienceMeshes.wireframe(s).y, 
CompScienceMeshes.wireframe(s).z
#Plots
p1 = Plots.plot3d(x1, y1, z1, color =:black)
Plots.plot3d!(axis = false, legend = false, 
gridalpha = 0.2, title = "Delaunay 2D mesh of a sphere", 
title_position =:left)
p2 = Plots.plot3d(x2, y2, z2, color =:black)
Plots.plot3d!(axis = false, legend = false, 
gridalpha = 0.2, title = "Delaunay 3D mesh of a sphere", 
title_position =:left)
p3 = Plots.plot3d(x, y, z, color =:black)
Plots.plot3d!(axis = false, legend = false, 
gridalpha = 0.2, title = "'CompScienceMeshes' mesh of a sphere", 
title_position =:left)
#animation: delaunay2d
anim = Plots.Animation()
for i in anim_interval   
    p = Plots.plot3d!(p1, camera = (i, i), grid = false)
    Plots.frame(anim, p)
end
Plots.gif(anim, "thisworksphere2D.gif", fps = 5)
#animation: delaunay3d
anim2 = Plots.Animation()
for i in anim_interval   
    p = Plots.plot3d!(p2, camera = (i, i), grid = false)
    Plots.frame(anim2, p)
end
Plots.gif(anim2, "thisworksphere3D.gif", fps = 5)
#animation: compsciencemeshes
anim3 = Plots.Animation()
for i in anim_interval   
    p = Plots.plot3d!(p3, camera = (i, i), grid = false)
    Plots.frame(anim3, p)
end 
Plots.gif(anim3, "CSsphere.gif", fps = 5)

##
#4 icosphere
ico1 = icosphere(5)
x1, y1, z1 = CompScienceMeshes.wireframe(ico1).x,
CompScienceMeshes.wireframe(ico1).y, 
CompScienceMeshes.wireframe(ico1).z
#Plots
p1 = Plots.plot3d(x1, y1, z1, color =:black)
Plots.plot3d!(axis = false, legend = false, 
gridalpha = 0.2, title = "Icosphere mesh", 
title_position =:left)
#animation: this work
anim = Plots.Animation()
for i in anim_interval   
    p = Plots.plot3d!(p1, camera = (i, i), grid = false)
    Plots.frame(anim, p)
end
Plots.gif(anim, "thisworkico.gif", fps = 10)

##
#5 tetrahedron
tetcub1 = tetmesh_cuboid(1.0, 1.0, 1.0, 0.5)
x1, y1, z1 = CompScienceMeshes.wireframe(tetcub1).x,
CompScienceMeshes.wireframe(tetcub1).y, 
CompScienceMeshes.wireframe(tetcub1).z
tetcub2 = tetmeshcuboid(1.0, 1.0, 1.0, 0.5)
x2, y2, z2 = CompScienceMeshes.wireframe(tetcub2).x,
CompScienceMeshes.wireframe(tetcub2).y, 
CompScienceMeshes.wireframe(tetcub2).z
#Plots
p1 = Plots.plot3d(x1, y1, z1, color =:black)
Plots.plot3d!(axis = false, legend = false, 
gridalpha = 0.2, title = "Regular tetrahedral mesh of a cuboid", 
title_position =:left)
p2 = Plots.plot3d(x2, y2, z2, color =:black)
Plots.plot3d!(axis = false, legend = false, 
gridalpha = 0.2, title = "'CompScienceMeshes' tetrahedral mesh of a cuboid", 
title_position =:left)
#animation: this work
anim = Plots.Animation()
for i in anim_interval  
    p = Plots.plot3d!(p1, camera = (i, i), grid = false)
    Plots.frame(anim, p)
end
Plots.gif(anim, "thisworktetracub.gif", fps = 5)
#animation: CompScienceMeshes
anim2 = Plots.Animation()
for i in anim_interval  
    p = Plots.plot3d!(p2, camera = (i, i), grid = false)
    Plots.frame(anim2, p)
end
Plots.gif(anim2, "CStetracub.gif", fps = 5)