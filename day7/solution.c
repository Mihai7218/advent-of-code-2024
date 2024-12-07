#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>

typedef struct Operation {
    int64_t total;
    int64_t *elements;
} Operation;

int64_t concatenate(int64_t acc, int64_t element) {
    int digits = 0;
    int el_copy = element;
    while (el_copy > 0) {
        el_copy /= 10;
        digits++;
    }
    return (acc * (int64_t) pow(10, digits)) + element;
}

int try_all_part_1(int64_t *elements, int64_t goal, int64_t acc, int i) {
    if (i == elements[0]) return (acc == goal);
    if (i == 1) return try_all_part_1(elements, goal, elements[1], i+1);
    return try_all_part_1(elements, goal, acc+elements[i], i+1) 
        || try_all_part_1(elements, goal, acc*elements[i], i+1);
}

int try_all_part_2(int64_t *elements, int64_t goal, int64_t acc, int i) {
    if (i == elements[0]) return (acc == goal);
    if (i == 1) return try_all_part_2(elements, goal, elements[1], i+1);
    return try_all_part_2(elements, goal, acc+elements[i], i+1) 
        || try_all_part_2(elements, goal, acc*elements[i], i+1) 
        || try_all_part_2(elements, goal, concatenate(acc, elements[i]), i+1);
}

void solve(Operation *operations, int n) {
    int64_t total_1 = 0;
    int64_t total_2 = 0;
    for (int op_count = 0; op_count < n; op_count++) {
        Operation operation = operations[op_count];
        int64_t total_op = operation.total;
        int64_t *elements = operation.elements;
        if (try_all_part_1(elements, total_op, 0, 1)) {
            total_1 += total_op;
        }
        if (try_all_part_2(elements, total_op, 0, 1)) {
            total_2 += total_op;
        }
    }
    printf("Part 1: %ld\nPart 2: %ld\n", total_1, total_2);
}

int main() {
    FILE *f = fopen("input", "r");
    char *read_buffer = malloc(50);
    size_t size = 50;
    Operation *operations = malloc(850 * sizeof(Operation));
    int op_count = 0;
    while (1) {
        getline(&read_buffer, &size, f);
        char *copy = malloc(strlen(read_buffer) + 1);
        strcpy(copy, read_buffer);
        char *total = strtok(copy, ":");
        int64_t total_int = atoll(total);
        char *rest = strtok(NULL, " ");
        int64_t *elements = malloc(20 * sizeof(int64_t));  
        int i = 1;    
        while (rest != NULL) {
            elements[i] = atoll(rest);
            i++;
            rest = strtok(NULL, " ");
        }
        elements[0] = i;
        operations[op_count].total = total_int;
        operations[op_count].elements = elements;
        op_count++;
        free(copy);
        if (!strchr(read_buffer, '\n')) break;
    }
    solve(operations, op_count);
    fclose(f);
    while (op_count > 0) {
        free(operations[op_count-1].elements);
        op_count--;
    }
    free(operations);
    free(read_buffer);
    return 0;
}