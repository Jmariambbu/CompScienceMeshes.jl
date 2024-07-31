using CompScienceMeshes
using Test

refrect = meshrectangle(1.0, 1.0, 0.1)
rect = mesh_rectangle(1.0, 1.0, 0.1)

@test length(refrect.vertices) == length(rect.vertices)


## Case 1

@time refrect = meshrectangle(1.0, 1.0, 0.1);

@time rect = mesh_rectangle(1.0, 1.0, 0.1);

## 

isapprox( refrect.vertices, rect.vertices)
@test refrect.faces == rect.faces


## Case 2

@time refrect = meshrectangle(1.0, 1.0, 0.01);

@time rect = mesh_rectangle(1.0, 1.0, 0.01);

##

isapprox( refrect.vertices, rect.vertices)
@test refrect.faces == rect.faces


## Case 3

@time refrect = meshrectangle(1.0, 1.0, 0.001);

@time rect = mesh_rectangle(1.0, 1.0, 0.001);


##

isapprox( refrect.vertices, rect.vertices)
@test refrect.faces == rect.faces