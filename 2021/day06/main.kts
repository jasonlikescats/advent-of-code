import java.io.File

class Ocean(initialStates: List<Int>) {
    private var fishCount = hashMapOf<Int, Long>()

    init {
        initialStates.forEach {
            val count = fishCount.getOrDefault(it, 0)
            fishCount[it] = count + 1
        }
    }

    fun step() {
        var updated = hashMapOf<Int, Long>()

        updated[0] = fishCount.getOrDefault(1, 0)
        updated[1] = fishCount.getOrDefault(2, 0)
        updated[2] = fishCount.getOrDefault(3, 0)
        updated[3] = fishCount.getOrDefault(4, 0)
        updated[4] = fishCount.getOrDefault(5, 0)
        updated[5] = fishCount.getOrDefault(6, 0)
        updated[6] = fishCount.getOrDefault(0, 0) + fishCount.getOrDefault(7, 0)
        updated[7] = fishCount.getOrDefault(8, 0)
        updated[8] = fishCount.getOrDefault(0, 0)

        fishCount = updated
    }

    fun total(): Long {
        return fishCount.values.sum()
    }
}


fun reproduce(days: Int): Long {
    val initialStates = File("input")
        .readText()
        .split(",")
        .map { it.toInt() }

    val ocean = Ocean(initialStates)
    for (day in 0 until days) { ocean.step() }
    return ocean.total()
}

println("Part 1 Result: \n${reproduce(80)}\n")
println("Part 2 Result: \n${reproduce(256)}")
