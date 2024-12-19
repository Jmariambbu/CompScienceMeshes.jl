using BenchmarkTools
using Printf

for i in 1:50:500
    ico = icosphere(i)
    println("\nNumber of vertices:\t", length(ico.vertices))
    println("Number of faces:\t", length(ico.faces))
    @printf("Time: %.15f", @elapsed icosphere(i))
end
println("Number of divisions:", 5)
@benchmark icosphere(5)
println("Number of divisions:", 80)
@benchmark icosphere(80)
##

ico = icosphere(1)
    println("\nNumber of edge divisions:", 1)
    println("Number of vertices:\t", length(ico.vertices))
    println("Number of faces:\t", length(ico.faces))

for i in 1:4
    ico = icosphere(20*i)
    println("Number of edge divisions:", 20*i)
    println("Number of vertices:\t", length(ico.vertices))
    println("Number of faces:\t", length(ico.faces))
end 