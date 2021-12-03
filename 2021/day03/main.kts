import java.io.File

class DiagnosticReport(val diagnostics: List<String>) {
    val diagnosticLength = diagnostics.first().length

    val gammaRate: UInt =
        (0 until diagnosticLength)
            .map { mostCommonAt(diagnostics, it) }
            .joinToString("")
            .toUInt(2)

    val epsilonRate: UInt =
        (0 until diagnosticLength)
            .map { leastCommonAt(diagnostics, it) }
            .joinToString("")
            .toUInt(2)

    val oxygenGeneratorRating: UInt =
        (0 until diagnosticLength)
            .fold(diagnostics, { coll, index ->
                filterBitCriteria(coll, index, { mostCommonAt(coll, it) })
            })
            .first()
            .toUInt(2)

    val co2ScrubberRating: UInt =
        (0 until diagnosticLength)
            .fold(diagnostics, {coll, index -> 
                filterBitCriteria(coll, index, {leastCommonAt(coll, it) })
            })
            .first()
            .toUInt(2)

    private fun filterBitCriteria(collection: List<String>, index: Int, criteriaFinder: (Int) -> Char): List<String> {
        val targetBit = criteriaFinder(index)
        return collection.filter { it[index] == targetBit }
    }

    private fun mostCommonAt(collection: List<String>, index: Int): Char {
        val counts = countsAt(collection, index)
        if (counts['0'] == counts['1'])
            return '1'
        else
            return counts.maxByOrNull { it.value }?.key!!
    }

    private fun leastCommonAt(collection: List<String>, index: Int): Char {
        val counts = countsAt(collection, index)
        if (counts['0'] == counts['1'])
            return '0'
        else
            return counts.minByOrNull { it.value }?.key!!
    }

    private fun countsAt(collection: List<String>, index: Int): Map<Char, Int> {
        return collection
            .groupingBy { it[index] }
            .eachCount()
    }
}

val report = DiagnosticReport(File("input").readLines())
println("Part 1 Result: \n${report.gammaRate * report.epsilonRate}\n")
println("Part 2 Result: \n${report.oxygenGeneratorRating * report.co2ScrubberRating}")
