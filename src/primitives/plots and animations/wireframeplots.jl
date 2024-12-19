using CompScienceMeshes
using Plotly
using Plots
##
#mesh_rectangle
rec = mesh_rectangle(1.0, 1.0, 0.1)
Plotly.plot(CompScienceMeshes.wireframe(rec), 
    Layout(title = "Regular mesh of a rectangle"))
#meshrectangle
rect = meshrectangle(1.0, 1.0, 0.1)
Plotly.plot(CompScienceMeshes.wireframe(rect), 
    Layout(title = "'CompScienceMeshes' mesh of a rectangle"))

##
#mesh_cuboid
cub = mesh_cuboid(1.0, 1.0, 1.0, 0.5)
Plotly.plot(CompScienceMeshes.wireframe(cub), 
    Layout(title = "Regular mesh of a cuboid"))
#meshcuboid
cubd = meshcuboid(1.0, 1.0, 1.0, 0.5)
Plotly.plot(CompScienceMeshes.wireframe(cubd), 
    Layout(title = "'CompScienceMeshes' mesh of a cuboid"))

##
#mesh_sphere
s1 = mesh_sphere(1.0, 0.5, delaunay =:(2D))
s2 = mesh_sphere(1.0, 0.5, delaunay =:(3D))
Plotly.plot(CompScienceMeshes.wireframe(s1), 
    Layout(title = "'2D Delaunay' mesh of a sphere"))
Plotly.plot(CompScienceMeshes.wireframe(s2), 
    Layout(title = "'3D Delaunay' mesh of a sphere"))
#meshsphere
s3 = meshsphere(1.0, 0.5)
Plotly.plot(CompScienceMeshes.wireframe(s3), 
    Layout(title = "'CompScienceMeshes' mesh of a sphere"))

##
#mesh_icosphere
ico = icosphere(5)
Plotly.plot(CompScienceMeshes.wireframe(ico), 
    Layout(title = "Mesh of an icosphere"))

##
#tetmesh_cuboid
tt = tetmesh_cuboid(1.0, 1.0, 1.0, 1.0)
Plotly.plot(CompScienceMeshes.wireframe(tt), 
    Layout(title = "Regular tetrahedral mesh of a cuboid"))
#tetmeshcuboid
t = tetmeshcuboid(1.0, 1.0, 1.0, 1.0)
Plotly.plot(CompScienceMeshes.wireframe(t), 
    Layout(title = "'CompScienceMeshes' tetrahedral mesh of a cuboid", 
    showaxis = false))
##
