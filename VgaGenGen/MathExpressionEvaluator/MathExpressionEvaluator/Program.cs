using System;
using System.Collections.Generic;

namespace MathExpressionEvaluator {

    class MathExpressionEvaluator {

        private string line;
        private List<string> tokens = new List<string>();
        int start;
        int stop;

        static void Main(string[] args) {
            MathExpressionEvaluator mee = new MathExpressionEvaluator();
            mee.loop();
        }

        private string nextToken() {
            string token = "";
            if (isDigit(line[0])) {
                int i = 0;
                while (i < line.Length && isDigit(line[i])) token += line[i++];

            } else {
                token = line.Substring(0, 1);
            }
            line = line.Substring(token.Length);
            return token;
        }

        private bool isDigit(char c) {
            return "0123456789".Contains(c);
        }

        private void tokenize() {
            tokens.Clear();
            while (line.Length > 0) {
                line = line.Trim();
                tokens.Add(nextToken());
            }
        }

        private void processSimpleExp() {
            for (int i = start; i <= stop; ++i) if (tokens[i] == "*") multiply(i - 1);
            for (int i = start; i <= stop; ++i) if (tokens[i] == "/") divide(i - 1);
            for (int i = start; i <= stop; ++i) if (tokens[i] == "+") add(i - 1);
            for (int i = start; i <= stop; ++i) if (tokens[i] == "-") subtract(i - 1);
        }

        private void processExp() {
            int i = 0;
            int openBracketIdx = -1;
            while (i < tokens.Count) {
                if (tokens[i] == "(") openBracketIdx = i;
                if (tokens[i] == ")") {
                    if (openBracketIdx == -1) throw new Exception();
                    start = openBracketIdx + 1;
                    stop = i - 1;
                    processSimpleExp();
                    tokens.RemoveAt(openBracketIdx + 2); // remove closing bracket
                    tokens.RemoveAt(openBracketIdx); // remove opening bracket
                    i = 0; // start over
                    openBracketIdx = -1;
                    continue;
                }
                if (i == tokens.Count - 1) {
                    start = 0;
                    stop = tokens.Count - 1;
                    processSimpleExp();
                }
                ++i;
            }
        }

        private void multiply(int i) {
            int arg1 = int.Parse(tokens[i]);
            int arg2 = int.Parse(tokens[i + 2]);
            int result = arg1 * arg2;
            tokens[i] = "" + result;
            tokens.RemoveAt(i + 2);
            tokens.RemoveAt(i + 1);
            stop -= 2;
        }

        private void divide(int i) {
            int arg1 = int.Parse(tokens[i]);
            int arg2 = int.Parse(tokens[i + 2]);
            int result = arg1 / arg2;
            tokens[i] = "" + result;
            tokens.RemoveAt(i + 2);
            tokens.RemoveAt(i + 1);
            stop -= 2;
        }

        private void add(int i) {
            int arg1 = int.Parse(tokens[i]);
            int arg2 = int.Parse(tokens[i + 2]);
            int result = arg1 + arg2;
            tokens[i] = "" + result;
            tokens.RemoveAt(i + 2);
            tokens.RemoveAt(i + 1);
            stop -= 2;
        }

        private void subtract(int i) {
            int arg1 = int.Parse(tokens[i]);
            int arg2 = int.Parse(tokens[i + 2]);
            int result = arg1 - arg2;
            tokens[i] = "" + result;
            tokens.RemoveAt(i + 2);
            tokens.RemoveAt(i + 1);
            stop -= 2;
        }

        private void loop() {
            while (true) {
                try {
                    line = Console.ReadLine();
                    if (line == "exit") break;
                    tokenize();
                    processExp();
                    Console.WriteLine(tokens[0]);
                } catch {
                    Console.WriteLine("Syntax error");
                }
            }
        }
    }
}
