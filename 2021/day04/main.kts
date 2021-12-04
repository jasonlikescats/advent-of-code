import java.io.File

class Board(serialized: String) {
    data class Cell(val value: Int, var called: Boolean)

    val grid: Array<Array<Cell>>
    private var winnerCache: Boolean

    init {
        val lines = serialized.split("\n")
        grid = lines.map { line ->
            line
                .split(" ")
                .filterNot { it.isBlank() }
                .map { Cell(it.toInt(), false) }
                .toTypedArray()
        }.toTypedArray()
        winnerCache = false
    }

    fun mark(draw: Int) {
        if (winnerCache) {
            return // skip marking the card if it's already a winner
        }

        grid.forEach { line ->
            line.forEach { cell ->
                if (cell.value == draw) {
                    cell.called = true
                }
            }
        }
    }

    fun isWinner(): Boolean {
        if (winnerCache) {
            return true
        }

        winnerCache = hasWinningRow() || hasWinningColumn()
        return winnerCache
    }

    fun score(lastDraw: Int): Int {
        if (!isWinner()) {
            throw Exception("Score is invalid unless board is a winner")
        }

        val unmarkedSum = grid.fold(0) { accLine, line ->
            val lineSum = line
                .filterNot { cell -> cell.called }
                .fold(0) { accCol, cell -> accCol + cell.value }
            accLine + lineSum
        }

        return lastDraw * unmarkedSum
    }

    private fun hasWinningRow(): Boolean {
        return grid.any { row ->
            row.all { it.called }
        }
    }

    private fun hasWinningColumn(): Boolean {
        val columns = grid.first().size
        return (0 until columns).any { colIdx ->
            grid
                .map { line -> line[colIdx].called }
                .all { it }
        }
    }
}

val inputChunks = File("input").readText().split("\n\n")

val draws: List<Int> = inputChunks.first().split(",").map { it.toInt() }
val boards: List<Board> = inputChunks.drop(1).map { Board(it) }

fun part1(): Int {
    var winner: Board? = null
    var draw: Int = -1

    for (index in 0 until draws.size) {
        draw = draws[index]
        boards.forEach { it.mark(draw) }
        
        winner = boards.firstOrNull { it.isWinner() }
        if (winner != null) {
            break
        }
    }

    return winner!!.score(draw)
}

fun part2(): Int {
    var lastWinner: Board? = null
    var draw: Int = -1

    var remainingBoards = boards
    for (index in 0 until draws.size) {
        draw = draws[index]

        remainingBoards.forEach { it.mark(draw) }
        remainingBoards = remainingBoards.filterNot { it.isWinner() }

        if (remainingBoards.size == 1) {
            lastWinner = remainingBoards.first()
        }

        if (lastWinner?.isWinner() == true) {
            break
        }
    }

    return lastWinner!!.score(draw)
}

println("Part 1 Result: \n${part1()}\n")
println("Part 2 Result: \n${part2()}")
