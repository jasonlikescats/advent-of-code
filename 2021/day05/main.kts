import java.io.File
import kotlin.math.sign

data class Point(val x: Int, val y: Int)

class Line(val start: Point, val end: Point): Iterable<Point> {
    class LinePointsIterator(val start: Point, val end: Point): Iterator<Point> {
        var curr = start
        var atEnd = false
        
        override fun hasNext(): Boolean {
            if (atEnd) {
                return false // we were at the end last time, now we're past it
            } else if (curr.x == end.x && curr.y == end.y) {
                atEnd = true
            }
            return true
        }

        override fun next(): Point {
            val xDelta = end.x - curr.x
            val yDelta = end.y - curr.y
            val retValue = curr

            curr = Point(
                curr.x + xDelta.sign,
                curr.y + yDelta.sign
            )

            return retValue
        }
    }

    override fun iterator(): Iterator<Point> {
        return LinePointsIterator(start, end)
    }

    fun horizontal(): Boolean {
        return start.y == end.y
    }

    fun vertical(): Boolean {
        return start.x == end.x
    }
}

val pattern = Regex("""(\d+),(\d+) -> (\d+),(\d+)""")
val lines = File("input").readLines().map { line ->
    val (x1, y1, x2, y2) = pattern.find(line)!!.destructured
    Line(
        Point(x1.toInt(), y1.toInt()),
        Point(x2.toInt(), y2.toInt())
    )
}

fun buildVentMap(ventLines: List<Line>): HashMap<Point, Int> {
    var vents = HashMap<Point, Int>()
    ventLines.forEach { line ->
        line.forEach { point ->
            val currCount = vents.getOrElse(point, { 0 })
            vents[point] = currCount + 1
        }
    }
    return vents
}

fun countOverlaps(ventMap: HashMap<Point, Int>): Int {
    return ventMap.values.count { it > 1 }
}

fun part1(): Int {
    val horizOrVertLines = lines.filter { it.horizontal() || it.vertical() }
    return countOverlaps(buildVentMap(horizOrVertLines))
}

fun part2(): Int {
    return countOverlaps(buildVentMap(lines))
}

println("Part 1 Result: \n${part1()}\n")
println("Part 2 Result: \n${part2()}")
