using StaticArrays
using Delaunay
using CompScienceMeshes

# Function to generate a uniform spherical mesh
function mesh_sphere(radius::F, len::F; delaunay =:(2D)) where F 
    if delaunay ==:(3D)
        verts, faces = unitCenteredSphere(len/radius)
    elseif delaunay ==:(2D)
        verts, faces = unitCenteredSphere2(len/radius)
    end

    verts .= radius.*verts
    faces[(size(faces, 1) ÷ 2 + 1):end][2:3] .= 
        faces[(size(faces, 1) ÷ 2 + 1):end][3:-1:2]

    return Mesh(verts, faces)
end

# Function to generate a unit sphere mesh using delaunay 3D function
function unitCenteredSphere(dist::F) where F
    #steps down from the top to list vertices of the hemisphere
    thmax = F(π/2)
    points = []
    #number of triangles the azimuthal/ϕ can accomodate
    nth = Int(floor(thmax / F(dist * sqrt(3) / 2))) + 1
    th_values = collect(LinRange(F(0), thmax, nth))
    upperpts = 0
    for th in th_values
        if th == F(π/2)
            upperpts = size(points, 1)
        end
        r = sin(th)
        #number of triangles the circle at ϕ can accomodate
        nph = Int(floor(2 * π * r / dist)) + 1
        #eps() to avoid error in alignment
        ph = collect(LinRange(2*π/nph, 2*π, nph)) 
            .+ (π / (th + eps(F)))^2 
        for (i, θ) in enumerate(ph)
            x = r * cos(θ)
            y = r * sin(θ)
            #vertices (x, y, z)
            append!(points, [
                [x, 
                y, 
                sign(pi/2-th)*F(sqrt(1-min(x.^2+y.^2,1)))]
                ])
        end       
    end

    # introducing a dummy point
    append!(points, [[F(0), F(0), F(0)]])
    #total number of vertices (x, y, z) in the sphere
    V = length(points) + upperpts 
    sp = reshape(
        [point[i] for i in 1:3 for point in points], 
        (length(points), 3)
        )
    verts = zeros(SVector{3, F}, V - 1)
    #delaunay 3D returns tetrahedrons with the fourth point as the dummy point
    tris = delaunay_triangulation(sp[:, 1:3]).simplices
    #removing the dummy point
    pop!(points)

    #assigning vertices
    for i in eachindex(points)
        verts[i] = [points[i][1], points[i][2], points[i][3]]
        if i <= upperpts
            verts[length(points) + i] = 
            [verts[i][1], verts[i][2], -verts[i][3]]
        end
    end

    #for the bottom hemisphere
    vertreindex = collect(1:V - 1) 
    vertreindex[1:upperpts] = V .- reverse(vertreindex[1:upperpts])
    temp = []
    #to remove the fourth vertex/dummy point from all faces
    for i in 1:size(tris, 1)
        id = findall(x -> x == V - upperpts, tris[i, :])
        if id != []
            append!(temp, [deleteat!(tris[i, :], id[1])])
        end
    end
    for i in 1:length(temp)
        append!(temp, [vertreindex[temp[i]]])
    end
    faces = zeros(SVector{3, Int}, length(temp))
    #faces 
    for i in 1:length(temp)
       faces[i] = SVector{3, Int}(temp[i])
    end
    return verts, faces
end


#Function to generate a unit sphere mesh using delaunay 2D function
function unitCenteredSphere2(dist::F) where F
    #steps down from the top to list vertices of the hemisphere
    thmax = F(π / 2)
    points = []
    nth = Int(floor(thmax / F(dist * sqrt(3) / 2))) + 1
    th_values = collect(LinRange(F(0), thmax, nth))
    upperpts = 0
    for th in th_values
        if th == F(π / 2)
            upperpts = size(points, 1)
        end
        r = sin(th)
        nph = Int(floor(2 * π * r / dist)) + 1
        ph = collect(LinRange(2*π/nph, 2*π, nph)) 
            .+ (π / (th + eps(F)))^2
        for (i, θ) in enumerate(ph)
            x = th * cos(θ)
            y = th * sin(θ)
            #(x, y) coordinates of the vertices
            append!(points, [[x, y]])
        end       
    end
    #total number of vertices (x, y, z)
    V = length(points) + upperpts 
    sp = reshape(
        [point[i] for i in 1:2 for point in points], 
        (length(points), 2)
        )
    verts = zeros(SVector{3, F}, V)
    #finds the norm of the coordinates
    t = leonorm(points)
    mfact = sinc.(t)
    #delaunay 2D returns triangles
    tris = delaunay_triangulation(sp[:, 1:2]).simplices
    #vertices (x, y, z)
    for i in eachindex(points)
        verts[i] = [
            points[i][1]*mfact[i], 
            points[i][2]*mfact[i], 
            cos(t[i])
            ]
        if i <= upperpts
            verts[length(points) + i] = [
                verts[i][1], verts[i][2], -verts[i][3]
                ]
        end
    end
    #to find the vertices on the bottom hemisphere
    vertreindex = collect(1:V)
    vertreindex[1:upperpts] = V + 1 .- reverse(
        vertreindex[1:upperpts]
        )
    tris = vcat(tris, vertreindex[tris])
    #faces
    faces = zeros(SVector{3, Int}, size(tris, 1))
    for i in 1:size(tris, 1)
        faces[i] = SVector{3, Int}(tris[i, 1:3])
    end
    return verts, faces
end

#Function to compute norm - used by unitCenteredSphere2
function leonorm(inmat)
    outmat = zeros(length(inmat))
    #a column vector of summed squares of (x,y)
    for i in 1:length(inmat)
        #x^2 + y^2 along each row
        outmat[i] = inmat[i][1]*conj(inmat[i][1]) + inmat[i][2]*conj(inmat[i][2])
    end
    return sqrt.(outmat)
end

# Function to compute sin(x)/x - used by unitCenteredSphere2
function sinc(x::F) where F
    if x == F(0)
        result = F(1)
    else
        result = sin.(x) ./ x
    end
    return result
end


# Function to perform Delaunay triangulation using Delaunay package
function delaunay_triangulation(points)
    triangulation = delaunay(points)
    return triangulation  
end
