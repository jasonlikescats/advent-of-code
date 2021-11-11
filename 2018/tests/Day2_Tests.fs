module Day2_Tests

open InventoryManagementSystem
open System
open Xunit

[<Fact>]
let ``Day 2 Part 1 - sample input ``() =
    let input = [
        "abcdef";
        "bababc";
        "abbcde";
        "abcccd";
        "aabcdd";
        "abcdee";
        "ababab"]
    let checksum = CalculateChecksum input
    Assert.Equal(12, checksum)

[<Fact>]
let ``Day 2 Part 1 - id checksum from file``() =
    let checksum =
        System.IO.File.ReadLines "../../../input/day2.txt"
        |> CalculateChecksum
    Assert.Equal(7688, checksum)