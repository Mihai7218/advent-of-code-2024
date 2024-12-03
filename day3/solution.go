package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func part1(input string) {
	var result = 0
	regex := regexp.MustCompile(`mul\((\d{1,3}),(\d{1,3})\)`)
	matches := regex.FindAllStringSubmatch(input, -1)
	for _, match := range matches {
		num1, _ := strconv.Atoi(match[1])
		num2, _ := strconv.Atoi(match[2])
		result += num1 * num2
	}
	fmt.Printf("Part 1: %d\n", result)
}

func part2(input string) {
	var result = 0
	regex := regexp.MustCompile(`mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)`)
	mulRegex := regexp.MustCompile(`mul\((\d{1,3}),(\d{1,3})\)`)
	doRegex := regexp.MustCompile(`do\(\)`)
	dontRegex := regexp.MustCompile(`don't\(\)`)
	var enabled = true
	matches := regex.FindAllStringSubmatch(input, -1)
	for _, match := range matches {
		if mulRegex.MatchString(match[0]) && enabled {
			num1, _ := strconv.Atoi(match[1])
			num2, _ := strconv.Atoi(match[2])
			result += num1 * num2
		} else if doRegex.MatchString(match[0]) {
			enabled = true
		} else if dontRegex.MatchString(match[0]) {
			enabled = false
		}
	}
	fmt.Printf("Part 2: %d\n", result)
}

func main() {
	input, _ := os.ReadFile("input")
	inputStr := string(input)
	part1(inputStr)
	part2(inputStr)
}
