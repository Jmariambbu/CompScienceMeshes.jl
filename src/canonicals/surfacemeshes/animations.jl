using Plots
using PythonPlot
##
#rectangle
rec = mesh_rectangle(1.0, 1.0, 0.2)

M = Matrix{Float64}(undef, 3, 3)
#M[3, :] = rec.vertices[rec.faces[1]][3]

l = length(rec.faces)

function plt1(j)
    #for j in 1:40
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
        #push!(lt, [x, y])
        #@show lt
        for i in 1: (length(x1) - 1)
            xp = [x1[i], x1[i + 1]]
            yp = [y1[i], y1[i + 1]]
            Plots.plot!(xp, yp, color =:red)
        end
end

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

    #end
end

Plots.plot()

function rectangle()
    x = [0, 1, 1, 0, 0]
    y = [0, 0, 1, 1, 0]

    return x, y
end

Plots.plot(rectangle(), color =:black)

anim = @animate for i = 1:l
    if (i%2) == 0
        plt2(i)
    else
        plt1(i)
    end
    Plots.plot!(xlims = [-0.05, 1.05], ylims = [-0.05, 1.05], legend = false)
    xlabel!("x")
    ylabel!("y")
    title!("Meshing of a rectangle")
end
gif(anim, "animation_meshrectangle.gif", fps = 4)

##
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
        Plots.plot3d!(x2, y2, z2, color =:red3)


    #end
end

Plots.plot3d()

function cuboid()
    x = [0, 1, 1, 0, 0, 0, 1, 1, 0, 0, NaN, 0, 0, NaN, 1, 1, NaN, 1, 1, NaN]
    y = [0, 0, 1, 1, 0, 0, 0, 1, 1, 0, NaN, 1, 1, NaN, 1, 1, NaN, 0, 0, NaN]
    z = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, NaN, 0, 1, NaN, 0, 1, NaN, 0, 1, NaN]
    return x, y, z
end

Plots.plot3d(cuboid(), color =:black)
pythonplot()
cam = [(45, 45), (45, 10), (45, 10), (75, 45), (160, 10), (-75, 10)]

anim = @animate for i = 0:(l - 1)
    
    plt2(i + 1)
    if (i%8) == 0
        plot3d!(camera = cam[Int(i/8 + 1)])
    end
    Plots.plot3d!(xlims = [-0.05, 1.05], ylims = [-0.05, 1.05], zlim = [-0.05, 1.05], legend = false)
    xlabel!("x")
    ylabel!("y")
    zlabel!("z")
    title!("Meshing of a cuboid")
end
gif(anim, "animation_meshcuboid.gif", fps = 4)

##
#mesh cuboid
pythonplot()
##
cub = mesh_cuboid(1.0, 1.0, 1.0, 0.1)

M = Matrix{Float64}(undef, 3, 3)
plot3d()
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

p = plot3d!(pltcub())
anim = Animation()
for i in range(0, stop = 90, step = 2)
    u = plot3d!(p, camera = (i, i))
    plot3d!(xlims = [-0.05, 1.05], ylims = [-0.05, 1.05], zlim = [-0.05, 1.05], legend = false)
    xlabel!("x")
    ylabel!("y")
    zlabel!("z")
    title!("Meshing of a cuboid")

    frame(anim, u)
end 
gif(anim, "animation_meshcuboid2.gif", fps = 10) 

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
        Plots.plot3d!(x2, y2, z2, color = colour)

end

#cam = [(45, 45), (45, 10), (45, 10), (75, 45), (160, 10), (-75, 10)]

anim = @animate for i = 0:(l - 1)
    
    if i < l/2
        plt2(i + 1, "blue")
        plot3d!(camera = (75, 75))
    else
        plt2(i + 1, "red")
        plot3d!(camera = (75, -75))
    end
    
    Plots.plot3d!(xlims = [-1.05, 1.05], ylims = [-1.05, 1.05], zlim = [-1.05, 1.05], legend = false)
    xlabel!("x")
    ylabel!("y")
    zlabel!("z")
    title!("Meshing of a sphere")
end
gif(anim, "animation_meshsphere.gif", fps = 4)

##


#icosphere
pythonplot()
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

anim = Animation()
for i = 1:5
    plot3d!()
    p = plot3d(plt(i), color =:black)
    Plots.plot3d!(camera = (15, 15))
    
    Plots.plot3d!(xlims = [-1.05, 1.05], ylims = [-1.05, 1.05], zlim = [-1.05, 1.05], legend = false)
    xlabel!("x")
    ylabel!("y")
    zlabel!("z")
    title!("Meshing of an icosphere")
    frame(anim, p)
end 
gif(anim, "animation_meshicosphere.gif", fps = 1) 

plot3d()
anim2 = Animation()
for (j, i) in enumerate([1, 2, 4])
    palette = [:red, :green, :blue]
    p = plot3d!(plt(i), color = palette[j])
    Plots.plot3d!(camera = (90, 90))
    
    Plots.plot3d!(xlims = [-1.0, 1.0], ylims = [-1.0, 1.0], zlim = [-1.05, 1.05], legend = false)
    xlabel!("x")
    ylabel!("y")
    zlabel!("z")
    title!("Meshing of an icosphere")
    frame(anim2, p)
end 
gif(anim2, "animation_meshicosphere2.gif", fps = 0.25) 


##

#tetrahedron
pythonplot()
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

plot3d()

function cuboid()
    x = [0, 1, 1, 0, 0, 0, 1, 1, 0, 0, NaN, 0, 0, NaN, 1, 1, NaN, 1, 1, NaN]
    y = [0, 0, 1, 1, 0, 0, 0, 1, 1, 0, NaN, 1, 1, NaN, 1, 1, NaN, 0, 0, NaN]
    z = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, NaN, 0, 1, NaN, 0, 1, NaN, 0, 1, NaN]
    return x, y, z
end

Plots.plot3d(cuboid(), color =:black)
cam = [(15, 75), (15, 15), (75, 45)]

anim = @animate for i = 1:l    
    verts = plt2(i)
    j = Int(ceil(i/8))
    plot3d!(verts, camera = cam[j], palette =[:purple, :red, :lightgreen, :teal, :darkblue, :yellow, :brown, :darkgreen])
    Plots.plot3d!(xlims = [-0.05, 1.05], ylims = [-0.05, 1.05], zlim = [-0.05, 1.05], legend = false)
    xlabel!("x")
    ylabel!("y")
    zlabel!("z")
    title!("Volumetric Meshing of a cuboid")
end
gif(anim, "animation_tetmeshcuboid.gif", fps = 0.5)


##
pythonplot()
tt = tetmesh_cuboid(1.0, 1.0, 1.0, 0.5)
plot3d()
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

anim = Animation()
for i in range(0, stop = 90, step = 2)  
    verts = plt2()  
    p = plot3d!(verts, camera = (i, i), color =:black)
    Plots.plot3d!(xlims = [-0.05, 1.05], ylims = [-0.05, 1.05], zlim = [-0.05, 1.05], legend = false)
    xlabel!("x")
    ylabel!("y")
    zlabel!("z")
    title!("Volumetric Meshing of a cuboid")
    frame(anim, p)
end
gif(anim, "animation_tetmeshcuboid2.gif", fps = 10)
