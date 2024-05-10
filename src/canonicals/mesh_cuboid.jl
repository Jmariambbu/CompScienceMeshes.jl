using CompScienceMeshes
using StaticArrays
using Plotly

##

mc = meshcuboid(1.0, 1.0, 1.0, 0.5)
mc.vertices
mc.faces
plot(wireframe(mc))



##
"""
Notes~~~

1. Gmsh makes unstructured/ irregular meshes for the cubic case -- See Delauney algorithm


"""


## 


#requires meshing of a rectangle, its transformation to other planes, and its translation along different axes
#using mesher2, trnsfrm, trnslte
"""
Function meshes the cuboid surface regularly.

The cuboid is divided into its 6 surfaces:

The surfaces that do require reversing of their direction:
° Front
° Top 
° Right

The surfaces that do not: -> translate directionally unreversed surfaces of the previous three
° Back
° Bottom
° Left


"""
function mesher_gen(a::Float64, b::Float64, c::Float64, h::Float64) 

    # if  isapprox(a%h, F(0)) && isapprox(b%h, F(0))
        n = Int(a/h)  # number of elements along a
        #@show n
        m = Int(b/h)  # number of elements along b
        #@show m
        p = Int(c/h)  #number of elements along c
        #@show p
        

        nodes = Vector{SVector{3, Float64}}(undef, 2*(m + 1)*(n + 1) + 2*(m + 1)*(p + 1) + 2*(n + 1)*(p + 1))
        faces = Vector{SVector{3, Int64}}(undef, 4*m*n + 4*n*p + 4*m*p)


        #along x-y
        for ix in range(1, n)
            for iy in range(1, m)

                #nodes
                #front
                node = SVector((ix - 1)*h, (iy - 1)*h, Float64(0))
                #@show node
                @assert typeof(node) == SVector{3, Float64}
               # @show node
                nodes[(ix - 1)*(m + 1) + iy] = node
                #back
                node = SVector((ix - 1)*h, (iy - 1)*h, p*h)
                
                nodes[(m + 1)*(p + 1) + (n + 1)*(p + 1) + (m + 1)*(n + 1) + (ix - 1)*(m + 1) + iy] = node
            
                #faces
                #front 

                face = SVector((ix - 1)*(m + 1) + (iy), (ix)*(m + 1) + (iy), (ix - 1)*(m + 1) + (iy + 1))
                faces[(ix - 1)*2*m + (2*iy - 1)] = face

                #@show face
                #push!(faces, face)
                face = SVector((ix - 1)*(m + 1) + (iy + 1), (ix)*(m + 1) + (iy), (ix)*(m + 1) + (iy + 1))
                faces[(ix - 1)*2*m + (2*iy)] = face
            

                #back
                face = SVector(p*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + (iy), p*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + (iy + 1), p*(m + 1)*(n + 1) + (ix)*(m + 1) + (iy))
                faces[2*m*p + 2*n*p + 2*m*n + (ix - 1)*2*m + (2*iy - 1)] = face
                @show face

                face = SVector(p*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + (iy + 1), p*(m + 1)*(n + 1) + (ix)*(m + 1) + (iy + 1), p*(m + 1)*(n + 1) + (ix)*(m + 1) + (iy))
                faces[2*m*p + 2*n*p + 2*m*n + (ix - 1)*2*m + (2*iy)] = face
                @show face
                
            end

            # for the mth element in y-direction
            # @show faces
            #front
            nodes[ix*(m + 1)] = SVector((ix - 1)*h, m*h,  Float64(0))
            #back
            nodes[(m + 1)*(p + 1) + (n + 1)*(p + 1) + (m + 1)*(n + 1) + ix*(m + 1)] = SVector((ix - 1)*h, m*h, p*h)
            # @show SVector((ix - 1)*h, m*h, Float64(0))
            #push!(nodes, SVector((ix - 1)*h, m*h, Float64(0)))
        end


        #along x-z
        for ix in range(1, n)
            for iz in range(1, p)
                #bottom
                node = SVector((ix - 1)*h, Float64(0), (iz - 1)*h)
                #@show node
                @assert typeof(node) == SVector{3, Float64}
               # @show node
                nodes[(m + 1)*(n + 1) + (ix - 1)*(p + 1) + iz] = node
                #top
                node = SVector((ix - 1)*h, m*h, (iz - 1)*h)
                
                nodes[2*(m + 1)*(n + 1) + (n + 1)*(p + 1) + (m + 1)*(p + 1) + (ix - 1)*(p + 1) + iz] = node
            
                #faces
                #bottom 

                face = SVector((iz - 1)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1, (iz)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1, (iz - 1)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1)
                faces[2*m*n + (ix - 1)*2*p + (2*iz - 1)] = face

                #@show face
                #push!(faces, face)
                
                face = SVector((iz)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1, (iz)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1, (iz - 1)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1)
                faces[2*m*n + (ix - 1)*2*p + (2*iz)] = face
            

                #top
                face = SVector(m + (iz - 1)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1, m + (iz - 1)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1, m + (iz)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1)
                faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*iz - 1)] = face

                face = SVector(m + (iz)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1, m + (iz - 1)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1, m + (iz)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1)
                faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*iz)] = face

            end
           
            #bottom
            nodes[(m + 1)*(n + 1) + ix*(p + 1)] = SVector((ix - 1)*h,  Float64(0), p*h)
            #top
            nodes[2*(m + 1)*(n + 1) + (n + 1)*(p + 1) + (m + 1)*(p + 1) + ix*(p + 1)] = SVector((ix - 1)*h, m*h, p*h)
        end

        # for ix = n
        for iy in range(0, m)
            #front
            nodes[n*(m + 1) + iy + 1] = SVector(n*h, (iy*h),  Float64(0))
            #back
            nodes[(m + 1)*(p + 1) + (n + 1)*(p + 1) + (n + 1)*(m + 1) + n*(m + 1) + iy + 1] = SVector(n*h, (iy*h), p*h)
            
            #push!(nodes, SVector(n*h, (iy*h), Float64(0)))
        end
        
        #for ix = n
        for iz in range(0, p)
            #bottom
            nodes[(m + 1)*(n + 1) + n*(p + 1) + iz + 1] = SVector(n*h, Float64(0), iz*h)
            #top
            nodes[2*(m + 1)*(n + 1) + (n + 1)*(p + 1) + (m + 1)*(p + 1) + n*(p + 1) + iz + 1] = SVector(n*h, m*h, iz*h)
        end
        #for faces
        
    #end


        #along y-z
        for iz in range(1, p)
            for iy in range(1, m)
                #Right

                node = SVector(n*h, (iy - 1)*h, (iz - 1)*h)
                #@show node

                @assert typeof(node) == SVector{3, Float64}
                # @show node

                nodes[(n + 1)*(p + 1) + (n + 1)*(m + 1) + (iz - 1)*(m + 1) + iy] = node

                #Left
                node = SVector(Float64(0), (iy - 1)*h, (iz - 1)*h)
                
                nodes[(m + 1)*(p + 1) + 2*(n + 1)*(p + 1) + 2*(m + 1)*(n + 1) + (iz - 1)*(m + 1) + iy] = node


                #faces
                #Right 

                face = SVector((iz - 1)*(m + 1)*(n + 1) + n*(m + 1) + iy, (iz)*(m + 1)*(n + 1) + n*(m + 1) + iy, (iz - 1)*(m + 1)*(n + 1) + n*(m + 1) + iy + 1)
                faces[2*m*n + 2*n*p + (iz - 1)*2*m + (2*iy - 1)] = face

                #@show face
                #push!(faces, face)
                face = SVector((iz - 1)*(m + 1)*(n + 1) + n*(m + 1) + iy + 1, (iz)*(m + 1)*(n + 1) + n*(m + 1) + iy, iz*(m + 1)*(n + 1) + n*(m + 1) + iy + 1)
                faces[2*m*n + 2*n*p + (iz - 1)*2*m + (2*iy)] = face


                #Left
                face = SVector((iz - 1)*(m + 1)*(n + 1) + iy, (iz - 1)*(m + 1)*(n + 1) + iy + 1, (iz)*(m + 1)*(n + 1) + iy + 1)
                faces[4*m*n + 4*n*p + 2*m*p + (iz - 1)*2*m + (2*iy)] = face

                face = SVector((iz - 1)*(m + 1)*(n + 1) + iy, (iz)*(m + 1)*(n + 1) + iy + 1, (iz)*(m + 1)*(n + 1) + iy)
                faces[4*m*n + 4*n*p + 2*m*p + (iz - 1)*2*m + (2*iy - 1)] = face

            end
            nodes[(n + 1)*(p + 1) + (n + 1)*(m + 1) + iz*(m + 1)] = SVector(n*h, m*h, (iz - 1)*h)
        #Left
            nodes[(m + 1)*(p + 1) + 2*(n + 1)*(p + 1) + 2*(m + 1)*(n + 1) + iz*(m + 1)] = SVector(Float64(0), m*h, (iz - 1)*h)
        end

        #for iz = p
        for iy in range(0, m)
            #Right
            nodes[(n + 1)*(p + 1) + (n + 1)*(m + 1) + p*(m + 1) + iy + 1] = SVector(n*h, (iy*h), p*h)
            #Left
            nodes[(m + 1)*(p + 1) + 2*(n + 1)*(p + 1) + 2*(m + 1)*(n + 1) + p*(m + 1) + iy + 1] = SVector(Float64(0), (iy*h), p*h)
            
        end
        #=
        #Right
        Nodes = nodes
        Faces = faces
        #insert!(Nodes, 2*(m + 1)*(p + 1) + 2*(n + 1)*(p + 1) + 2*(m + 1)*(p + 1) + 1, [NaN,NaN, NaN])
        insert!(Nodes, 2*(m + 1)*(p + 1) + 2*(n + 1)*(p + 1) + (m + 1)*(p + 1) + 1, @SVector [NaN, NaN, NaN])
        insert!(Nodes, 2*(m + 1)*(p + 1) + 2*(n + 1)*(p + 1) + 1, @SVector [NaN, NaN, NaN])
        insert!(Nodes, 2*(m + 1)*(p + 1) + (n + 1)*(p + 1) + 1, @SVector [NaN, NaN, NaN])
        insert!(Nodes, 2*(m + 1)*(p + 1) + 1, @SVector [NaN, NaN, NaN])
        insert!(Nodes, (m + 1)*(p + 1) + 1, @SVector [NaN, NaN, NaN])
        #insert!(Faces, 4*m*n + 4*n*p + 4*m*p + 1, [0, 0, 0])
        insert!(Faces, 4*m*n + 4*n*p + 2*m*p + 1, @SVector [1, 2, 3])
        insert!(Faces, 4*m*n + 4*n*p + 1, @SVector [1, 2, 3])
        insert!(Faces, 4*m*n + 2*m*n + 1, @SVector [1, 2, 3])
        insert!(Faces, 4*m*n + 1, @SVector [1, 2, 3])
        insert!(Faces, 2*m*n + 1, @SVector [1, 2, 3])
=#
    return Mesh(nodes, faces)


end

rct = mesher_gen(1.0, 1.0, 1.0, 0.5)


@show rct.vertices
@show rct.faces
#rct = CompScienceMeshes.translate(rct, [1.0, 1.0, 1.0])

plot(wireframe(rct))





function mesher_gen2(a::Float64, b::Float64, c::Float64, h::Float64) 

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
        
        @show nodes
        @show faces

        #along x-z
        for ix in range(1, n)
            for iz in range(1, p)
                #bottom
                node = SVector((ix - 1)*h, Float64(0), (iz - 1)*h)
                #@show node
                @assert typeof(node) == SVector{3, Float64}
               # @show node
                nodes[(m + 1)*(n + 1) + (ix - 1)*(p + 1) + iz] = node
                #top
                node = SVector((ix - 1)*h, m*h, (iz - 1)*h)
                
                nodes[2*(m + 1)*(n + 1) + (n + 1)*(p + 1) + (m + 1)*(p + 1) + (ix - 1)*(p + 1) + iz] = node
            
                #faces
                #bottom 

                face = SVector((iz - 1)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1, (iz)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1, (iz - 1)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1)
                faces[2*m*n + (ix - 1)*2*p + (2*iz - 1)] = face

                #@show face
                #push!(faces, face)
                
                face = SVector((iz)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1, (iz)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1, (iz - 1)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1)
                faces[2*m*n + (ix - 1)*2*p + (2*iz)] = face
            

                #top
                face = SVector(m + (iz - 1)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1, m + (iz - 1)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1, m + (iz)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1)
                faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*iz - 1)] = face

                face = SVector(m + (iz)*(m + 1)*(n + 1) + (ix - 1)*(m + 1) + 1, m + (iz - 1)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1, m + (iz)*(m + 1)*(n + 1) + (ix)*(m + 1) + 1)
                faces[4*m*n + 2*m*p + 2*n*p + (ix - 1)*2*p + (2*iz)] = face

            end
           
            #bottom
            nodes[(m + 1)*(n + 1) + ix*(p + 1)] = SVector((ix - 1)*h,  Float64(0), p*h)
            #top
            nodes[2*(m + 1)*(n + 1) + (n + 1)*(p + 1) + (m + 1)*(p + 1) + ix*(p + 1)] = SVector((ix - 1)*h, m*h, p*h)
        end

        
        #for ix = n
        for iz in range(0, p)
            #bottom
            nodes[(m + 1)*(n + 1) + n*(p + 1) + iz + 1] = SVector(n*h, Float64(0), iz*h)
            #top
            nodes[2*(m + 1)*(n + 1) + (n + 1)*(p + 1) + (m + 1)*(p + 1) + n*(p + 1) + iz + 1] = SVector(n*h, m*h, iz*h)
        end
        #for faces
        
    #end


        #along y-z
        for iz in range(1, p)
            for iy in range(1, m)
                #Right

                node = SVector(n*h, (iy - 1)*h, (iz - 1)*h)
                #@show node

                @assert typeof(node) == SVector{3, Float64}
                # @show node

                nodes[(n + 1)*(p + 1) + (n + 1)*(m + 1) + (iz - 1)*(m + 1) + iy] = node

                #Left
                node = SVector(Float64(0), (iy - 1)*h, (iz - 1)*h)
                
                nodes[(m + 1)*(p + 1) + 2*(n + 1)*(p + 1) + 2*(m + 1)*(n + 1) + (iz - 1)*(m + 1) + iy] = node


                #faces
                #Right 

                face = SVector((iz - 1)*(m + 1)*(n + 1) + n*(m + 1) + iy, (iz)*(m + 1)*(n + 1) + n*(m + 1) + iy, (iz - 1)*(m + 1)*(n + 1) + n*(m + 1) + iy + 1)
                faces[2*m*n + 2*n*p + (iz - 1)*2*m + (2*iy - 1)] = face

                #@show face
                #push!(faces, face)
                face = SVector((iz - 1)*(m + 1)*(n + 1) + n*(m + 1) + iy + 1, (iz)*(m + 1)*(n + 1) + n*(m + 1) + iy, iz*(m + 1)*(n + 1) + n*(m + 1) + iy + 1)
                faces[2*m*n + 2*n*p + (iz - 1)*2*m + (2*iy)] = face


                #Left
                face = SVector((iz - 1)*(m + 1)*(n + 1) + iy, (iz - 1)*(m + 1)*(n + 1) + iy + 1, (iz)*(m + 1)*(n + 1) + iy + 1)
                faces[4*m*n + 4*n*p + 2*m*p + (iz - 1)*2*m + (2*iy)] = face

                face = SVector((iz - 1)*(m + 1)*(n + 1) + iy, (iz)*(m + 1)*(n + 1) + iy + 1, (iz)*(m + 1)*(n + 1) + iy)
                faces[4*m*n + 4*n*p + 2*m*p + (iz - 1)*2*m + (2*iy - 1)] = face

            end
            nodes[(n + 1)*(p + 1) + (n + 1)*(m + 1) + iz*(m + 1)] = SVector(n*h, m*h, (iz - 1)*h)
        #Left
            nodes[(m + 1)*(p + 1) + 2*(n + 1)*(p + 1) + 2*(m + 1)*(n + 1) + iz*(m + 1)] = SVector(Float64(0), m*h, (iz - 1)*h)
        end

        #for iz = p
        for iy in range(0, m)
            #Right
            nodes[(n + 1)*(p + 1) + (n + 1)*(m + 1) + p*(m + 1) + iy + 1] = SVector(n*h, (iy*h), p*h)
            #Left
            nodes[(m + 1)*(p + 1) + 2*(n + 1)*(p + 1) + 2*(m + 1)*(n + 1) + p*(m + 1) + iy + 1] = SVector(Float64(0), (iy*h), p*h)
            
        end
    
    return Mesh(nodes, faces)
end




rct3 = mesher_gen2(1.0, 1.0, 1.0, 0.5)




rct2 = meshcuboid(1.0, 1.0, 1.0, 0.5)

plot(wireframe(rct2))
##
"A function to translate rectangle in x, y, z - axes";
