import java.io.File

class DepthMap(input: File) {
    data class Coord(val row: Int, val col: Int)

    val grid: Array<Array<Int>>

    init {
        val lines = input.readLines()
        grid = lines.map { line ->
            line
                .map { it.toString().toInt() }
                .toTypedArray()
        }.toTypedArray()
    }

    fun lowPoints(): List<Coord> {
        val lowPoints = mutableListOf<Coord>()

        for (row in grid.indices) {
            for (col in grid[row].indices) {
                val coord = Coord(row, col)
                if (isLowPoint(coord)) {
                    lowPoints.add(coord)
                }
            }
        }

        return lowPoints
    }

    fun findBasins(): List<Set<Coord>> {
        val basins = mutableListOf<Set<Coord>>()

        lowPoints().forEach {
            val basin = mutableSetOf<Coord>()
            fillBasin(it, basin)
            basins.add(basin)
        }

        return basins
    }

    private fun isLowPoint(coord: Coord): Boolean {
        val adjacentVals = adjacent(coord).map { grid[it.row][it.col] }

        return adjacentVals.all { it > grid[coord.row][coord.col] }
    }

    private fun fillBasin(coord: Coord, basin: MutableSet<Coord>) {
        basin.add(coord)
        adjacent(coord)
            .filterNot(::isPeak)
            .filterNot { basin.contains(it) }
            .forEach { fillBasin(it, basin) }
    }

    private fun adjacent(coord: Coord): List<Coord> {
        return listOf<Coord>(
            Coord(coord.row - 1, coord.col),
            Coord(coord.row + 1, coord.col),
            Coord(coord.row, coord.col - 1),
            Coord(coord.row, coord.col + 1)
        ).filter(::isValid)
    }

    private fun isValid(coord: Coord): Boolean {
        return (
            coord.row >= 0 &&
            coord.row < grid.size &&
            coord.col >= 0 &&
            coord.col < grid[coord.row].size
        )
    }

    private fun isPeak(coord: Coord): Boolean {
        return grid[coord.row][coord.col] == 9
    }
}

val depthMap = DepthMap(File("input"))

fun part1(): Int {
    val lowPoints = depthMap.lowPoints()
    val riskLevels = lowPoints.map { depthMap.grid[it.row][it.col] + 1 }
    return riskLevels.fold(0) { acc, it -> acc + it }
}

fun part2(): Int {
    val basinSizes = depthMap.findBasins().map { it.size }
    val biggestThree = basinSizes.sortedByDescending { it }.take(3)
    return biggestThree.fold(1) { acc, it -> acc * it }
}

println("Part 1 Result: \n${part1()}\n")
println("Part 2 Result: \n${part2()}")
