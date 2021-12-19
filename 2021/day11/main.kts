import java.io.File
import kotlin.system.measureTimeMillis

class Octopus(var energy: Int) {
    var flashed: Boolean = false

    fun initializeStep() {
        // reset for this step
        flashed = false
    }

    fun increaseEnergy(): Boolean {
        energy += 1
        return checkFlashed()
    }

    fun finalizeStep() {
        if (energy > 9) {
            energy = 0
        }
    }

    private fun checkFlashed(): Boolean {
        if (flashed) {
            return false // already flashed this step
        }

        if (energy > 9) {
            flashed = true
        }

        return flashed
    }
}

class Grid(input: File) {
    data class Coord(val row: Int, val col: Int)
    data class Cell(val coord: Coord, val octopus: Octopus)

    val grid: Array<Array<Cell>>
    var flashCount: Long = 0

    init {
        val lines = input.readLines()
        grid = lines.mapIndexed { rowIdx, line ->
            line
                .mapIndexed { colIdx, value ->
                    val energy = value.toString().toInt()
                    val octopus = Octopus(energy)
                    val coord = Coord(rowIdx, colIdx) 
                    Cell(coord, octopus)
                }
                .toTypedArray()
        }.toTypedArray()
    }

    fun step() {
        var cells = allCells()
        cells.forEach { it.octopus.initializeStep() }

        do {
            cells = step(cells)
        } while (!cells.isEmpty())

        allCells().forEach { it.octopus.finalizeStep() }
    }

    fun allFlashed(): Boolean {
        return allCells().all { it.octopus.energy == 0 }
    }

    private fun allCells(): List<Cell> {
        return grid.flatMap { it.asIterable() }
    }

    private fun step(cells: List<Cell>): List<Cell> {
        val flashed = cells.filter { it.octopus.increaseEnergy() }
        
        flashCount += flashed.size

        val adjacentCells = flashed
            .flatMap { cell -> adjacent(cell.coord) }
            .map { coord -> grid[coord.row][coord.col] }
        
        return adjacentCells
    }

    private fun adjacent(coord: Coord): List<Coord> {
        return listOf<Coord>(
            Coord(coord.row - 1, coord.col - 1),
            Coord(coord.row - 1, coord.col),
            Coord(coord.row - 1, coord.col + 1),
            Coord(coord.row, coord.col + 1),
            Coord(coord.row + 1, coord.col + 1),
            Coord(coord.row + 1, coord.col),
            Coord(coord.row + 1, coord.col - 1),
            Coord(coord.row, coord.col - 1),
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
}

fun part1(): Long {
    val grid = Grid(File("input"))

    repeat(100) { grid.step() }

    return grid.flashCount
}

fun part2(): Long {
    val grid = Grid(File("input"))
    var index = 0L

    do {
        index += 1
        grid.step()
    } while (!grid.allFlashed())
    return index
}

var p1: Long
val t1 = measureTimeMillis { p1 = part1() }

var p2: Long
val t2 = measureTimeMillis { p2 = part2() }

println("Part 1 Result ($t1 ms): \n$p1\n")
println("Part 2 Result ($t2 ms): \n$p2")
