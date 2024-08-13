using CompScienceMeshes
using Plotly

##
#mesh_rectangle
rec = mesh_rectangle(1.0, 1.0, 0.1)

plot(wireframe(rec), Layout(title = "Regular mesh of a rectangle"))

#meshrectangle
rect = meshrectangle(1.0, 1.0, 0.1)

plot(wireframe(rect), Layout(title = "'CompScienceMeshes' mesh of a rectangle"))

##
#mesh_cuboid
cub = mesh_cuboid(1.0, 1.0, 1.0, 0.5)

plot(wireframe(cub), Layout(title = "Regular mesh of a cuboid"))

#meshcuboid
cubd = meshcuboid(1.0, 1.0, 1.0, 0.5)

plot(wireframe(cubd), Layout(title = "'CompScienceMeshes' mesh of a cuboid"))

##
#mesh_sphere
s1 = mesh_sphere(1.0, 0.5, delaunay =:(2D))
s2 = mesh_sphere(1.0, 0.5, delaunay =:(3D))

plot(wireframe(s1), Layout(title = "'2D Delaunay' mesh of a sphere"))
plot(wireframe(s2), Layout(title = "'3D Delaunay' mesh of a sphere"))

#meshsphere
s3 = meshsphere(1.0, 0.5)

plot(wireframe(s3), Layout(title = "'CompScienceMeshes' mesh of a sphere"))

##
#mesh_icosphere
ico = icosphere(2)

plot(wireframe(ico), Layout(title = "Mesh of an icosphere"))

##
#tetmesh_cuboid
tt = tetmesh_cuboid(1.0, 1.0, 1.0, 1.0)

plot(wireframe(tt), Layout(title = "Regular tetrahedral mesh of a cuboid"))

#tetmeshcuboid
t = tetmeshcuboid(1.0, 1.0, 1.0, 1.0)

plot(wireframe(t), Layout(title = "'CompScienceMeshes' tetrahedral mesh of a cuboid"))

##
