using CompScienceMeshes
using StaticArrays

function mesh_rectangle(a::Float64, b::Float64, h::Float64) 
    # if  isapprox(a%h, F(0)) && isapprox(b%h, F(0))
    n = Int(a/h)  # number of elements along a
    #@show n
    m = Int(b/h)  # number of elements along b
    #@show m

    #empty arrays of SVectors
    nodes = Vector{SVector{3, Float64}}()
    faces = Vector{SVector{3, Int64}}()
    #@show nodes, faces
    for ix in range(1, n)
        for iy in range(1, m)
            node = SVector((ix - 1)*h, (iy - 1)*h, Float64(0))
            #@show node
            @assert typeof(node) == SVector{3, Float64}
            #@show node
            push!(nodes, node)
            face = SVector((ix - 1)*(m + 1) + (iy), (ix - 1)*(m + 1) + (iy + 1), (ix)*(m + 1) + (iy))
            push!(faces, face)
            face = SVector((ix - 1)*(m + 1) + (iy + 1), (ix)*(m + 1) + (iy + 1), (ix)*(m + 1) + (iy))
            push!(faces, face)
        end
        # for iy = m
        push!(nodes, SVector((ix - 1)*h, m*h, Float64(0)))
    end
    # for ix = n
    for iy in range(0, m)
        push!(nodes, SVector(n*h, (iy*h), Float64(0)))
    end

    #@show faces
    #@show nodes
    #end
    return Mesh(nodes, faces)
end

"""
    mesher2(a::Float64, b::Float64, h::Float64)

The mesher function but with memories of Nodes and Faces Vectors pre-allocated.

"""
function mesher2(a::Float64, b::Float64, h::Float64) 
    

    # if  isapprox(a%h, F(0)) && isapprox(b%h, F(0))
        n = Int(round(a/h))  # number of elements along a
        #@show n
        m = Int(round(b/h))  # number of elements along b

        #@show m
        #empty arrays of SVectors
        
        #=if exactly divisible
        
            allocations for Nodes
                (m+1) nodes along b
                (n+1) nodes along a
                (m+1)*(n+1) total nodes

                The nodes

            allocations for faces
                m elements along b 
                n elements along a 
                2*m*n total faces -> 2 triangles in each rectangular face

                The faces along y-axis can be obtained by (2*element number) and (2*element number - 1)
                this is repeated for each element in x-axis
        =#
        nodes = Vector{SVector{3, Float64}}(undef, (m + 1)*(n + 1))
        faces = Vector{SVector{3, Int64}}(undef, 2*m*n)
        #@show nodes
        #@show nodes, faces
        for ix in range(1, n)
            for iy in range(1, m)
                node = SVector((ix - 1)*h, (iy - 1)*h, Float64(0))
                #@show node
                @assert typeof(node) == SVector{3, Float64}
               # @show node
                nodes[(ix - 1)*(m + 1) + iy] = node
                #push!(nodes, node)
                face = SVector((ix - 1)*(m + 1) + (iy), (ix - 1)*(m + 1) + (iy + 1), (ix)*(m + 1) + (iy))
                faces[(ix - 1)*2*m + (2*iy - 1)] = face
                #@show face
                #push!(faces, face)
                face = SVector((ix - 1)*(m + 1) + (iy + 1), (ix)*(m + 1) + (iy + 1), (ix)*(m + 1) + (iy))
                faces[(ix - 1)*2*m + (2*iy)] = face
               # @show face
                #push!(faces, face)
            end
            # for the mth element in y-direction
           # @show faces
            nodes[ix*(m + 1)] = SVector((ix - 1)*h, m*h, Float64(0))
           # @show SVector((ix - 1)*h, m*h, Float64(0))
            #push!(nodes, SVector((ix - 1)*h, m*h, Float64(0)))
        end
        # for ix = n
        for iy in range(0, m)
            nodes[n*(m + 1) + iy + 1] = SVector(n*h, (iy*h), Float64(0))
           # @show SVector(n*h, (iy*h), Float64(0))
            #push!(nodes, SVector(n*h, (iy*h), Float64(0)))
        end
        
    #end
    return Mesh(nodes, faces)
end
