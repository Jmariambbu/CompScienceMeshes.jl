using CompScienceMeshes
using StaticArrays
using Plotly

#code for meshing a cuboid regularly

"""
    mesh_cuboid(a::Float64, b::Float64, c::Float64, h::Float64)

    Number of faces = 2*(2*m*n) + 2*(2*n*p) + 2*(2*m*p) -> front, back; top, bottom; left, right
    where m is the number of elements along y, n along x, p along z

    The odd faces are the triangles right-angled at bottom,
      /|
     /_|      or laterally-inverted

     the even at top
      _      
     | /    
     |/        or laterally-inverted

    Number of vertices is 2*(n + 1)*(m + 1) + 2*(m + 1)*(p - 1) + 2*(n - 1)*(p - 1)
    to avoid repeating the number of nodes along the edges of the cuboid; all nodes along front and back are stacked, 
    then the nodes along the left and right, skipping the nodes along the left-front, left-back, right-front and right-back
    then the nodes along the top and bottom, skipping the nodes along the top-front, -back, -left, -right, and bottom-front, -back, -left, -right.
    
    Since, it is a hollow cuboid,
    the nodes are numbered all along the face of the front and back, first, and then, along the x-y edges in z - direction, like so

                                 20----- 23----- 26
                                 |       |       |
                                 19      22      25
    back =>                      |       |       |
                                 18----- 21----- 24


                                 12----- 14----- 17
    middle                       |               |
    layers =>                    11      .       16
                                 |               |
                                 10----- 13----- 15


                                 3 ----- 6 ----- 9
                                 |       |       |
                                 2       5       8
    front =>                     |       |       |
                                 1 ----- 4 ----- 7

    """
function mesh_cuboid(a::Float64, b::Float64, c::Float64, h::Float64) 

    # if  isapprox(a%h, F(0)) && isapprox(b%h, F(0))
        n = Int(a/h)  # number of elements along a
        #@show n
        m = Int(b/h)  # number of elements along b
        #@show m
        p = Int(c/h)  #number of elements along c
        #@show p
        

        nodes = Vector{SVector{3, Float64}}(undef, 2*(m*n + m*p + n*p + 1))
        faces = Vector{SVector{3, Int64}}(undef, 4*m*n + 4*n*p + 4*m*p)
        @show length(nodes)


        #along x-y
    
        for ix in range(1, n)
            for iy in range(1, m)

                #nodes
                #front
                node = SVector((ix - 1)*h, (iy - 1)*h, Float64(0))
                #@show node
                @assert typeof(node) == SVector{3, Float64}
                #@show node
                nodes[(ix - 1)*(m + 1) + iy] = node
                #back
                node = SVector((ix - 1)*h, (iy - 1)*h, p*h)
                #@show node
                nodes[(m + 1)*(n + 1) + 2*(p - 1)*(m + n) + (ix - 1)*(m + 1) + iy] = node
            
                #faces
                #front 

                face = SVector((ix - 1)*(m + 1) + (iy), (ix)*(m + 1) + (iy), (ix - 1)*(m + 1) + (iy + 1))
                faces[(ix - 1)*2*m + (2*iy - 1)] = face

                #@show face
                #push!(faces, face)
                face = SVector((ix - 1)*(m + 1) + (iy + 1), (ix)*(m + 1) + (iy), (ix)*(m + 1) + (iy + 1))
                faces[(ix - 1)*2*m + (2*iy)] = face
                #@show face

                #back
                face = SVector((m + 1)*(n + 1) + 2*(p - 1)*(m + n) + (ix - 1)*(m + 1) + (iy), (m + 1)*(n + 1) + 2*(p - 1)*(m + n) + (ix - 1)*(m + 1) + (iy + 1), (m + 1)*(n + 1) + 2*(p - 1)*(m + n) + (ix)*(m + 1) + (iy))
                faces[2*m*p + 2*n*p + 2*m*n + (ix - 1)*2*m + (2*iy - 1)] = face
                #@show face

                face = SVector((m + 1)*(n + 1) + 2*(p - 1)*(m + n) + (ix - 1)*(m + 1) + (iy + 1), (m + 1)*(n + 1) + 2*(p - 1)*(m + n) + (ix)*(m + 1) + (iy + 1), (m + 1)*(n + 1) + 2*(p - 1)*(m + n) + (ix)*(m + 1) + (iy))
                faces[2*m*p + 2*n*p + 2*m*n + (ix - 1)*2*m + (2*iy)] = face
                #@show face
                
            end

            # for the mth element in y-direction
            # @show faces
            #front
            nodes[ix*(m + 1)] = SVector((ix - 1)*h, m*h,  Float64(0))
            #@show SVector((ix - 1)*h, m*h,  Float64(0))
            #back
            nodes[(m + 1)*(n + 1) + 2*(p - 1)*(m + n) + ix*(m + 1)] = SVector((ix - 1)*h, m*h, p*h)
            #@show SVector((ix - 1)*h, m*h, p*h)
            #push!(nodes, SVector((ix - 1)*h, m*h, Float64(0)))
        end

        # for ix = n
        for iy in range(0, m)
            #front
            nodes[n*(m + 1) + iy + 1] = SVector(n*h, (iy*h),  Float64(0))
            #back
            nodes[(m + 1)*(n + 1) + 2*(p - 1)*(m + n) + n*(m + 1) + iy + 1] = SVector(n*h, (iy*h), p*h)
            
            #push!(nodes, SVector(n*h, (iy*h), Float64(0)))
        end
        

        # along y - z


        #@show nodes
        #@show faces
        for iy in range(1, m + 1)
            for iz in range(2, p)
                #ix in 1 -> left nodes
                node = SVector(Float64(0), (iy - 1)*h, (iz - 1)*h)
                nodes[(n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + iy] = node
                #@show node
                #@show node
                if iz == 2 && iy != (m + 1)
                    #left faces
                    face = SVector(iy, iy + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + iy)
                    faces[4*m*n + 4*n*p + 2*m*p + (iz - 2)*2*m + (2*iy - 1)] = face
                    face = SVector(iy + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + iy + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + iy)
                    faces[4*m*n + 4*n*p + 2*m*p + (iz - 2)*2*m + (2*iy)] = face
                    #right faces
                    face = SVector(n*(m + 1) + iy, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2*n - 1 + iy, n*(m + 1) + iy + 1)
                    faces[2*m*n + 2*n*p + (iz - 2)*2*m + (2*iy - 1)] = face
                    face = SVector(n*(m + 1) + iy + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2*n - 1 + iy, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2*n - 1 + iy + 1)
                    faces[2*m*n + 2*n*p + (iz - 2)*2*m + (2*iy)] = face
                elseif iy != (m + 1)
                    #left faces
                    face = SVector((n + 1)*(m + 1) + (iz - 3)*(2*(m + n)) + iy, (n + 1)*(m + 1) + (iz - 3)*(2*(m + n)) + iy + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + iy)
                    faces[4*m*n + 4*n*p + 2*m*p + (iz - 2)*2*m + (2*iy - 1)] = face
                    face = SVector((n + 1)*(m + 1) + (iz - 3)*(2*(m + n)) + iy + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + iy + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + iy)
                    faces[4*m*n + 4*n*p + 2*m*p + (iz - 2)*2*m + (2*iy)] = face
                    #right faces
                    face = SVector((n + 1)*(m + 1) + (iz - 3)*(2*(m + n)) + m + 2*n - 1 + iy, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2*n - 1 + iy, (n + 1)*(m + 1) + (iz - 3)*(2*(m + n)) + m + 2*n - 1 + iy + 1)
                    faces[2*m*n + 2*n*p + (iz - 2)*2*m + (2*iy - 1)] = face
                    face = SVector((n + 1)*(m + 1) + (iz - 3)*(2*(m + n)) + m + 2*n - 1 + iy + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2*n - 1 + iy, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2*n - 1 + iy + 1)
                    faces[2*m*n + 2*n*p + (iz - 2)*2*m + (2*iy)] = face
                end
                
                #ix in n -> right nodes
                node = SVector(a, (iy - 1)*h, (iz - 1)*h)
                nodes[(n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 2*n - 1) + iy] = node
                #@show node
            end

            #iz = p + 1
            if iy != (m + 1)
                #left faces
                face = SVector((n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + iy, (n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + iy + 1, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + iy)
                faces[4*m*n + 4*n*p + 2*m*p + (p - 1)*2*m + (2*iy - 1)] = face
                face = SVector((n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + iy + 1, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + iy + 1, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + iy)
                faces[4*m*n + 4*n*p + 2*m*p + (p - 1)*2*m + (2*iy)] = face
                #right faces
                face = SVector((n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + m + 2*n - 1 + iy, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + n*(m + 1) + iy, (n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + m + 2*n - 1 + iy + 1)
                faces[2*m*n + 2*n*p + (p - 1)*2*m + (2*iy - 1)] = face
                face = SVector((n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + m + 2*n - 1 + iy + 1, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + n*(m + 1) + iy, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + n*(m + 1) + iy + 1)
                faces[2*m*n + 2*n*p + (p - 1)*2*m + (2*iy)] = face
            end

        end


        # along x - z

        #faces adjacent to the left, right, front and back{
        #iz = 1 {
            #bottom faces
            #ix = 1
            face = SVector(1, (n + 1)*(m + 1) + 1, (m + 1) + 1)
            faces[2*m*n + 1] = face
            face = SVector((n + 1)*(m + 1) + 1, (n + 1)*(m + 1) + (m + 1) + 1, (m + 1) + 1)
            faces[2*m*n + 2] = face
            #ix = n
            face = SVector((n - 1)*(m + 1) + 1, (n + 1)*(m + 1) + m + 2*n - 2, (n)*(m + 1) + 1)
            faces[2*m*n + (n - 1)*2*p + 1] = face
            face = SVector((n + 1)*(m + 1) + m + 2*n - 2, (n + 1)*(m + 1) + m + 2*n, (n)*(m + 1) + 1)
            faces[2*m*n + (n - 1)*2*p + 2] = face
            #top faces
            #ix = 1
            face = SVector(m + 1, 2*(m + 1), (n + 1)*(m + 1) + m + 1)
            faces[4*m*n + 2*m*p + 2*n*p + 1] = face
            face = SVector((n + 1)*(m + 1) + m + 1, 2*(m + 1), (n + 1)*(m + 1) + m + 3)
            faces[4*m*n + 2*m*p + 2*n*p + 2] = face
            #ix = n
            face = SVector(n*(m + 1), (n + 1)*(m + 1), (n + 1)*(m + 1) + (m + 1) + 2*(n - 1))
            faces[4*m*n + 2*m*p + 2*n*p + (n - 1)*2*p + 1] = face
            face = SVector((n + 1)*(m + 1) + (m + 1) + 2*(n - 1), (n + 1)*(m + 1), (n + 1)*(m + 1) + 2*(m + n))
            faces[4*m*n + 2*m*p + 2*n*p + (n - 1)*2*p + 2] = face
            # }

            #iz = p {
            #ix = 1
            #bottom faces
            face = SVector((n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + 1, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + 1, (n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + m + 2)
            faces[2*m*n + (2*p - 1)] = face
            face = SVector((n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + 1, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + m + 2, (n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + m + 2)
            faces[2*m*n + (2*p)] = face
            #top faces
            face = SVector((n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + m + 1, (n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + m + 3, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + m + 1)
            faces[4*m*n + 2*m*p + 2*n*p + (2*p - 1)] = face
            face = SVector((n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + m + 1, (n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + m + 3, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + 2*(m + 1))
            faces[4*m*n + 2*m*p + 2*n*p + (2*p)] = face

            #ix = n
            #bottom faces
            face = SVector((n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + (m + 2*(n - 1)), (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + (n - 1)*(m + 1) + 1, (n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + (m + 2*n))
            faces[2*m*n + (n - 1)*2*p + (2*p - 1)] = face
            face = SVector((n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + (n - 1)*(m + 1) + 1, (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + (n)*(m + 1) + 1, (n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + (m + 2*n))
            faces[2*m*n + (n - 1)*2*p + (2*p)] = face
            #top faces
            face = SVector((n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + (m + 2*(n - 1)) + 1, (n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + 2*(m + n), (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + (n)*(m + 1))
            faces[4*m*n + 2*m*p + 2*n*p + (n - 1)*2*p + (2*p - 1)] = face
            face = SVector((n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + 2*(m + n), 2*(n + 1)*(m + 1) + (p - 1)*(2*(m + n)), (n + 1)*(m + 1) + (p - 1)*(2*(m + n)) + (n)*(m + 1))
            faces[4*m*n + 2*m*p + 2*n*p + (n - 1)*2*p + (2*p)] = face
            # }
            #}
        for ix in range(1, n)
           

            if (ix != 1) 
                #nodes for iz = p
                #iy = 1 -> bottom nodes
                node = SVector((ix - 1)*h, Float64(0), (p - 1)*h)
                nodes[(n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + (m + 1) + (ix - 2)*2 + 1] = node

                #iy = m -> top nodes
                node = SVector((ix - 1)*h, b, (p - 1)*h)
                nodes[(n + 1)*(m + 1) + (p - 2)*(2*(m + n)) + (m + 1) + (ix - 1)*2] = node

                if (ix != n)
                    # iz = 1
                    #bottom faces
                    face = SVector((ix - 1)*(m + 1) + 1, (n + 1)*(m + 1) + (m + 1) + (ix - 2)*2 + 1, (ix)*(m + 1) + 1)
                    faces[2*m*n + (ix - 1)*2*p + 1] = face
                    face = SVector((n + 1)*(m + 1) + (m + 1) + (ix - 2)*2 + 1, (n + 1)*(m + 1) + (m + 1) + (ix - 1)*2 + 1, (ix)*(m + 1) + 1)
                    faces[2*m*n + (ix - 1)*2*p + 2] = face
                    #top faces
                    face = SVector(ix*(m + 1), (ix + 1)*(m + 1), (n + 1)*(m + 1) + (m + 1) + (ix - 1)*2)
                    faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + 1] = face
                    face = SVector((n + 1)*(m + 1) + (m + 1) + (ix - 1)*2, (ix + 1)*(m + 1), (n + 1)*(m + 1) + (m + 1) + (ix)*2)
                    faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + 2] = face
                    # iz = p 
                    #bottom faces
                    face = SVector((n + 1)*(m + 1) + (p - 2)*2*(m + n) + (m + 1) + (ix - 2)*2 + 1, (n + 1)*(m + 1) + (p - 1)*2*(m + n) + (ix - 1)*(m + 1) + 1, (n + 1)*(m + 1) + (p - 2)*2*(m + n) + (m + 1) + (ix - 1)*2 + 1)
                    faces[2*m*n + (ix - 1)*2*p + (2*p - 1)] = face
                    face = SVector((n + 1)*(m + 1) + (p - 1)*2*(m + n) + (ix - 1)*(m + 1) + 1, (n + 1)*(m + 1) + (p - 1)*2*(m + n) + (ix)*(m + 1) + 1, (n + 1)*(m + 1) + (p - 2)*2*(m + n) + (m + 1) + (ix - 1)*2 + 1)
                    faces[2*m*n + (ix - 1)*2*p + (2*p)] = face
                    #top faces
                    face = SVector((n + 1)*(m + 1) + (p - 2)*2*(m + n) + (m + 1) + (ix - 1)*2, (n + 1)*(m + 1) + (p - 2)*2*(m + n) + (m + 1) + (ix)*2, (n + 1)*(m + 1) + (p - 1)*2*(m + n) + ix*(m + 1))
                    faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*p - 1)] = face
                    face = SVector((n + 1)*(m + 1) + (p - 2)*2*(m + n) + (m + 1) + (ix)*2, (n + 1)*(m + 1) + (p - 1)*2*(m + n) + (ix + 1)*(m + 1), (n + 1)*(m + 1) + (p - 1)*2*(m + n) + ix*(m + 1))
                    faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*p)] = face
                end
            end

            for iz in range(2, p - 1)

                if ix == 1
                    #bottom faces
                    face = SVector((n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + 1, (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2)
                    faces[2*m*n + (ix - 1)*2*p + (2*iz - 1)] = face
                    face = SVector((n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + 1, (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + m + 2, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2)
                    faces[2*m*n + (ix - 1)*2*p + (2*iz)] = face

                    #top faces
                    face = SVector((n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 3, (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + m + 1)
                    faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*iz - 1)] = face
                    face = SVector((n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + m + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 3, (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + m + 3)
                    faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*iz)] = face

                elseif ix == n
                    #bottom faces
                    face = SVector((n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2*(n - 1), (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + m + 2*(n - 1), (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2*n)
                    faces[2*m*n + (ix - 1)*2*p + (2*iz - 1)] = face
                    face = SVector((n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + m + 2*(n - 1), (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + m + 2*n, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 2*n)
                    faces[2*m*n + (ix - 1)*2*p + (2*iz)] = face
                    #top faces
                    face = SVector((n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + m + 1 + 2*(n - 1), (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)), (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + m + 2*(n - 1) + 1)
                    faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*iz - 1)] = face
                    face = SVector((n + 1)*(m + 1) + (iz - 1)*(2*(m + n)), (n + 1)*(m + 1) + (iz)*(2*(m + n)), (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + m + 2*(n - 1) + 1)
                    faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*iz)] = face


                    #nodes
                    #iy = 1 -> bottom nodes
                    node = SVector((ix - 1)*h, Float64(0), (iz - 1)*h)
                    nodes[(n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 1) + (ix - 2)*2 + 1] = node

                    #iy = m -> top nodes
                    node = SVector((ix - 1)*h, b, (iz - 1)*h)
                    nodes[(n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 1) + (ix - 1)*2] = node


                else
                    #for iy = 1 -> bottom faces
                    face = SVector((n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 1) + (ix - 2)*(2) + 1, (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + (m + 1) + (ix - 2)*(2) + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 1) + (ix - 1)*2 + 1)
                    faces[2*m*n + (ix - 1)*2*p + (2*iz - 1)] = face
                    face = SVector((n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + (m + 1) + (ix - 2)*(2) + 1, (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + (m + 1) + (ix - 1)*(2) + 1, (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 1) + (ix - 1)*2 + 1)
                    faces[2*m*n + (ix - 1)*2*p + (2*iz)] = face
                
                    #for iy = m -> top faces
                    face = SVector((n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 1) + (ix - 1)*(2), (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 1) + (ix)*2, (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + (m + 1) + (ix - 1)*(2))
                    faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*iz - 1)] = face
                    face = SVector((n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + (m + 1) + (ix - 1)*(2), (n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 1) + (ix)*2, (n + 1)*(m + 1) + (iz - 1)*(2*(m + n)) + (m + 1) + (ix)*(2))
                    faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*iz)] = face

                    #nodes
                    #iy = 1 -> bottom nodes
                    node = SVector((ix - 1)*h, Float64(0), (iz - 1)*h)
                    nodes[(n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 1) + (ix - 2)*2 + 1] = node

                    #iy = m -> top nodes
                    node = SVector((ix - 1)*h, b, (iz - 1)*h)
                    nodes[(n + 1)*(m + 1) + (iz - 2)*(2*(m + n)) + (m + 1) + (ix - 1)*2] = node

                end

            end
            
        end

    #@show nodes
    #@show faces
    return Mesh(nodes, faces)
end

##

