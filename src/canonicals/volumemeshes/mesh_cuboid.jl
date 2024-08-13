using CompScienceMeshes
using StaticArrays

function tetmesh_cuboid(a::F, b::F, c::F, h::F) where F
    n = Int(round(a/h)) #number of elements along x
    m = Int(round(b/h)) #number of elements along y
    p = Int(round(c/h)) #number of elements along z

    #total number of vertices becomes (m + 1) along each edge in y direction 
        #and along each plane in z direction
    vertices = Vector{SVector{3, F}}(
        undef, 
        (m + 1)*(n + 1)*(p + 1) + 4*m*n*p + (m*n + n*p + m*p)
        )
    #there are 24 tetrahedrons in each unit cube - 4 on each side - 
        #and there are m*n*p unit cubes in each cuboid
    faces = Vector{SVector{4, Int}}(undef, 24*m*n*p)

    verts = (m + 1)*(n + 1)*(p + 1)
    cents = m*n*p
    sides = verts + cents

    for iz in 1 : p+1
        for iy in 1 : m+1
            for ix in 1 : n+1
                v = Vector{SVector{4, Int}}(undef, 24)
                #vertices of unit cubes
                ver_mem1 = ((ix - 1)*(m + 1) 
                         + (iy) 
                         + (iz - 1)*(m + 1)*(n + 1))
                vertices[ver_mem1] = SVector(
                    (ix - 1)*h, 
                    (iy - 1)*h, 
                    (iz - 1)*h
                    ) 
                #centers on the surfaces of unit cubes
                #they are ordered from front to back, bottom to top, left to right 
                if (ix != n + 1)&&(iy != m + 1)
                    ver_mem21 = (sides 
                              + iy 
                              + (ix - 1)*m 
                              + (iz - 1)*m*n)
                    vertices[ver_mem21] = SVector(
                        (ix - 0.5)*h, 
                        (iy - 0.5)*h, 
                        (iz - 1)*h
                        )
                end
                if (ix != (n + 1))&&(iz != (p + 1))
                    ver_mem22 = (sides + m*n*(p + 1) 
                              + iz 
                              + (ix - 1)*p 
                              + (iy - 1)*n*p)
                    vertices[ver_mem22] = SVector(
                        (ix - 0.5)*h, 
                        (iy - 1)*h, 
                        (iz - 0.5)*h
                        )
                end
                if (iy != (m + 1))&&(iz != (p + 1))
                    ver_mem23 = (sides + n*p*(m + 1) + m*n*(p + 1) 
                              + iy 
                              + (iz - 1)*m 
                              + (ix - 1)*m*p)
                    vertices[ver_mem23] = SVector(
                        (ix - 1)*h, 
                        (iy - 0.5)*h, 
                        (iz - 0.5)*h
                        )
                end

                if (ix != (n + 1))&&(iy != (m + 1))&&(iz != (p + 1))
                    #centers of unit cubes
                    ver_mem3 = (verts 
                             + (ix - 1)*m 
                             + iy 
                             + (iz - 1)*m*n)
                    vertices[ver_mem3] = SVector(
                        (ix - 0.5)*h, 
                        (iy - 0.5)*h, 
                        (iz - 0.5)*h
                        )

                    #faces on each unit cube
                    face_mem = ((ix - 1)*m + iy + (iz - 1)*m*n) - 1
                    #faces
                    for l in 0:2
                        for k in 0:1
                            for i in 0:1
                                for j in 0:1
                                    v1 = ((ix - 1 + i)*(m + 1) 
                                       + (iy + j) 
                                       + (iz - 1 + k)*(m + 1)*(n + 1))
                                    if l == 0 #front-back
                                        v2 = ((ix - 1 + j)*(m + 1) 
                                           + (iy + (1 - i)) 
                                           + (iz - 1 + k)*(m + 1)*(n + 1))
                                        v3 = (sides 
                                           + iy 
                                           + (ix - 1)*m 
                                           + (iz - 1 + k)*m*n)
                                    elseif l == 1 #bottom-top
                                        v2 = ((ix - 1 + k)*(m + 1) 
                                           + (iy + j) 
                                           + (iz - 1 + (1 - i))*(m + 1)*(n + 1))
                                        v3 = (sides + m*n*(p + 1) 
                                           + iz 
                                           + (ix - 1)*p 
                                           + (iy - 1 + j)*n*p)
                                    else #left-right
                                        v2 = ((ix - 1 + i)*(m + 1) 
                                           + (iy + (1 - k)) 
                                           + (iz - 1 + j)*(m + 1)*(n + 1))
                                        v3 = (sides + n*p*(m + 1) + m*n*(p + 1) 
                                           + iy + (iz - 1)*m 
                                           + (ix - 1 + i)*m*p)
                                    end
                                    v4 = ver_mem3 #always the center of the unit cube
                                    v[8*l + 4*k + 2*i + j + 1] = SVector(v1, v2, v3, v4)
                                end
                            end
                        end
                    end
                    for i in 1:24
                        faces[face_mem*24 + i] = v[i]
                    end

                end
            end
        end
    end

    return Mesh(vertices, faces)
end

