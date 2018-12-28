open System
open FrequencyAggregator

[<EntryPoint>]
let main argv =
    let filename = "input.txt"

    let dupe = 
        NumberListFromFile filename
        |> FindFirstDuplicateSum

    printfn "%d" dupe
    0 // return an integer exit code
