import java.io.File

class Display(inputSignals: List<String>, val outputs: List<String>) {
    val decoded: HashMap<String, Int>
    
    init {
        var signals = inputSignals.toMutableList()

        // 1 => only 2 digit number
        val one = deduceBySoleLength(signals, 2)

        // 4 => only 4 digit number
        val four = deduceBySoleLength(signals, 4)

        // 7 => only 3 digit number
        val seven = deduceBySoleLength(signals, 3)

        // 8 => only 7 digit number
        val eight = deduceBySoleLength(signals, 7)

        // 6 => 6 digit number missing a character from "1"
        val six = deduceByLengthWhere(signals, 6) { signal ->
            !(signal.contains(one[0]) && signal.contains(one[1]))
        }

        // 9 => 6 digit number containing all the characters from "4"
        val nine = deduceByLengthWhere(signals, 6) { signal ->
            four.all { signal.contains(it) }
        }

        // 0 => remaining 6 digit number
        val zero = deduceBySoleLength(signals, 6)

        // 3 => 5 digit number containing all the characters from "1"
        val three = deduceByLengthWhere(signals, 5) { signal ->
            one.all { signal.contains(it) }
        }

        // 5 => 5 digit number that is a subset of "9"
        val five = deduceByLengthWhere(signals, 5) { signal ->
            signal.all { nine.contains(it) }
        }

        // 2 => remaining 5 digit number
        val two = deduceBySoleLength(signals, 5)

        decoded = hashMapOf(
            sortChars(zero) to 0,
            sortChars(one) to 1,
            sortChars(two) to 2,
            sortChars(three) to 3,
            sortChars(four) to 4,
            sortChars(five) to 5,
            sortChars(six) to 6,
            sortChars(seven) to 7,
            sortChars(eight) to 8,
            sortChars(nine) to 9
        )
    }

    fun outputUniquesCount(): Int {
        return outputs.count { output ->
            when (output.length) {
                2 -> true // 1
                4 -> true // 4
                3 -> true // 7
                7 -> true // 8
                else -> false
            }
        }
    }

    fun decodedOutput(): ULong {
        return outputs
            .map { decoded[sortChars(it)] }
            .joinToString("")
            .toULong()
    }

    private fun deduceBySoleLength(signals: MutableList<String>, length: Int): String {
        return deduceByLengthWhere(signals, length) { _ -> true }
    }

    private fun deduceByLengthWhere(signals: MutableList<String>, length: Int, pred: (String) -> Boolean): String {
        val result = signals.find {
            it.length == length && pred(it)
        }!!
        signals.remove(result)
        return result
    }

    private fun sortChars(string: String): String {
        return string.toCharArray().sorted().joinToString("")
    }
}

val displays = File("input").readLines().map { line ->
    val split = line.split("|")
    val signals = split[0].split(" ")
    val outputs = split[1].drop(1).split(" ")
    Display(signals, outputs)
}

fun part1(): Int {
    return displays.fold(0) { acc, disp -> acc + disp.outputUniquesCount() }
}

fun part2(): ULong {
    return displays.fold(0UL) { acc, disp -> acc + disp.decodedOutput() }
}

println("Part 1 Result: \n${part1()}\n")
println("Part 2 Result: \n${part2()}")
