class Parser

	# Define la precedencia de los tokens o expresiones en LANSCII.
	# El orden de precedencia fue basada en el siguiente link:
	# http://help.adobe.com/es_ES/AS2LCR/Flash_10.0/help.html?content=00000115.html
	prechigh

		nonassoc PRNTS

		nonassoc NEGATION
		nonassoc UMINUS
		left MULTIPLY DIVISION PERCENT
		left PLUS MINUS

		nonassoc TRANSPOSITION
		nonassoc ROTATION
		left ET TILDE

		nonassoc LESS_THAN GREATER_THAN LESS_OR_EQUAL GREATER_OR_EQUAL
		right NOT_EQUAL EQUALS

		left AND
		left OR

		right ASSIGN
		left SEMICOLON

	preclow

	# Lista de tokens validos de LANSCII (dadas por el lexer).
	token READ WRITE TRUE FALSE IDENTIFIER NUMBER AT EXCLAMATION_MARK
		TWO_POINTS LCURLY RCURLY RPARENTHESIS LPARENTHESIS RBRACKET 
		LBRACKET PIPE SEMICOLON QUESTION_MARK MINUS ROTATION TRANSPOSITION
		NEGATION OR AND CANVAS GREATER_OR_EQUAL LESS_OR_EQUAL GREATER_THAN
		LESS_THAN NOT_EQUAL EQUALS COLON PERCENT PLUS MULTIPLY DIVISION

	# Define la gramatica libre de contexto que reconoce a LANSCII.
	rule

	#################################
	# Estructura general de LANSCII #
	#################################

		# Simbolo inicial: define un programa en LANSCII e incorpora el alcance.
		S
		: Scope			{result = S.new(val[0]); result.printAST(0)}
		;

		# Alcance: le quita la recursividad al simbolo inicial.
		Scope 
		: LCURLY Decl PIPE Inst RCURLY			{result = Scope.new(val[3])}
		| LCURLY Inst RCURLY					{result = Scope.new(val[1])}
		;

		# Declaraciones: define las declaraciones en un entorno (alcance).
		Decl
		: Type ListI		
		| Decl Type ListI	
		;

		# Tipos: define los diferentes tipos de variables presentes en LANSCII.
		Type
		: AT
		| EXCLAMATION_MARK
		| PERCENT
		;

		# Lista de identificadores de variables: define el nombre de variables.
		ListI
		: Var
		| ListI Var
		;

		# Instrucciones: define las instrucciones validas asociadas a un programa
		# => o subprograma en LANSCII.
		Inst
		: Inst SEMICOLON Inst 					{result = Instr.new(:INSTR , val[0], :INSTR , val[2])}
		| Assign 								{result = Instr.new(:ASSIGN , val[0])}
#		| Ident EQUALS Expr 	=ASSIGN
		| READ Var 								{result = Instr.new(:READ , val[1])}
		| WRITE Expr 							{result = Instr.new(:WRITE , val[1])}
		| Cond 									{result = Instr.new(:COND , val[0])}
#		| LPARENTHESIS Expr QUESTION_MARK Inst RPARENTHESIS
#		| LPARENTHESIS Expr QUESTION_MARK Inst COLON Inst RPARENTHESIS
		| ILoop 								{result = Instr.new(:IND_LOOP , val[0])}
#		| LBRACKET Expr PIPE Inst RBRACKET
		| DLoop 								{result = Instr.new(:DET_LOOP , val[0])}
#		| LBRACKET Expr TWO_POINTS Expr PIPE Inst RBRACKET 
#		| LBRACKET Ident COLON Expr TWO_POINTS Expr PIPE Inst RBRACKET
		| Scope									{result = Instr.new(:Scope , val[0])}
		;

		Assign
		: Var EQUALS Expr 						{result = Assign.new(:VARIABLE , val[0], :EXPRESSION, val[2])}
		;

		Cond
		: LPARENTHESIS Expr QUESTION_MARK Inst RPARENTHESIS 				{result = Cond.new(:CONDITION , val[1], :THEN , val[3])}
		| LPARENTHESIS Expr QUESTION_MARK Inst COLON Inst RPARENTHESIS		{result = Cond.new(:CONDITION , val[1], :THEN , val[3], :ELSE , val[5])}
		;

		ILoop
		: LBRACKET Expr PIPE Inst RBRACKET 		{result = ILoop.new(:WHILE , val[1], :DO , val[3])}
		;

		DLoop
		: LBRACKET Expr TWO_POINTS Expr PIPE Inst RBRACKET 				{result = DLoop.new(:VARIABLE, val[1], :EXPRESSION , val[3],:EXPRESSION, val[5])}
		| LBRACKET Var COLON Expr TWO_POINTS Expr PIPE Inst RBRACKET 	{result = DLoop.new(:VARIABLE, val[1], :EXPRESSION , val[3],:EXPRESSION, val[5], :INSTR , val[7])}
		;

		Var
		: Ident 		{result = Terms.new(:IDENTIFIER , val[0])}
		;

	##################################
	# Expresiones validas en LANSCII #
	##################################

		# Expresiones: define todas las expresiones recursivas en LANSCII.
		Expr 													
		: Term 												
		| Expr PLUS Expr 									{result = BinExp.new( "+", val[0], val[2])}
		| Expr MINUS Expr 									{result = BinExp.new( "-", val[0], val[2])}
		| Expr MULTIPLY Expr 								{result = BinExp.new( "*", val[0], val[2])}
		| Expr DIVISION Expr 								{result = BinExp.new( "/", val[0], val[2])}
		| Expr PERCENT Expr 								{result = BinExp.new( "%", val[0], val[2])}
		| MINUS Expr 	=UMINUS   							{result = UnaExp.new( "-" , val[0])}
		| LPARENTHESIS Expr RPARENTHESIS =PRNTS 			{result = ParExp.new( :EXPRESSION , val[1])}
		| Expr OR Expr   									{result = BinExp.new( "\/" , val[1])}
		| Expr AND Expr 									{result = BinExp.new( "/\\", val[0], val[2])}
		| Expr NEGATION 									{result = UnaExp.new( "-", val[0], val[2])}
		| Expr LESS_THAN Expr 								{result = BinExp.new( "<", val[0], val[2])}
		| Expr GREATER_THAN Expr 							{result = BinExp.new( ">", val[0], val[2])}
		| Expr LESS_OR_EQUAL Expr 							{result = BinExp.new( "<=", val[0], val[2])}
		| Expr GREATER_OR_EQUAL Expr 						{result = BinExp.new( ">=", val[0], val[2])}
		| Expr EQUALS Expr 									{result = BinExp.new( "=", val[0], val[2])}
		| Expr NOT_EQUAL Expr 								{result = BinExp.new( "!=", val[0], val[2])}
		| Expr TILDE Expr 									{result = BinExp.new( "~", val[0], val[2])}
		| Expr ET Expr 										{result = BinExp.new( "&", val[0], val[2])}
		| ROTATION Expr 									{result = UnaExp.new( "$", val[1])}
		| Expr TRANSPOSITION 								{result = UnaExp.new( "'", val[0])}
		;

		# Expresiones básicas: definen todas las expresiones hoja en LANSCII.
		Term
		: Bool 
		| Num 
		| Lien
		| Var
		;

		# Identificador: define el nombre de variables en LANSCII.
		Ident
		: IDENTIFIER 			{result = Terms.new(:IDENTIFIER , val[0])}
		;

		# Lienzos: define el tipo de los lienzos en LANSCII.
		Lien
		: CANVAS				{result = Terms.new(:CANVAS , val[0])}
		;

		# Numeros: define al tipo de los numeros en LANSCII.
		Num
		: NUMBER				{result = Terms.new(:NUMBER , val[0])}
		;

		# Booleanos: define al tipo de variables booleanas en LANSCII.
		Bool
		: TRUE					{result = Terms.new(:TRUE , val[0])}
		| FALSE					{result = Terms.new(:FALSE , val[0])}
		;
end

---- inner

require './lexer.rb'
require './ruleClasses.rb'

def initialize(lexer)
	@lexer = lexer
end

def next_token
	@lexer.next_token
end

def parse
	do_parse
end