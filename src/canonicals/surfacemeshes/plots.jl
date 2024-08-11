using CompScienceMeshes
using Plotly

rect = mesh_rectangle(1.0, 1.0, 0.1)

plot(wireframe(rect), Layout(title = "Regular mesh of a rectangle"))

M = Matrix{Float64}(undef, 3, 3)
M[3, :] = rect.vertices[rect.faces[1]][3]

l = length(rect.faces)
x = []
y = []
function plt(j)
    #for j in 1:40
        for i in 1:3
            M[i, :] = rect.vertices[rect.faces[j]][i]
            append!(x, M[i, 1])
            append!(y, M[i, 2])
            
        end
        append!(x, M[1, 1])
        append!(y, M[1, 2])
        append!(x, NaN)
        append!(y, NaN)
        
        return x, y
    #end
end
M
x
y

n = 40
anim = @animate for i = 1:l
    Plots.plot(plt(i))
end
gif(anim,"test_anim_fps15.gif", fps = 2)