open System
open FrequencyAggregator

[<EntryPoint>]
let main argv =
    let filename = "input.txt"
    
    let dupe = 
        FrequencyAggregator.NumberListFromFile filename
        |> Seq.toList
        |> FrequencyAggregator.FindFirstDuplicateSum

    printfn "===\nResult = %d\n" dupe
    0 // return an integer exit code
