#!/usr/bin/env ruby
=begin
 *  UNIVERSIDAD SIMÓN BOLÍVAR
 *  Archivo: tableVerification.rb
 *
 *  Contenido:
 *          Funciones para la verificacion de la tabla de
 *			simbolos.
 *
 *  Creado por:
 *			Genessis Sanchez	11-10935
 *          Daniela Socas		11-10979
 *
 *  Última modificación: 13 de Junio de 2015
=end

require './ruleClasses.rb'
require './symbolTable.rb'

$symTable = nil		# Tabla de simbolos.
$tableStack = []	# Pila de tablas.

################################################
# Manejo de la estructura general del programa #
################################################

# Manejador del programa principal.
def program_Handler(ast)
	scope_Handler(ast.scope)
end

# Manejador de alcances.
def scope_Handler(scope)
	# Asignación de una nueva tabla.
	symTableAux = SymbolTable.new($symTable)
	$symTable = symTableAux
	#Manejo de la estructura.
	declError = decl_Handler(scope.decl)
	puts "declError = #{declError}"
	instr_Handler(scope.inst)
	puts "instrError = #{instrError}"
	# Se empila la tabla en la pila.
	$tableStack << $symTable
	$symTable = $symTable.father
	# Si ya se analizo todo el programa, se imprimen cada
	# de las tablas.
	if ($symTable == nil)
		if (declError > 0)
			abort
		end
		$tableStack.reverse!
		$tableStack.each do |st|
			st.print_Table
		end
	end
end

# Manejador de declaraciones.
def decl_Handler(decl)
	result2 = 0
	case decl.type
	when :AT
		result1 = listI_Handler(:CANVAS, decl.listI)
#		return listI_Handler(:CANVAS, decl.listI)
	when :PERCENT
		result1 = listI_Handler(:NUMBER, decl.listI)
#		return listI_Handler(:NUMBER, decl.listI)
	when :EXCLAMATION_MARK
		result1 = listI_Handler(:BOOLEAN, decl.listI)
#		return listI_Handler(:BOOLEAN, decl.listI)
	end
	if (decl.decl != nil)
		result2 = decl_Handler(decl.decl)
	end
	return result1 + result2
end

# Manejador de lista de identificadores
def listI_Handler(type, listI)
	if !($symTable.contains(listI.id.term))
		$symTable.insert(listI.id.term, [type, nil])
		if (listI.listI != nil)
			return listI_Handler(type, listI.listI)
		end
		return 0
	else
		puts "ERROR: variable '#{listI.id.term}' was declared before" \
				" at the same scope."
		if (listI.listI != nil)
			return listI_Handler(type, listI.listI) + 1
		end
		return 1
	end
end

# Manejador de instrucciones
def instr_Handler(instr, iterVar=nil)
	case instr.opID[0]
	when :INSTR
		instr.branches.each do |i|
			instr_Handler(i,iterVar)
		end
	when :ASSIGN
		if iterVar != nil
			assign_Handler(instr.branches[0], iterVar)
		else
			assign_Handler(instr.branches[0])
		end
	when :READ
		read_Handler(instr)
	when :WRITE
		write_Handler(instr)
	when :CONDITIONAL_STATEMENT
		conditional_statment_Handler(instr.branches[0])
	when :IND_LOOP
		iLoop_Handler(instr.branches[0])
	when :DET_LOOP
		dLoop_Handler(instr.branches[0])
	when :SCOPE
		scope_Handler(instr.branches[0])
	end
end

############################################
# Manejo de las instrucciones del programa #
############################################

# Manejador de la instruccion ASSIGN.
def assign_Handler(assign, iterVar=nil)
	idVar = assign.branches[0].term
	if (idVar == iterVar)
		puts "ASSIGN ERROR: iterator '#{idVar}' cannot be modified."
		return 1
	end
	if ($symTable.lookup(idVar) == nil)
		puts "ASSIGN ERROR: variable '#{idVar}' has not been declared."
		return 1
	end
	typeVar = $symTable.lookup(idVar)[0]
	typeExpr = expression_Handler(assign.branches[1])
	if (typeVar != typeExpr)
		puts "ASSIGN ERROR: #{typeExpr} expression assigned to #{typeVar} "\
			"variable '#{idVar}'."
		return 1
	end
	return 0
end

# Manejador de la instruccion READ.
def read_Handler(read)
	idVar = read.branches[0].term
	if ($symTable.lookup(idVar) == nil)
		puts "READ ERROR: variable '#{idVar}' has not been declared."
		return 1
	end
	typeVar = $symTable.lookup(idVar)[0]
	if (typeVar != :NUMBER) and (typeVar != :BOOLEAN)
		puts "READ ERROR: variable '#{idVar}' must be an int or a boolean."
		return 1
	end
	return 0
end

# Manejador de la instruccion WRITE.
def write_Handler(write)
	expr = write.branches[0]
	typeExpr = expression_Handler(expr)
	if (typeExpr != :CANVAS)
		puts "WRITE ERROR: the expression given must be a canvas."
		return 1
	end
	return 0
end

# Manejador de la instruccion CONDITIONAL STATEMENT.
def conditional_statment_Handler(cs)
	expr = cs.elems[0]
	instr1 = cs.elems[1]
	instr_Handler(instr1)
	if (cs.elems[2] != nil)
		instr2 = cs.elems[2]
		instr_Handler(instr2)
	end
	if (expression_Handler(expr) != :BOOLEAN)
		puts "CONDITIONAL STATEMENT ERROR: expression must be boolean."
		return 1
	end
	return 0
end

# Manejador de la instruccion IND LOOP.
def iLoop_Handler(iLoop)
	expr = iLoop.elems[0]
	if (expression_Handler(expr) != :BOOLEAN)
		puts "IND LOOP ERROR: expression must be boolean."
		return 1
	end
	instr = iLoop.elems[1]
	instr_Handler(instr)
	return 0
end

# Manejador de la instruccion DET LOOP.
def dLoop_Handler(dLoop)
	if (dLoop.types[0] == :VARIABLE)
		iterVar = dLoop.elems[0].term
		if ($symTable.lookup(iterVar) == nil)
			$symTable.insert(iterVar, [:NUMBER, nil])
		else
			$symTable.update(iterVar, [:NUMBER, nil])
		end
		expr1 = dLoop.elems[1]
		typeExpr1 = expression_Handler(expr1)
		expr2 = dLoop.elems[2]
		typeExpr2 = expression_Handler(expr2)
		if (typeExpr1 != :NUMBER) or (typeExpr2 != :NUMBER)
			puts "DET LOOP ERROR: expressions must be arithmetic."
			return 1
		end
		instr = dLoop.elems[3]
		instr_Handler(instr, iterVar)
		return 0
	else
		expr1 = dLoop.elems[0]
		typeExpr1 = expression_Handler(expr1)
		expr2 = dLoop.elems[1]
		typeExpr2 = expression_Handler(expr2)
		if (typeExpr1 != :NUMBER) or (typeExpr2 != :NUMBER)
			puts "DET LOOP ERROR: expressions must be arithmetic."
			return 1
		end
		instr = dLoop.elems[2]
		instr_Handler(instr)
		return 0
	end
end

##########################################
# Manejo de las expresiones del programa #
##########################################

# Manejador de expresiones:
# Esta función recibe una expresión y devuelve su tipo.
def expression_Handler(expr)
	# Procesar como binaria
	if expr.instance_of?(BinExp)
		return binExp_Handler(expr)
	# Procesar como unaria
	elsif expr.instance_of?(UnaExp)
		return unaExp_Handler(expr)
	# Procesar como parentizada
	elsif expr.instance_of?(ParExp)
		return parExp_Handler(expr)
	# Procesar como un caso base, un termino.
	elsif expr.instance_of?(Terms)
		type = expr.nameTerm
		case type
		when :IDENTIFIER			
			idVar = expr.term
			typeVar = $symTable.lookup(idVar)[0]
			return typeVar
		when :CANVAS
			return :CANVAS
		when :TRUE
			return :BOOLEAN
		when :FALSE
			return :BOOLEAN
		when :NUMBER
			return :NUMBER			
		end
	else
		puts "ERROR: hubo un errror expression_Handler."		
	end
end

# Manejador de expresiones binarias:
# Devuelve el tipo de las expresiones binarias
# => si hay un error de tipo, devuelve nil.
def binExp_Handler(expr)
	typeExpr1 = expression_Handler(expr.elems[0])
	typeExpr2 = expression_Handler(expr.elems[1])
	if (typeExpr1 != typeExpr2)
		return nil
	end
	case expr.op
	when /^\/\\/
		if typeExpr1 == :BOOLEAN
			return :BOOLEAN
		else
			return nil
		end
	when /^\\\//
		if typeExpr1 == :BOOLEAN
			return :BOOLEAN
		else
			return nil
		end
	when /^(=|\/=)/
		return :BOOLEAN
	when /^[\+\-\*\/%]/
		if typeExpr1 == :NUMBER
			return :NUMBER
		else
			return nil
		end
	when /^[~&]/
		if typeExpr1 == :CANVAS
			return :CANVAS
		else
			return nil
		end
	when /^(<|>|<=|>=)/
		if (typeExpr1 == :NUMBER) and (typeExpr2 == :NUMBER)
			return :BOOLEAN
		else
			return nil
		end
	end
end

# Manejador de expresiones parentizadas.
def parExp_Handler(expr)
	return expression_Handler(expr.expr)
end

# Manejador de expresiones unarias.
# Devuelve el tipo de las expresiones unarias
# => si hay un error de tipo, devuelve nil.
def unaExp_Handler(expr)
	typeExpr = expression_Handler(expr.elem)
	case expr.op
	when /^[$']/
		if typeExpr == :CANVAS
			return :CANVAS
		else
			return nil
		end
	when /\^/
		if typeExpr == :BOOLEAN
			return :BOOLEAN
		else
			return nil
		end
	when /-/
		if typeExpr == :NUMBER
			return :NUMBER
		else
			return nil
		end
	end
end