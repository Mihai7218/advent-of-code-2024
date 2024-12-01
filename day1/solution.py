def part1(l1, l2):
    pairs = [(l1[i], l2[i]) for i in range(len(l1))]
    s = 0
    for pair in pairs:
        s += abs((pair[0]-pair[1]))
    print(s)

def part2(l1, l2):
    i = 0
    j = 0
    n = len(l1)
    result = 0
    while (i < n and j < n):
        if l1[i] > l2[j]:
            j += 1
        elif l1[i] == l2[j]:
            result += int(l1[i])
            j += 1
        elif l1[i] < l2[j]:
            i += 1
    print(result)



f = open("input", "r")

content = f.read().splitlines()

split = [(line.split("   ")[0], line.split("   ")[1]) for line in content]

l1 = sorted([int(pair[0]) for pair in split])
l2 = sorted([int(pair[1]) for pair in split])

part1(l1, l2)
part2(l1, l2)
