const fs = require('node:fs');
const map = new Map();

function isCached(x, limit) {
    let entry = map.get(x);
    if (entry != null) {
        let currentValue = entry[limit];
        if (currentValue > 0) {
            return currentValue;
        }
    }
    return null;
}

function recurse(input, limit) {
    let stones = 0;
    if (limit == 0) {
        return input.length;
    }
    for (let x of input) {
        let cached = isCached(x, limit);
        if (cached != null) {
            stones += cached;
            continue;
        }
        let xString = x.toString();
        let xLen = xString.length;
        let result = 0;
        if (x == 0) {
            result = recurse([1], limit-1);
        }
        else if (xLen % 2 == 1) {
            result = recurse([x * 2024], limit-1);
        }
        else {
            let left = parseInt(xString.substring(0, xLen/2), 10);
            let right = parseInt(xString.substring(xLen/2, xLen), 10);
            result = recurse([left, right], limit-1);
        }
        let cache = map.get(x);
        if (cache == null) {
            map.set(x, Array.from({length: 76}, _ => 0));
            cache = map.get(x);
        }
        cache[limit] = result;
        stones += result;
    }
    return stones;
}

function part1(input) {
    console.log(`Part 1: ${recurse(input, 25)}`);
}

function part2(input) {
    console.log(`Part 1: ${recurse(input, 75)}`);
}

let input = fs.readFileSync("input", "utf8").split(" ").map(x => parseInt(x, 10));
part1(input);
part2(input);