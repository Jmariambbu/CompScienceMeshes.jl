using StaticArrays
using Delaunay
using Plotly
using CompScienceMeshes

# Function to generate a uniform spherical mesh
function UniformSphereMesher(radius::Float64, len::Float64)
    verts, faces = unitCenteredSphere2(len / radius)
    verts .= radius.*verts
    faces[(size(faces, 1) ÷ 2 + 1):end][2:3] .= faces[(size(faces, 1) ÷ 2 + 1):end][3:-1:2] 
    return Mesh(verts, faces)
end

# Function to generate a unit sphere mesh
function unitCenteredSphere2(dist::Float64)
    thmax = π/2
    points = []
    nth = Int(floor(thmax / (dist * sqrt(3) / 2))) + 1
    th_values = collect(LinRange(0, thmax, nth))
    upperpts = 0
    for th in th_values
        if th == π/2
            upperpts = size(points, 1)
        end
        r = sin(th)
        nph = Int(floor(2 * π * r / dist)) + 1
        ph = collect(LinRange(2*π/nph, 2*π, nph)) .+ (π / (th + eps()))^2
        for (i, θ) in enumerate(ph)
            x = r * cos(θ)
            y = r * sin(θ)
            append!(points, [[x, y, sign(pi/2-th)*sqrt(1-min(x.^2+y.^2,1))]])
        end       
    end
    # introducing a dummy point 
    append!(points, [[0.0, 0.0, 0.0]])
    unique!(points)
    #number of vertices (x, y, z)
    V = length(points) + upperpts 
    sp = reshape([point[i] for i in 1:3 for point in points], (length(points), 3))
    verts = zeros(SVector{3, Float64}, V - 1)
    tris = delaunay_triangulation(sp[:, 1:3]).simplices
    #removing the dummy point
    pop!(points)
    for i in eachindex(points)
        verts[i] = [points[i][1], points[i][2], points[i][3]]
        if i <= upperpts
            verts[length(points) + i] = [verts[i][1], verts[i][2], -verts[i][3]]
        end
    end
    vertreindex = collect(1:V - 1)
    vertreindex[1:upperpts] = V .- reverse(vertreindex[1:upperpts])
    temp = []
    for i in 1:size(tris, 1)
        id = findall(x -> x == V - upperpts, tris[i, :])
        append!(temp, [deleteat!(tris[i, :], id[1])])
    end
    for i in 1:length(temp)
        append!(temp, [vertreindex[temp[i]]])
    end
    faces = zeros(SVector{3, Int}, length(temp))
    for i in 1:length(temp)
       faces[i] = SVector{3, Int}(temp[i])
    end
    return verts, faces
end

# Function to perform Delaunay triangulation using Delaunay package
function delaunay_triangulation(points)
    triangulation = delaunay(points)
    return triangulation  
end
