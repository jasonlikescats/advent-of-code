import java.io.File

fun readInput(): List<Int> {
    return File("input").readLines().map { it.toInt() }
}

fun part1(depths: List<Int>): Int {
    var increasingCounter = 0
    for (i in depths.indices.drop(1)) {
        if (depths[i] > depths[i-1]) {
            increasingCounter++
        }
    }
    return increasingCounter
}

fun part2(depths: List<Int>): Int {
    var increasingCounter = 0
    for (i in depths.indices.drop(3)) {
        val prevWindowSum = depths[i-1] + depths[i-2] + depths[i-3]
        val currWindowSum = depths[i] + depths[i-1] + depths[i-2]
        if (currWindowSum > prevWindowSum) {
            increasingCounter++
        }
    }
    return increasingCounter
}

val depths = readInput()
println("Part 1 Result: \n${part1(depths)}\n")
println("Part 2 Result: \n${part2(depths)}")
