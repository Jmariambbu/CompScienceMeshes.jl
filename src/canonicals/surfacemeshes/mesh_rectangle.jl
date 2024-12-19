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
            nodes[n*(m + 1) + iy + 1] = SVector(n*h, (iy*h), F(0))
           
        end
        
    return Mesh(nodes, faces)
end
"""
    meshrectangle(width, height, delta, udim)

Create a mesh for a rectangle of width (along the x-axis) `width` and height (along
    the y-axis) `height`.

The target edge size is `delta` and the dimension of the
    embedding universe is `udim` (>= 2).

The mesh is oriented such that the normal is pointing down. This is subject to change.
"""
function meshrectangle(width::T, height::T, delta::T, udim=3; structured=true) where T
  if !structured
	  @assert udim==3 "Only 3D Unstructured mesh currently supported"
	  return meshrectangle_unstructured(width, height, delta)
  end

  PT = SVector{udim,T}
  CT = SVector{3,Int}

    @assert 2 <= udim

    nx = round(Int, ceil(width/delta));  nx = max(nx,1); dx = width/nx
    ny = round(Int, ceil(height/delta)); ny = max(ny,1); dy = height/ny

    xs = (0:nx) * dx
    ys = (0:ny) * dy

    vertices = zeros(PT, (nx+1)*(ny+1))
    k = 1
    for x in xs
        for y in ys
            p = zeros(T, udim)
            p[1] = x
            p[2] = y
            vertices[k] = PT(p)
            k += 1
        end
    end

    faces = zeros(CT, 2*nx*ny)
    k = 1
    for i in 1 : nx
        for j in 1 : ny
            v11 = (i-1)*(ny+1) + j
            v12 = i*(ny+1) + j
            v21 = (i-1)*(ny+1) + (j+1)
            v22 = i*(ny+1) + (j+1)
            faces[k]   = CT(v11,v21,v12)
            faces[k+1] = CT(v21,v22,v12)
            k += 2
        end
    end

    Mesh(vertices, faces)
end

"""
    meshrectangle_unstructured(width, height, delta)
	Meshes unstructured rectangle (Delaunay Triangulation)
"""
function meshrectangle_unstructured(width, height, delta; tempname=tempname())
    s =
		"""
		lc = $delta;

		Point(1)={0,0,0,lc};
		Point(4)={$width,0,0,lc};
		Point(5)={0,$height,0,lc};
		Point(8)={$width,$height,0,lc};

		Line(4)={4,1};
		Line(8)={8,5};
		Line(9)={1,5};
		Line(12)={4,8};

		Line Loop(5)={4,-12,-8,9};

		Plane Surface(5)={5};
		"""

    fn = tempname
    io = open(fn, "w")
    try
        print(io, s)
    finally
        close(io)
    end

    # feed the file to gmsh
    fno = tempname * ".msh"

    gmsh.initialize()
    gmsh.option.setNumber("Mesh.MshFileVersion",2)
    gmsh.open(fn)
    gmsh.model.mesh.generate(2)
    gmsh.write(fno)
    gmsh.finalize()

    m = read_gmsh_mesh(fno)

    rm(fno)
    rm(fn)

    return m

end