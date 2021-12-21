import java.io.File
import kotlin.system.measureTimeMillis

class CaveMap(input: File) {
    data class Cave(
        val name: String,
        val connections: MutableList<String>)

    val caves = hashMapOf<String, Cave>()

    init {
        input.readLines().forEach { line ->
            val links = line.split("-")
            val c1 = caves.getOrPut(links[0], { Cave(links[0], mutableListOf<String>()) })
            val c2 = caves.getOrPut(links[1], { Cave(links[1], mutableListOf<String>()) })
            c1.connections.add(c2.name)
            c2.connections.add(c1.name)
        }
    }

    companion object {
        private const val START_NAME = "start"
        private const val END_NAME = "end"
    }

    fun allPaths(singleSmallRevisitAllowed: Boolean): List<List<String>> {
        val start = findCave(START_NAME)
        return pathsToEnd(
            start,
            listOf<String>(),
            singleSmallRevisitAllowed)
    }

    private fun pathsToEnd(
        cave: Cave,
        preceedingPath: List<String>,
        singleSmallRevisitAllowed: Boolean): List<List<String>> {
        val currPath = preceedingPath + cave.name

        if (cave.name == END_NAME) {
            return listOf(currPath)
        }

        return cave.connections
            .filterNot {
                if (allowSmallCaveRevisit(singleSmallRevisitAllowed, it, currPath)) {
                    false
                } else {
                    isSmallCave(it) && wouldRevisit(it, currPath)
                }
            }
            .flatMap {
                val consumedRevisit = allowSmallCaveRevisit(singleSmallRevisitAllowed, it, currPath)
                pathsToEnd(findCave(it), currPath, singleSmallRevisitAllowed && !consumedRevisit)
            }
    }

    private fun allowSmallCaveRevisit(singleUseAvailable: Boolean, name: String, currPath: List<String>): Boolean {
        return singleUseAvailable &&
            isSmallCave(name) &&
            name != START_NAME &&
            wouldRevisit(name, currPath)
    }

    private fun wouldRevisit(connName: String, path: List<String>): Boolean {
        return path.contains(connName)
    }

    private fun findCave(name: String): Cave {
        return caves[name]!! // unsafe, but don't care here
    }

    private fun isSmallCave(name: String): Boolean {
        return name.first().isLowerCase()
    }
}

fun part1(): Int {
    return CaveMap(File("input")).allPaths(false).size
}

fun part2(): Int {
    return CaveMap(File("input")).allPaths(true).size
}

var p1: Int
val t1 = measureTimeMillis { p1 = part1() }

var p2: Int
val t2 = measureTimeMillis { p2 = part2() }

println("Part 1 Result ($t1 ms): \n$p1\n")
println("Part 2 Result ($t2 ms): \n$p2")
