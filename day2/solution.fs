open System.IO

let checker1 sequence = 
    let increasing = sequence |> Seq.pairwise |> Seq.forall(fun (a, b) -> a < b)
    let decreasing = sequence |> Seq.pairwise |> Seq.forall(fun (a, b) -> a > b)
    let lessThan3 = sequence |> Seq.pairwise |> Seq.forall(fun (a, b) -> (a-b) >= -3 && (a-b) <= 3)
    (increasing || decreasing) && lessThan3 

let checker2 sequence = 
    sequence 
        |> Seq.mapi(fun i x -> (i, x)) 
        |> Seq.exists(fun (idx, value) -> 
            (sequence 
                |> Seq.mapi(fun i x -> (i, x)) 
                |> Seq.filter(fun (i, x) -> i <> idx) 
                |> Seq.map(fun (i, x) -> x) 
                |> checker1))

let part1 split = 
    let result = split |> Seq.filter(checker1) 
    printfn "Part 1: %d" (Seq.length(result))
let part2 split = 
    let result = split |> Seq.filter(checker2)
    printfn "Part 2: %d" (Seq.length(result))

[<EntryPoint>]
let main argv =
    let fileLines = File.ReadLines("input")
    let split : int seq seq = fileLines |> Seq.map(fun x -> x.Split " ") |> Seq.map(fun x-> x |> Seq.map(fun y -> int y))
    part1 split |> ignore
    part2 split |> ignore
    0

