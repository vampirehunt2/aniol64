/*
 * parserParser.cs
 *
 * THIS FILE HAS BEEN GENERATED AUTOMATICALLY. DO NOT EDIT!
 */

using System.IO;

using PerCederberg.Grammatica.Runtime;

namespace aniol64.pl0plus {

    /**
     * <remarks>A token stream parser.</remarks>
     */
    internal class parserParser : RecursiveDescentParser {

        /**
         * <summary>An enumeration with the generated production node
         * identity constants.</summary>
         */
        private enum SynteticPatterns {
            SUBPRODUCTION_1 = 3001,
            SUBPRODUCTION_2 = 3002,
            SUBPRODUCTION_3 = 3003,
            SUBPRODUCTION_4 = 3004,
            SUBPRODUCTION_5 = 3005,
            SUBPRODUCTION_6 = 3006
        }

        /**
         * <summary>Creates a new parser with a default analyzer.</summary>
         *
         * <param name='input'>the input stream to read from</param>
         *
         * <exception cref='ParserCreationException'>if the parser
         * couldn't be initialized correctly</exception>
         */
        public parserParser(TextReader input)
            : base(input) {

            CreatePatterns();
        }

        /**
         * <summary>Creates a new parser.</summary>
         *
         * <param name='input'>the input stream to read from</param>
         *
         * <param name='analyzer'>the analyzer to parse with</param>
         *
         * <exception cref='ParserCreationException'>if the parser
         * couldn't be initialized correctly</exception>
         */
        public parserParser(TextReader input, parserAnalyzer analyzer)
            : base(input, analyzer) {

            CreatePatterns();
        }

        /**
         * <summary>Creates a new tokenizer for this parser. Can be overridden
         * by a subclass to provide a custom implementation.</summary>
         *
         * <param name='input'>the input stream to read from</param>
         *
         * <returns>the tokenizer created</returns>
         *
         * <exception cref='ParserCreationException'>if the tokenizer
         * couldn't be initialized correctly</exception>
         */
        protected override Tokenizer NewTokenizer(TextReader input) {
            return new parserTokenizer(input);
        }

        /**
         * <summary>Initializes the parser by creating all the production
         * patterns.</summary>
         *
         * <exception cref='ParserCreationException'>if the parser
         * couldn't be initialized correctly</exception>
         */
        private void CreatePatterns() {
            ProductionPattern             pattern;
            ProductionPatternAlternative  alt;

            pattern = new ProductionPattern((int) parserConstants.PL0PROGRAM,
                                            "PL0Program");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.PROGRAM, 1, 1);
            alt.AddProduction((int) parserConstants.CONST_DECLARATION, 0, 1);
            alt.AddProduction((int) parserConstants.VAR_DECLARATION, 0, 1);
            alt.AddProduction((int) parserConstants.PROC_DECLARATION, 0, -1);
            alt.AddProduction((int) parserConstants.BLOCK, 1, 1);
            alt.AddToken((int) parserConstants.TERMINATOR, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.NUMBER,
                                            "Number");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.DECNUMBER, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.HEXNUMBER, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.BINNUMBER, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.TYPE,
                                            "Type");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.INT, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.POINTER, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.BLOCK,
                                            "Block");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.BEGIN, 1, 1);
            alt.AddProduction((int) parserConstants.STATEMENT_LIST, 0, 1);
            alt.AddToken((int) parserConstants.END, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.STATEMENT_LIST,
                                            "StatementList");
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.STATEMENT, 1, 1);
            alt.AddProduction((int) parserConstants.STATEMENT, 0, -1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.CONST_DECLARATION,
                                            "ConstDeclaration");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.CONST, 1, 1);
            alt.AddProduction((int) SynteticPatterns.SUBPRODUCTION_1, 0, -1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.VAR_DECLARATION,
                                            "VarDeclaration");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.VAR, 1, 1);
            alt.AddProduction((int) SynteticPatterns.SUBPRODUCTION_2, 0, -1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.FORMAL_ARGUMENT_DECLARATION,
                                            "FormalArgumentDeclaration");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.LEFT_PAREN, 1, 1);
            alt.AddProduction((int) SynteticPatterns.SUBPRODUCTION_3, 0, 1);
            alt.AddProduction((int) SynteticPatterns.SUBPRODUCTION_4, 0, -1);
            alt.AddToken((int) parserConstants.RIGHT_PAREN, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.ACTUAL_PARAMETER_LIST,
                                            "ActualParameterList");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.LEFT_PAREN, 1, 1);
            alt.AddProduction((int) parserConstants.EXPRESSION, 1, 1);
            alt.AddProduction((int) SynteticPatterns.SUBPRODUCTION_5, 0, -1);
            alt.AddToken((int) parserConstants.RIGHT_PAREN, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.PROC_DECLARATION,
                                            "ProcDeclaration");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.PROC, 1, 1);
            alt.AddToken((int) parserConstants.IDENTIFIER, 1, 1);
            alt.AddProduction((int) parserConstants.FORMAL_ARGUMENT_DECLARATION, 0, 1);
            alt.AddProduction((int) parserConstants.BLOCK, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.FUNC_DECLARATION,
                                            "FuncDeclaration");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.FUNC, 1, 1);
            alt.AddToken((int) parserConstants.IDENTIFIER, 1, 1);
            alt.AddProduction((int) parserConstants.FORMAL_ARGUMENT_DECLARATION, 0, 1);
            alt.AddToken((int) parserConstants.COLON, 1, 1);
            alt.AddProduction((int) parserConstants.TYPE, 1, 1);
            alt.AddProduction((int) parserConstants.BLOCK, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.IF_STATEMENT,
                                            "IfStatement");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.IF, 1, 1);
            alt.AddProduction((int) parserConstants.CONDITION, 1, 1);
            alt.AddToken((int) parserConstants.THEN, 1, 1);
            alt.AddProduction((int) parserConstants.STATEMENT, 1, 1);
            alt.AddProduction((int) SynteticPatterns.SUBPRODUCTION_6, 0, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.WHILE_STATEMENT,
                                            "WhileStatement");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.WHILE, 1, 1);
            alt.AddProduction((int) parserConstants.CONDITION, 1, 1);
            alt.AddToken((int) parserConstants.DO, 1, 1);
            alt.AddProduction((int) parserConstants.STATEMENT, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.FOR_STATEMENT,
                                            "ForStatement");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.FOR, 1, 1);
            alt.AddProduction((int) parserConstants.VAR_ASSIGNMENT, 1, 1);
            alt.AddToken((int) parserConstants.TO, 1, 1);
            alt.AddProduction((int) parserConstants.EXPRESSION, 1, 1);
            alt.AddToken((int) parserConstants.DO, 1, 1);
            alt.AddProduction((int) parserConstants.STATEMENT, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.RETURN_STATEMENT,
                                            "ReturnStatement");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.RETURN, 1, 1);
            alt.AddProduction((int) parserConstants.EXPRESSION, 0, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.STATEMENT,
                                            "Statement");
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.INSTRUCTION, 1, 1);
            alt.AddToken((int) parserConstants.SEPARATOR, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.BLOCK, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.IF_STATEMENT, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.WHILE_STATEMENT, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.FOR_STATEMENT, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.RETURN_STATEMENT, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.INSTRUCTION,
                                            "Instruction");
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.VAR_ASSIGNMENT, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.CALL, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.CONDITION,
                                            "Condition");
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.EXPRESSION, 1, 1);
            alt.AddProduction((int) parserConstants.CONDITIONAL_OPERATOR, 1, 1);
            alt.AddProduction((int) parserConstants.EXPRESSION, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.CONDITIONAL_OPERATOR,
                                            "ConditionalOperator");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.EQUAL, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.NOTEQUAL, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.GREATER, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.LESSER, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.GREATEREQUAL, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.LESSEREQUAL, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.CALL,
                                            "Call");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.IDENTIFIER, 1, 1);
            alt.AddProduction((int) parserConstants.ACTUAL_PARAMETER_LIST, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.VAR_ASSIGNMENT,
                                            "VarAssignment");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.IDENTIFIER, 1, 1);
            alt.AddToken((int) parserConstants.ASSIGNMENT, 1, 1);
            alt.AddProduction((int) parserConstants.EXPRESSION, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.EXPRESSION,
                                            "Expression");
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.TERM, 1, 1);
            alt.AddProduction((int) parserConstants.EXPRESSION_TAIL, 0, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.CALL, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.EXPRESSION_TAIL,
                                            "ExpressionTail");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.ADD, 1, 1);
            alt.AddProduction((int) parserConstants.EXPRESSION, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.SUB, 1, 1);
            alt.AddProduction((int) parserConstants.EXPRESSION, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.TERM,
                                            "Term");
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.FACTOR, 1, 1);
            alt.AddProduction((int) parserConstants.TERM_TAIL, 0, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.TERM_TAIL,
                                            "TermTail");
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.MUL, 1, 1);
            alt.AddProduction((int) parserConstants.TERM, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.DIV, 1, 1);
            alt.AddProduction((int) parserConstants.TERM, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.FACTOR,
                                            "Factor");
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.ATOM, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.LEFT_PAREN, 1, 1);
            alt.AddProduction((int) parserConstants.EXPRESSION, 1, 1);
            alt.AddToken((int) parserConstants.RIGHT_PAREN, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) parserConstants.ATOM,
                                            "Atom");
            alt = new ProductionPatternAlternative();
            alt.AddProduction((int) parserConstants.NUMBER, 1, 1);
            pattern.AddAlternative(alt);
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.IDENTIFIER, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) SynteticPatterns.SUBPRODUCTION_1,
                                            "Subproduction1");
            pattern.Synthetic = true;
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.IDENTIFIER, 1, 1);
            alt.AddToken((int) parserConstants.EQUAL, 1, 1);
            alt.AddProduction((int) parserConstants.NUMBER, 1, 1);
            alt.AddToken((int) parserConstants.SEPARATOR, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) SynteticPatterns.SUBPRODUCTION_2,
                                            "Subproduction2");
            pattern.Synthetic = true;
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.IDENTIFIER, 1, 1);
            alt.AddToken((int) parserConstants.COLON, 1, 1);
            alt.AddProduction((int) parserConstants.TYPE, 1, 1);
            alt.AddToken((int) parserConstants.SEPARATOR, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) SynteticPatterns.SUBPRODUCTION_3,
                                            "Subproduction3");
            pattern.Synthetic = true;
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.IDENTIFIER, 1, 1);
            alt.AddToken((int) parserConstants.COLON, 1, 1);
            alt.AddProduction((int) parserConstants.TYPE, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) SynteticPatterns.SUBPRODUCTION_4,
                                            "Subproduction4");
            pattern.Synthetic = true;
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.COMMA, 1, 1);
            alt.AddToken((int) parserConstants.IDENTIFIER, 1, 1);
            alt.AddToken((int) parserConstants.COLON, 1, 1);
            alt.AddProduction((int) parserConstants.TYPE, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) SynteticPatterns.SUBPRODUCTION_5,
                                            "Subproduction5");
            pattern.Synthetic = true;
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.COMMA, 1, 1);
            alt.AddProduction((int) parserConstants.EXPRESSION, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);

            pattern = new ProductionPattern((int) SynteticPatterns.SUBPRODUCTION_6,
                                            "Subproduction6");
            pattern.Synthetic = true;
            alt = new ProductionPatternAlternative();
            alt.AddToken((int) parserConstants.ELSE, 1, 1);
            alt.AddProduction((int) parserConstants.STATEMENT, 1, 1);
            pattern.AddAlternative(alt);
            AddPattern(pattern);
        }
    }
}
