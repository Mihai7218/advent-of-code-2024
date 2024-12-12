require 'pqueue'

Pair = Struct.new(:first, :second)

def part_1(input)
    i = 0
    j = input.length-1
    left_to_put = 0
    index = 0
    result = 0
    if j % 2 == 1
        j -= 1
    end
    while i <= j
        if i % 2 == 0
            result += ((index+input[i]) * (index+input[i]-1)/2)*(i/2) - ((index-1)*index/2)*(i/2)
            index += input[i]
        else
            space_left = input[i]
            while space_left > 0
                if left_to_put == 0
                    left_to_put = input[j]
                    j -= 2
                end
                if left_to_put <= space_left
                    result += ((index+left_to_put-1) * (index+left_to_put)/2)*(j/2+1) - ((index-1)*index/2)*(j/2+1)
                    index += left_to_put
                    space_left -= left_to_put
                    left_to_put = 0
                else
                    result += ((index+space_left) * (index+space_left-1)/2)*(j/2+1) - ((index-1)*index/2)*(j/2+1)
                    index += space_left
                    left_to_put -= space_left
                    space_left = 0
                end 
            end
        end
        i += 1
    end
    if left_to_put > 0
        result += ((index+left_to_put-1) * (index+left_to_put)/2)*(j/2+1) - ((index-1)*index/2)*(j/2+1)
    end
    puts "Part 1: #{result}"
end

def part_2(input)
    index = 0
    result = 0
    pqs = Array.new(10) { PQueue.new { |a,b| a.first > b.first}} 
    visited = Set.new
    i = 0
    while i < input.length 
        val = input[i]
        j = val
        while j < 10
            pqs[j].push(Pair.new(i/2, val))
            j += 1
        end
        i += 2
    end
    i = 0
    while i < input.length 
        if i % 2 == 0 && !visited.include?(i/2)
            result += ((index+input[i]) * (index+input[i]-1)/2)*(i/2) - ((index-1)*index/2)*(i/2)
            visited.add(i/2)
            index += input[i]
        else
            space_left = input[i]
            while space_left > 0
                j = space_left
                val = 0
                while j > 0
                    if !pqs[j].empty? && pqs[j].top.first > i/2 && !visited.include?(pqs[j].top.first)
                        val = pqs[j].pop
                        break
                    elsif !pqs[j].empty? && visited.include?(pqs[j].top.first)
                        pqs[j].pop
                    elsif !pqs[j].empty?
                        pqs[j].clear
                        j -= 1
                    else
                        j -= 1
                    end
                end
                if j == 0
                    index += space_left
                    space_left = 0
                    break
                end
                result += ((index+val.second) * (index+val.second-1)/2)*val.first - ((index-1)*index/2)*val.first
                visited.add(val.first)
                index += val.second
                space_left -= val.second
            end
        end
        i += 1
    end
    puts "Part 2: #{result}"
end

f = File.open('example', 'r')
input = f.read.chars.map { |c| Integer(c) }
f.close
part_1(input)
part_2(input)