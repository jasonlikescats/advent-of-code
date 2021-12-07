import java.io.File
import kotlin.math.abs

val positions = File("input")
    .readText()
    .split(",")
    .map { it.toInt() }

fun cheapestFuelCostPosition(fuelCalculator: (Int, Int) -> Int): Int {
    val minPosition = positions.minOrNull()!!
    val maxPosition = positions.maxOrNull()!!
    
    val fuelCosts = (minPosition..maxPosition).map { targetPos ->
        positions.fold(0) { acc, currentPos ->
            acc + fuelCalculator(currentPos, targetPos)
        }
    }

    return fuelCosts.minOrNull()!!
}

fun part1(): Int {
    return cheapestFuelCostPosition { currentPos, targetPos ->
        abs(currentPos - targetPos)
    }
}

fun part2(): Int {
    return cheapestFuelCostPosition { currentPos, targetPos ->
        val delta = abs(currentPos - targetPos)
        (delta * (delta + 1)) / 2
    }
}

println("Part 1 Result: \n${part1()}\n")
println("Part 2 Result: \n${part2()}")
