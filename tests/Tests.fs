module Tests

open FrequencyAggregator
open System
open Xunit

[<Fact>]
let ``Day 1 Part 1 - sample input 1``() =
    let sum = SumSequence [1; -2; 3; 1]
    Assert.Equal(3, sum)
    
[<Fact>]
let ``Day 1 Part 1 - sample input 2``() =
    let sum = SumSequence [1; 1; 1]
    Assert.Equal(3, sum)

[<Fact>]
let ``Day 1 Part 1 - sample input 3``() =
    let sum = SumSequence [1; 1; -2]
    Assert.Equal(0, sum)

[<Fact>]
let ``Day 1 Part 1 - sample input 4``() =
    let sum = SumSequence [-1; -2; -3]
    Assert.Equal(-6, sum)

[<Fact>]
let ``Day 1 Part 1 - sum all frequencies in file`` () =
    let sum =
        NumberListFromFile "../../../input/day1.txt"
        |> SumSequence
    Assert.Equal(529, sum)

[<Fact>]
let ``Day 1 Part 2 - sample input 1``() =
    let firstDupe =
        [ +1; -1 ]
        |> FindFirstDuplicateSum
    Assert.Equal(0, firstDupe)

[<Fact>]
let ``Day 1 Part 2 - sample input 2``() =
    let firstDupe =
        [ 3; 3; 4; -2; -4 ]
        |> FindFirstDuplicateSum
    Assert.Equal(10, firstDupe)

[<Fact>]
let ``Day 1 Part 2 - sample input 3``() =
    let firstDupe =
        [ -6; 3; 8; 5; -6 ]
        |> FindFirstDuplicateSum
    Assert.Equal(5, firstDupe)

[<Fact>]
let ``Day 1 Part 2 - sample input 4``() =
    let firstDupe =
        [ 7; 7; -2; -7; -4 ]
        |> FindFirstDuplicateSum
    Assert.Equal(14, firstDupe)