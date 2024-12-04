using System.Text.RegularExpressions;

class Solution {
    static void part1(string input) {
        int sum = 0;
        Regex vXMAS = new Regex("(?=X[^\0]{140}M[^\0]{140}A[^\0]{140}S)");
        Regex vSAMX = new Regex("(?=S[^\0]{140}A[^\0]{140}M[^\0]{140}X)");
        Regex dlXMAS = new Regex("(?=X[^\0]{139}M[^\0]{139}A[^\0]{139}S)");
        Regex dlSAMX = new Regex("(?=S[^\0]{139}A[^\0]{139}M[^\0]{139}X)");
        Regex drXMAS = new Regex("(?=X[^\0]{141}M[^\0]{141}A[^\0]{141}S)");
        Regex drSAMX = new Regex("(?=S[^\0]{141}A[^\0]{141}M[^\0]{141}X)");
        Regex hXMAS = new Regex("(?=XMAS)");
        Regex hSAMX = new Regex("(?=SAMX)");
        sum += vXMAS.Count(input);
        sum += vSAMX.Count(input);
        sum += dlXMAS.Count(input);
        sum += dlSAMX.Count(input);
        sum += drXMAS.Count(input);
        sum += drSAMX.Count(input);
        sum += hXMAS.Count(input);
        sum += hSAMX.Count(input);
        Console.WriteLine("Part 1: " + sum);
    }

    static void part2(string input) {
        int sum = 0;
        Regex crossMASSAM = new Regex("(?=M.S[^\0]{139}A[^\0]{139}M.S)");
        Regex crossSAMMAS = new Regex("(?=S.M[^\0]{139}A[^\0]{139}S.M)");
        Regex crossMASMAS = new Regex("(?=M.M[^\0]{139}A[^\0]{139}S.S)");
        Regex crossSAMSAM = new Regex("(?=S.S[^\0]{139}A[^\0]{139}M.M)");
        sum += crossMASSAM.Count(input);
        sum += crossSAMMAS.Count(input);
        sum += crossMASMAS.Count(input);
        sum += crossSAMSAM.Count(input);
        Console.WriteLine("Part 2: " + sum);
    }

    static void Main(string[] args) {
        string input = File.ReadAllText("input");
        part1(input);
        part2(input);
    }
}