module InventoryManagementSystem
    open System
    open System.IO

    let private DuplicateLetterCount (id:string) =
        Seq.groupBy Operators.id id
        |> Seq.map (snd >> Seq.length)
        |> Seq.sort

    let CalculateChecksum ids =
        let duplicateCounts =
            ids
            |> Seq.map DuplicateLetterCount
            |> Seq.toList

        let letterDuplicateCount duplicateNumber =
            let containsCount = Seq.contains duplicateNumber
            duplicateCounts
            |> Seq.where (fun x -> containsCount x)
            |> Seq.length

        let twoLetterDuplicateCount = letterDuplicateCount 2
        let threeLetterDuplicateCount = letterDuplicateCount 3

        twoLetterDuplicateCount * threeLetterDuplicateCount
