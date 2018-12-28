module FrequencyAggregator
    open System
    open System.IO

    let private lastOrZero (ls:int list) =
        match List.tryLast ls with
        | None -> 0
        | Some x -> x

    // TODO: Seq.scan pretty much allows for this
    let rec StepSums (numbers:int list)(result:int list) =
        match Seq.isEmpty <| numbers with
        | true -> result
        | false ->
            let currentStepSum = numbers.Head + (lastOrZero result)
            let newResult = List.append result [ currentStepSum ]
            StepSums numbers.Tail newResult

    let rec SumSequence (numbers:int list) =
        StepSums numbers []
        |> lastOrZero

    let NumberListFromFile path =
        File.ReadLines(path)
        |> Seq.map Int32.Parse
        |> Seq.toList

    let rec FindFirstDuplicateSum (numbers:int list) =
        let rec findFirstDuplicate (numbers:int list) (seenCache:int Set) =
            match List.isEmpty <| numbers with
            | true -> None
            | false ->
                let candidate = numbers.Head
                match Set.contains candidate seenCache with
                | true -> Some numbers.Head
                | false ->
                    let updatedCache = Set.add candidate seenCache
                    findFirstDuplicate numbers.Tail updatedCache

        let stepSums = StepSums numbers [ 0 ]

        let result = findFirstDuplicate stepSums Set.empty

        // TODO: This is dirty and can stack overflow on the wrong input.
        match result with
        | None -> FindFirstDuplicateSum (List.append numbers numbers)
        | Some x -> x 
