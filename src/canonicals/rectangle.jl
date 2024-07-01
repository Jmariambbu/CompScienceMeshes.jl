using CompScienceMeshes
using StaticArrays

"""
    mesh_rectangle(a::Float64, b::Float64, h::Float64)

    The mesh function is pre-allocated with its vectors of nodes and faces. It is a 
    structured mesh.
Allocations for Nodes
    (m+1) nodes along b
    (n+1) nodes along a
    = (m+1)*(n+1) total nodes

Allocations for faces
    m elements along b 
    n elements along a 
    = 2*m*n total faces -> 2 triangles in each rectangular face

    The faces along y-axis can be obtained by (2*element number) and 
    (2*element number - 1), this is repeated for each element in x-axis
"""
function mesh_rectangle(a::F, b::F, h::F) where F
    
    #structured mesh:  isapprox(a%h, F(0)) && isapprox(b%h, F(0))
        n = Int(round(a/h))  # number of elements along a
       
        m = Int(round(b/h))  # number of elements along b
        
        nodes = zeros(SVector{3, F}, (m + 1)*(n + 1))
        faces = Vector{SVector{3, Int64}}(undef, 2*m*n)
        
        for ix in range(0, n - 1)
            for iy in range(1, m)
                node = SVector((ix)*h, (iy - 1)*h, F(0))
                
                nodes[(ix)*(m + 1) + iy] = node
                face = SVector(
                    (ix)*(m + 1) + (iy),
                    (ix)*(m + 1) + (iy + 1),
                    (ix + 1)*(m + 1) + (iy)
                )
                faces[(ix)*2*m + (2*iy - 1)] = face
               
                face = SVector(
                    (ix)*(m + 1) + (iy + 1), 
                    (ix + 1)*(m + 1) + (iy + 1), 
                    (ix + 1)*(m + 1) + (iy)
                    )
                faces[(ix)*2*m + (2*iy)] = face
            end
            # for the mth element in y-direction
            nodes[(ix + 1)*(m + 1)] = SVector((ix)*h, m*h, F(0))
           
        end
        # for ix = n
        for iy in range(0, m)
            nodes[n*(m + 1) + iy + 1] = SVector(n*h, (iy*h), Float64(0))
           
        end
        
    return Mesh(nodes, faces)
end
