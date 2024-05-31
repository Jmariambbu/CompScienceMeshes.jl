using BEAST
using CompScienceMeshes
using Test

mesh = mesh_cuboid(1.0, 1.0, 1.0, 0.01)

nedges = length(BEAST.raviartthomas(mesh).pos) 

@test length(mesh.vertices) - nedges + length(mesh.faces) == 2

@time mesh_cuboid(1.0, 1.0, 1.0, 0.01);
@time meshcuboid(1.0, 1.0, 1.0, 0.01);

