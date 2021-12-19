import java.io.File
import java.util.ArrayDeque
import kotlin.system.measureTimeMillis

enum class UnexpectedCloser(val closer: Char, val score: Int) {
    PAREN(')', 3),
    BRACKET(']', 57),
    BRACE('}', 1197),
    ANGLE('>', 25137);

    companion object {
        private val map = UnexpectedCloser.values().associateBy(UnexpectedCloser::closer)
        fun fromCloser(closer: Char): UnexpectedCloser? = map[closer]
    }
}

class Parser() {
    val stack = ArrayDeque<Char>()

    fun next(char: Char): UnexpectedCloser? {
        when (char) {
            '(', '[', '{', '<' -> stack.push(char)
            ')', ']', '}', '>' -> {
                val opener = stack.pop()
                if (char != closerFor(opener)) {
                    return UnexpectedCloser.fromCloser(char)
                }
            }
            else -> throw Exception("Invalid character $char")
        }

        return null
    }

    fun completionString(): String {
        val sb = StringBuilder(stack.size)
        while (!stack.isEmpty()) {
            val closer = closerFor(stack.pop())
            sb.append(closer)
        }
        return sb.toString()
    }

    private fun closerFor(opener: Char): Char {
        return when (opener) {
            '(' -> ')'
            '[' -> ']'
            '{' -> '}'
            '<' -> '>'
            else -> throw Exception("Invalid opener $opener")
        }
    }
}

val lines = File("input").readLines()

fun part1(): Int {
    val illegalClosers = lines.map { line ->
        val parser = Parser()
        line.firstNotNullOfOrNull { char -> parser.next(char) }
    }.filterNotNull()

    return illegalClosers.fold(0) { acc, curr -> acc + curr.score }
}

fun part2(): Long {
    val incompleteParsers = lines.map { line ->
        val parser = Parser()
        val illegalCloserResult = line.firstNotNullOfOrNull { char ->
            parser.next(char)
        }
        if (illegalCloserResult == null) {
            parser
        } else {
            null
        }
    }.filterNotNull()

    val completionStrings = incompleteParsers.map(Parser::completionString)

    val sortedScores = completionStrings.map { string ->
        string.fold(0L) { acc, curr ->
            val charScore = when(curr) {
                ')' -> 1
                ']' -> 2
                '}' -> 3
                '>' -> 4
                else -> throw Exception("Invalid closer $curr")
            }
            acc * 5 + charScore
        }
    }.sorted()

    return sortedScores[sortedScores.size / 2]
}

var p1: Int
val t1 = measureTimeMillis { p1 = part1() }

var p2: Long
val t2 = measureTimeMillis { p2 = part2() }

println("Part 1 Result ($t1 ms): \n$p1\n")
println("Part 2 Result ($t2 ms): \n$p2")
