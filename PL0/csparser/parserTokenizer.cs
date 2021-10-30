/*
 * parserTokenizer.cs
 *
 * THIS FILE HAS BEEN GENERATED AUTOMATICALLY. DO NOT EDIT!
 */

using System.IO;

using PerCederberg.Grammatica.Runtime;

namespace aniol64.pl0plus {

    /**
     * <remarks>A character stream tokenizer.</remarks>
     */
    internal class parserTokenizer : Tokenizer {

        /**
         * <summary>Creates a new tokenizer for the specified input
         * stream.</summary>
         *
         * <param name='input'>the input stream to read</param>
         *
         * <exception cref='ParserCreationException'>if the tokenizer
         * couldn't be initialized correctly</exception>
         */
        public parserTokenizer(TextReader input)
            : base(input, false) {

            CreatePatterns();
        }

        /**
         * <summary>Initializes the tokenizer by creating all the token
         * patterns.</summary>
         *
         * <exception cref='ParserCreationException'>if the tokenizer
         * couldn't be initialized correctly</exception>
         */
        private void CreatePatterns() {
            TokenPattern  pattern;

            pattern = new TokenPattern((int) parserConstants.ADD,
                                       "ADD",
                                       TokenPattern.PatternType.STRING,
                                       "+");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.SUB,
                                       "SUB",
                                       TokenPattern.PatternType.STRING,
                                       "-");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.MUL,
                                       "MUL",
                                       TokenPattern.PatternType.STRING,
                                       "*");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.DIV,
                                       "DIV",
                                       TokenPattern.PatternType.STRING,
                                       "/");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.LEFT_PAREN,
                                       "LEFT_PAREN",
                                       TokenPattern.PatternType.STRING,
                                       "(");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.RIGHT_PAREN,
                                       "RIGHT_PAREN",
                                       TokenPattern.PatternType.STRING,
                                       ")");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.DECNUMBER,
                                       "DECNUMBER",
                                       TokenPattern.PatternType.REGEXP,
                                       "[-]?[0-9]+");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.BINNUMBER,
                                       "BINNUMBER",
                                       TokenPattern.PatternType.REGEXP,
                                       "%[0-1]+");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.HEXNUMBER,
                                       "HEXNUMBER",
                                       TokenPattern.PatternType.REGEXP,
                                       "$[0-9A-F]+");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.IDENTIFIER,
                                       "IDENTIFIER",
                                       TokenPattern.PatternType.REGEXP,
                                       "[a-z][a-zA-Z0-9]*");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.WHITESPACE,
                                       "WHITESPACE",
                                       TokenPattern.PatternType.REGEXP,
                                       "[ \\t\\n\\r]+");
            pattern.Ignore = true;
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.PROGRAM,
                                       "PROGRAM",
                                       TokenPattern.PatternType.STRING,
                                       "program");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.BEGIN,
                                       "BEGIN",
                                       TokenPattern.PatternType.STRING,
                                       "begin");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.END,
                                       "END",
                                       TokenPattern.PatternType.STRING,
                                       "end");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.PROC,
                                       "PROC",
                                       TokenPattern.PatternType.STRING,
                                       "procedure");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.FUNC,
                                       "FUNC",
                                       TokenPattern.PatternType.STRING,
                                       "function");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.RETURN,
                                       "RETURN",
                                       TokenPattern.PatternType.STRING,
                                       "return");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.VAR,
                                       "VAR",
                                       TokenPattern.PatternType.STRING,
                                       "var");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.CONST,
                                       "CONST",
                                       TokenPattern.PatternType.STRING,
                                       "const");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.IF,
                                       "IF",
                                       TokenPattern.PatternType.STRING,
                                       "if");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.THEN,
                                       "THEN",
                                       TokenPattern.PatternType.STRING,
                                       "then");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.ELSE,
                                       "ELSE",
                                       TokenPattern.PatternType.STRING,
                                       "else");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.WHILE,
                                       "WHILE",
                                       TokenPattern.PatternType.STRING,
                                       "while");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.DO,
                                       "DO",
                                       TokenPattern.PatternType.STRING,
                                       "do");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.FOR,
                                       "FOR",
                                       TokenPattern.PatternType.STRING,
                                       "for");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.TO,
                                       "TO",
                                       TokenPattern.PatternType.STRING,
                                       "to");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.INT,
                                       "INT",
                                       TokenPattern.PatternType.STRING,
                                       "int");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.POINTER,
                                       "POINTER",
                                       TokenPattern.PatternType.STRING,
                                       "pointer");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.SEPARATOR,
                                       "SEPARATOR",
                                       TokenPattern.PatternType.STRING,
                                       ";");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.TERMINATOR,
                                       "TERMINATOR",
                                       TokenPattern.PatternType.STRING,
                                       ".");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.COMMA,
                                       "COMMA",
                                       TokenPattern.PatternType.STRING,
                                       ",");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.ASSIGNMENT,
                                       "ASSIGNMENT",
                                       TokenPattern.PatternType.STRING,
                                       ":=");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.EQUAL,
                                       "EQUAL",
                                       TokenPattern.PatternType.STRING,
                                       "=");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.NOTEQUAL,
                                       "NOTEQUAL",
                                       TokenPattern.PatternType.STRING,
                                       "<>");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.GREATER,
                                       "GREATER",
                                       TokenPattern.PatternType.STRING,
                                       ">");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.LESSER,
                                       "LESSER",
                                       TokenPattern.PatternType.STRING,
                                       "<");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.GREATEREQUAL,
                                       "GREATEREQUAL",
                                       TokenPattern.PatternType.STRING,
                                       ">=");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.LESSEREQUAL,
                                       "LESSEREQUAL",
                                       TokenPattern.PatternType.STRING,
                                       "<=");
            AddPattern(pattern);

            pattern = new TokenPattern((int) parserConstants.COLON,
                                       "COLON",
                                       TokenPattern.PatternType.STRING,
                                       ":");
            AddPattern(pattern);
        }
    }
}
