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

        let runningSum = Seq.scan (+) 0 infiniteSource

        let mutable cache = Set.empty
        let cacheIfNotFound value =
            let found = cache.Contains value
            if not found then
                cache <- cache.Add value
            found

        runningSum
        |> Seq.find cacheIfNotFound

    let NumberListFromFile path =
        File.ReadLines(path)
        |> Seq.map Int32.Parse