import java.io.File
import kotlin.system.measureTimeMillis

class Polymer(val template: String, val insertionRules: Map<String, String>) {
    var pairCounts = hashMapOf<String, Long>()

    init {
        template
            .windowed(2)
            .forEach { increment(it, 1L, pairCounts) }
    }

    fun process() {
        val updated = hashMapOf<String, Long>()
        pairCounts.forEach { pair, count ->
            val inserted = insertionRules[pair]!!
            increment("${pair[0]}$inserted", count, updated)
            increment("$inserted${pair[1]}", count, updated)
        }
        pairCounts = updated
    }

    fun charCounts(): Map<Char, Long> {
        val counts = hashMapOf<Char, Long>()
        pairCounts.forEach { pair, count ->
            increment(pair[0], count, counts)
            increment(pair[1], count, counts)
        }

        // adjust; we've double counted everything except the first and last char
        increment(template.first(), 1L, counts)
        increment(template.last(), 1L, counts)

        return counts.mapValues { it.value / 2L }
    }

    private fun<K> increment(key: K, size: Long, map: HashMap<K, Long>) {
        map.put(key, map.getOrDefault(key, 0L) + size)
    }
}

fun load(): Polymer {
    val fileParts = File("input").readText().split("\n\n")
    val template = fileParts[0]
    val rules = fileParts[1]
        .split("\n")
        .map {
            val parts = it.split(" -> ")
            parts[0] to parts[1]
        }
        .toMap()
    return Polymer(template, rules)
}

fun process(count: Int): Long {
    val polymer = load()
    repeat(count) { polymer.process() }

    val counts = polymer.charCounts()
    val mostCommonCount = counts.values.maxOrNull() ?: 0L
    val leastCommonCount = counts.values.minOrNull() ?: 0L

    return mostCommonCount - leastCommonCount
}

fun part1(): Long {
    return process(10)
}

fun part2(): Long {
    return process(40)
}

var p1: Long
val t1 = measureTimeMillis { p1 = part1() }

var p2: Long
val t2 = measureTimeMillis { p2 = part2() }

println("Part 1 Result ($t1 ms): \n$p1\n")
println("Part 2 Result ($t2 ms): \n$p2")
