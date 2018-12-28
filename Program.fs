open System
open System.IO

[<EntryPoint>]
let main argv =
    let filename = "input.txt"

    let sum =
        File.ReadLines(filename)
        |> Seq.map Int32.Parse
        |> Seq.sum

    printfn "%d" sum
    0 // return an integer exit code
