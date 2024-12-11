module ITSet = Set.Make(struct 
type t = int * int
let compare = compare  
end)

let funct pair_of_pairs result_set start repeats = 
  if (fst pair_of_pairs) != (snd pair_of_pairs) then 
  let diff_x = abs (fst (fst pair_of_pairs) - fst (snd pair_of_pairs)) in
  let diff_y = abs (snd (fst pair_of_pairs) - snd (snd pair_of_pairs)) in 
  let min_x = min (fst (fst pair_of_pairs)) (fst (snd pair_of_pairs)) in 
  let min_y = min (snd (fst pair_of_pairs)) (snd (snd pair_of_pairs)) in 
  let max_x = max (fst (fst pair_of_pairs)) (fst (snd pair_of_pairs)) in 
  let max_y = max (snd (fst pair_of_pairs)) (snd (snd pair_of_pairs)) in 
  for i = start to repeats do
    match (fst pair_of_pairs) with 
    | (x, y) when x = min_x && y = min_y -> result_set := ITSet.add (min_x-i*diff_x, min_y-i*diff_y) !result_set
    | (x, y) when x = min_x && y = max_y -> result_set := ITSet.add (min_x-i*diff_x, max_y+i*diff_y) !result_set
    | (x, y) when x = max_x && y = min_y -> result_set := ITSet.add (max_x+i*diff_x, min_y-i*diff_y) !result_set
    | (x, y) when x = max_x && y = max_y -> result_set := ITSet.add (max_x+i*diff_x, max_y+i*diff_y) !result_set
    | _ -> ();
    match (snd pair_of_pairs) with 
    | (x, y) when x = min_x && y = min_y -> result_set := ITSet.add (min_x-i*diff_x, min_y-i*diff_y) !result_set
    | (x, y) when x = min_x && y = max_y -> result_set := ITSet.add (min_x-i*diff_x, max_y+i*diff_y) !result_set
    | (x, y) when x = max_x && y = min_y -> result_set := ITSet.add (max_x+i*diff_x, min_y-i*diff_y) !result_set
    | (x, y) when x = max_x && y = max_y -> result_set := ITSet.add (max_x+i*diff_x, max_y+i*diff_y) !result_set
    | _ -> ();
  done

let () =
  let hash_map = Hashtbl.create 50 in
  let input_stream = open_in "input" in
  try 
    let i = ref 0 in
    while true do
      let line = input_line input_stream in
      String.iteri (fun j c -> 
        match c with
        | '.' -> ()
        | _ -> Hashtbl.add hash_map c (!i, j)
      ) line;
      incr i;
    done;
    with | End_of_file ->
      close_in_noerr input_stream;
  
  let result_set_1 = ref ITSet.empty in
  let result_set_2 = ref ITSet.empty in
  let pairs = Seq.map (fun c -> Hashtbl.find_all hash_map c) (Hashtbl.to_seq_keys hash_map) in
  let pairs_of_pairs = Seq.map (fun list_of_pairs ->
    Seq.flat_map(fun pair_1 -> 
      Seq.map(fun pair_2 -> 
        (pair_1, pair_2)) (List.to_seq list_of_pairs)) (List.to_seq list_of_pairs)) pairs in
  Seq.iter (fun x -> 
    Seq.iter (fun pairs_of_pairs -> funct pairs_of_pairs result_set_1 1 1) x
  ) pairs_of_pairs;
  Seq.iter (fun x -> 
    Seq.iter (fun pairs_of_pairs -> funct pairs_of_pairs result_set_2 0 50) x
  ) pairs_of_pairs;
  result_set_1 := ITSet.filter (fun (x, y) -> x >= 0 && y >= 0 && x < 50 && y < 50) !result_set_1;
  result_set_2 := ITSet.filter (fun (x, y) -> x >= 0 && y >= 0 && x < 50 && y < 50) !result_set_2;
  Printf.printf "Part 1: %d\n" (ITSet.cardinal !result_set_1);
  Printf.printf "Part 2: %d\n" (ITSet.cardinal !result_set_2);