use std::{collections::HashSet, fs, usize};

fn walk(maze: &Vec<Vec<u32>>, origin: (usize, usize), n: usize) -> (HashSet<(usize, usize)>, i32) {
    let mut result: HashSet<(usize, usize)> = HashSet::new();
    if maze[origin.0][origin.1] == 9 {
        result.insert(origin);
        return (result, 1);
    }
    let mut count = 0;
    let raw_neighbours = [
        (origin.0.checked_sub(1).unwrap_or(usize::MAX), origin.1),
        (origin.0, origin.1.checked_sub(1).unwrap_or(usize::MAX)),
        (origin.0 + 1, origin.1),
        (origin.0, origin.1 + 1),
    ];
    let neighbours = raw_neighbours.iter().filter(|pos| match pos {
        (usize::MAX, _) => false,
        (_, usize::MAX) => false,
        (a, _) if *a == n => false,
        (_, a) if *a == n => false,
        _ => true,
    });
    for neighbour in neighbours {
        if maze[origin.0][origin.1] + 1 == maze[neighbour.0][neighbour.1] {
            let ret_val = walk(maze, *neighbour, n);
            result.extend(ret_val.0);
            count += ret_val.1;
        }
    }
    return (result, count);
}

fn part_1(maze: &Vec<Vec<u32>>, origins: &Vec<(usize, usize)>, n: usize) {
    let mut score = 0;
    for origin in origins {
        let result = &walk(&maze, *origin, n);
        score += result.0.len();
    }
    println!("Part 1: {score}");
}

fn part_2(maze: &Vec<Vec<u32>>, origins: &Vec<(usize, usize)>, n: usize) {
    let mut score = 0;
    for origin in origins {
        let result = &walk(&maze, *origin, n);
        score += result.1;
    }
    println!("Part 2: {score}");
}

fn main() {
    let contents = fs::read_to_string("input").unwrap_or_default();
    let lines = contents.split("
");
    let maze = lines
        .map(|x| {
            x.chars()
                .map(|ch| ch.to_digit(10).unwrap_or_default())
                .collect::<Vec<u32>>()
        })
        .collect::<Vec<Vec<u32>>>();
    let origins = maze
        .iter()
        .enumerate()
        .flat_map(|(i, line)| {
            line.iter()
                .enumerate()
                .filter_map(move |(j, val)| match val {
                    0 => Some((i, j)),
                    _ => None,
                })
        })
        .collect::<Vec<(usize, usize)>>();
    let n = maze.len();
    part_1(&maze, &origins, n);
    part_2(&maze, &origins, n);
}
