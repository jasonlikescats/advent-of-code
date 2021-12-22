import java.io.File
import kotlin.system.measureTimeMillis

class Grid(dots: List<String>) {
    data class Coord(val col: Int, val row: Int)
    data class Cell(var marked: Boolean)

    val grid: MutableList<MutableList<Cell>>

    init {
        val coords = dots.map {
            val split = it.split(",")
            Coord(split[0].toInt(), split[1].toInt())
        }
        val xMax = coords.maxByOrNull { it.col }?.col ?: 0
        val yMax = coords.maxByOrNull { it.row }?.row ?: 0
        
        grid = MutableList(xMax + 1, {
            MutableList(yMax + 1, { Cell(false) })
        })

        coords.forEach { grid[it.col][it.row].marked = true }
    }

    fun print() {
        val colSize = grid.size
        val rowSize = grid.first().size
        for (row in 0 until rowSize) {
            for (col in 0 until colSize) {
                if (grid[col][row].marked) {
                    print("#")
                } else {
                    print(".")
                }
            }
            println()
        }
    }

    fun apply(instruction: Instruction) {
        when (instruction.dimension) {
            Instruction.Dimension.X -> foldAlongColumn(instruction.line)
            Instruction.Dimension.Y -> foldAlongRow(instruction.line)
        }
    }

    private fun foldAlongRow(foldRow: Int) {
        val rowSize = grid.first().size
        for (row in foldRow + 1 until rowSize) {
            val mirroredRow = 2 * foldRow - row
            if (mirroredRow < 0) {
                break
            }
            
            for (col in 0 until grid.size) {
                if (grid[col][row].marked) {
                    grid[col][mirroredRow].marked = true
                }
            }
        }

        for (row in foldRow until rowSize) {
            for (col in 0 until grid.size) {
                grid[col].removeAt(foldRow)
            }
        }
    }

    private fun foldAlongColumn(foldCol: Int) {
        for (col in foldCol + 1 until grid.size) {
            val mirroredCol = 2 * foldCol - col
            if (mirroredCol < 0) {
                break
            }

            for (row in 0 until grid[col].size) {
                if (grid[col][row].marked) {
                    grid[mirroredCol][row].marked = true
                }
            }
        }

        for (col in foldCol until grid.size) {
            grid.removeAt(foldCol)
        }
    }

    fun countDots(): Int {
        return allCells().count { it.marked }
    }

    private fun allCells(): List<Cell> {
        return grid.flatMap { it.asIterable() }
    }
}

class Instruction(text: String) {
    enum class Dimension { X, Y }

    val dimension: Dimension
    val line: Int

    init {
        val parts = text.substringAfterLast(' ').split("=")
        dimension = when (parts[0]) {
            "x" -> Dimension.X
            "y" -> Dimension.Y
            else -> throw Exception("Unexpected dimension ${parts[0]}")
        }
        line = parts[1].toInt()
    }
}

fun load(): Pair<Grid, List<Instruction>> {
    val fileParts = File("input").readText().split("\n\n")
    val coordLines = fileParts[0].split("\n")
    val instructionLines = fileParts[1].split("\n")

    val grid = Grid(coordLines)
    val instructions = instructionLines.map { Instruction(it) }
    return Pair(grid, instructions)
}

fun part1(): Int {
    val (grid, instructions) = load()
    grid.apply(instructions.first())
    return grid.countDots()
}

fun part2(): Grid {
    val (grid, instructions) = load()
    instructions.forEach { grid.apply(it) }
    return grid
}

var p1: Int
val t1 = measureTimeMillis { p1 = part1() }

var p2: Grid
val t2 = measureTimeMillis { p2 = part2() }

println("Part 1 Result ($t1 ms): \n$p1\n")
println("Part 2 Result ($t2 ms): \n")
p2.print()
