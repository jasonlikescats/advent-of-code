module FrequencyAggregator
    open System
    open System.IO

    let private lastOrZero (ls:int seq) =
        match Seq.tryLast ls with
        | None -> 0
        | Some x -> x

    let rec SumSequence (numbers:int seq) =
        numbers
        |> Seq.scan (+) 0 
        |> lastOrZero

    let FindFirstDuplicateSum (numbers:int list) =
        let getAtModulo (collection:'a list) (index) =
            let wrappedIndex = index % collection.Length
            collection.Item wrappedIndex

        let infiniteSource = 
            getAtModulo numbers
            |> Seq.initInfinite

        let rec findFirstDuplicate (numbers:int seq) (seenCache:int Set) =
            let candidate = Seq.head numbers
            match Set.contains candidate seenCache with
            | true -> candidate
            | false ->
                if seenCache.Count % 100 = 0 then
                    printf "cache size is %d\n" seenCache.Count

                let updatedCache = Set.add candidate seenCache
                let tail = Seq.tail numbers
                findFirstDuplicate tail updatedCache

        let runningSum = Seq.scan (+) 0 infiniteSource

        findFirstDuplicate runningSum Set.empty

    let NumberListFromFile path =
        File.ReadLines(path)
        |> Seq.map Int32.Parse