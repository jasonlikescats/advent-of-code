import java.io.File

enum class Direction {
    FORWARD, DOWN, UP
}

data class Instruction(val direction: Direction, val magnitude: Int)

class Submarine {
    var horizontalPosition: Int = 0
    var depth: Int = 0
    var aim: Int = 0

    fun naiveFollowInstruction(instruction: Instruction) {
        when (instruction.direction) {
            Direction.FORWARD -> horizontalPosition += instruction.magnitude
            Direction.DOWN -> depth += instruction.magnitude
            Direction.UP -> depth -= instruction.magnitude
        }
    }

    fun followInstruction(instruction: Instruction) {
        when (instruction.direction) {
            Direction.FORWARD -> {
                horizontalPosition += instruction.magnitude
                depth += aim * instruction.magnitude
            }
            Direction.DOWN -> aim += instruction.magnitude
            Direction.UP -> aim -= instruction.magnitude
        }
    }
}

fun readInput(): List<Instruction> {
    return File("input").readLines().map {
        val lineParts = it.split(" ")
        Instruction(
            Direction.valueOf(lineParts[0].uppercase()),
            lineParts[1].toInt())
    }
}

fun part1(instructions: List<Instruction>): Int {
    var sub = Submarine()
    instructions.forEach { sub.naiveFollowInstruction(it) }
    return sub.horizontalPosition * sub.depth
}

fun part2(instructions: List<Instruction>): Int {
    var sub = Submarine()
    instructions.forEach { sub.followInstruction(it) }
    return sub.horizontalPosition * sub.depth
}

val instructions = readInput()
println("Part 1 Result: \n${part1(instructions)}\n")
println("Part 2 Result: \n${part2(instructions)}")
