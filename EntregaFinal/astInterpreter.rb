#!/usr/bin/env ruby
=begin
 *  UNIVERSIDAD SIMÓN BOLÍVAR
 *  Archivo: astInterpreter.rb
 *
 *  Contenido:
 *          Funciones para la interpretacion de un programa LANSCII.
 *
 *  Creado por:
 *			Genessis Sanchez	11-10935
 *          Daniela Socas		11-10979
 *
 *  Última modificación: 24 de Junio de 2015
=end

require './ruleClasses.rb'

# Interpretador de programas
def program_Interpreter(ast)
	scope_Interpreter(ast.scope)
end

# Interpretador de alcances.
def scope_Interpreter(scope)
	$symTable = scope.symTab
	instr_Interpreter(scope.inst)
	$symTable = $symTable.father
end

# Interpretador de instrucciones
def instr_Interpreter(instr)
	case instr.opID[0]
	when :INSTR
		instr.branches.each do |i|
			instr_Interpreter(i)
		end
	when :ASSIGN
		assign_Interpreter(instr.branches[0])
	when :READ
		read_Interpreter(instr)
	when :WRITE
		write_Interpreter(instr)
	when :CONDITIONAL_STATEMENT
		cs_Interpreter(instr.branches[0])
	when :IND_LOOP
		iLoop_Interpreter(instr.branches[0])
	when :DET_LOOP
		dLoop_Interpreter(instr.branches[0])
	when :SCOPE
		scope_Interpreter(instr.branches[0])
	end
end

####################################################
# Interpretacion de las instrucciones del programa #
####################################################

# Interpretador de la instruccion ASSIGN.
def assign_Interpreter(assign)
	idVar = assign.branches[0].term
	type = $symTable.lookup(idVar)[0]
	exprVal = expr_Interpreter(assign.branches[1])
	$symTable.update(idVar, [type, exprVal])
end

# Interpretador de la instruccion READ.
def read_Interpreter(read)
	idVar = read.branches[0].term
	type = $symTable.lookup(idVar)[0]
	valid = false
	# Se espera a que se lea una entrada valida.
	while !valid
		auxVar = STDIN.gets()
		auxVar.slice! "\n"
		# Verificación de tipo
		case auxVar
		when /^\d+/
			if (type == :NUMBER)
				auxVar = auxVar.to_i
				valid = true
			end
		when /^true/
			if (type == :BOOLEAN)
				auxVar = true
				valid = true
			end
		when /^false/
			if (type == :BOOLEAN)
				auxVar = false
				valid = true
			end
		end
	end
	$symTable.update(idVar, [type, auxVar])
end

# Interpretador de la instruccion WRITE.
def write_Interpreter(write)
	expr = write.branches[0]
	puts expr_Interpreter(expr)
end

# Intepretador de la instruccion CONDITIONAL STATEMENT.
def cs_Interpreter(cs)
	expr = cs.elems[0]
	instr1 = cs.elems[1]
	if (cs.elems[2] != nil)
		instr2 = cs.elems[2]
		if (expr_Interpreter(expr))
			instr_Interpreter(instr1)
		else
			instr_Interpreter(instr2)
		end
	else
		if (expr_Interpreter(expr))
			instr_Interpreter(instr1)
		end
	end
end

# Interpretador de la instruccion IND LOOP.
def iLoop_Interpreter(iLoop)
	expr = iLoop.elems[0]
	instr = iLoop.elems[1]
	while (expr_Interpreter(expr))
		instr_Interpreter(instr)
	end
end

# Interpretador de la instruccion DET LOOP.
def dLoop_Interpreter(dLoop)
	if (dLoop.types[0] == :VARIABLE)
		iterVar = dLoop.elems[0].term
		type = $symTable.lookup(iterVar)[0]	
		expr1 = dLoop.elems[1]
		expr2 = dLoop.elems[2]
		instr = dLoop.elems[3]
		iniVal = expr_Interpreter(expr1)
		finVal = expr_Interpreter(expr2)
		$symTable.update(iterVar, [type, iniVal])
		while (iniVal <= finVal)
			instr_Interpreter(instr)
			iniVal += 1
			$symTable.update(iterVar, [type, iniVal])
		end
	else
		# Busca la variable, si la encuentra, la actualiza, si no, la inserta.
		expr1 = dLoop.elems[0]
		expr2 = dLoop.elems[1]
		instr = dLoop.elems[2]
		iniVal = expr_Interpreter(expr1)
		finVal = expr_Interpreter(expr2)
		while (iniVal <= finVal)
			instr_Interpreter(instr)
			iniVal += 1
		end
	end
end

##################################################
# Interpretacion de las expresiones del programa #
##################################################

# Interpretador de expresiones:
def expr_Interpreter(expr)
	# Procesar como binaria
	if expr.instance_of?(BinExp)
		return binExp_Interpreter(expr)
	# Procesar como unaria
	elsif expr.instance_of?(UnaExp)
		return unaExp_Interpreter(expr)
	# Procesar como parentizada
	elsif expr.instance_of?(ParExp)
		return parExp_Interpreter(expr)
	# Procesar como un caso base, un termino.
	elsif expr.instance_of?(Terms)
		type = expr.nameTerm
		case type
		when :IDENTIFIER			
			idVar = expr.term
			val = $symTable.lookup(idVar)[1]
			if (val == nil)
				puts "ERROR: uninitialized variable."
				puts
				abort
			end
			return val
		when :CANVAS
			idVar = expr.term
			if idVar == "#"
				idVar = ""
			end
			return idVar
		when :TRUE
			return true
		when :FALSE
			return false
		when :NUMBER
			idVar = expr.term
			return Integer(idVar)		
		end		
	end
end

# Interpretador de expresiones binarias:
def binExp_Interpreter(expr)
	valExpr1 = expr_Interpreter(expr.elems[0])
	valExpr2 = expr_Interpreter(expr.elems[1])
	if (valExpr1 == nil) or (valExpr2 == nil)
		return nil
	end
	case expr.op
	######################################################
	# Expresiones binarias booleanas logicas y genericas #
	######################################################
	when /^\/\\/
		return (valExpr1 and valExpr2)
	when /^\\\//
		return (valExpr1 or valExpr2)
	when /^=/
		return (valExpr1 == valExpr2)
	when /^\/=/
		return (valExpr1 != valExpr2)
	####################################
	# Expresiones binarias aritmeticas #
	###################################
	when /^\+/
		overflow?(valExpr1 + valExpr2)
		return (valExpr1 + valExpr2)
	when /^\-/
		overflow?(valExpr1 - valExpr2)
		return (valExpr1 - valExpr2)
	when /^\*/
		overflow?(valExpr1 * valExpr2)
		return (valExpr1 * valExpr2)
	when /^\//
		if (valExpr2 == 0)
			puts "ZeroDivisionError: integer division or modulo by zero."
			puts
			abort
		else
			return (valExpr1 / valExpr2)
		end
	when /^%/
		if (valExpr2 == 0)
			puts "ZeroDivisionError: integer division or modulo by zero."
			puts
			abort
		else
			return (valExpr1 % valExpr2)
		end
	######################################
	# Expresiones binarias sobre lienzos #
	######################################
	# Concatenacion horizontal
	when /^~/
		# Interpretacion de elemento identidad '#'
		if (valExpr1 == "")
			return valExpr2
		elsif (valExpr2 == "")
			return valExpr1
		else
			# Chequeo de dimension vertical
			expr1VD = valExpr1.count "\n"
			expr2VD = valExpr2.count "\n"
			if (expr1VD != expr2VD)
				puts "HorizontalConcatERROR: both vertical dimensions must be the same."
				puts
				abort
			else
				# Interpretacion de la instruccion
				if expr1VD == 0
					return (valExpr1+valExpr2)
				else
					auxStr = ""
					counter = 1
					while (counter <= expr1VD)
						auxStr1 = valExpr1.partition("\n").first
						auxStr2 = valExpr2.partition("\n").first
						auxStr << auxStr1+auxStr2+"\n"
						valExpr1 = valExpr1.partition("\n").last
						valExpr2 = valExpr2.partition("\n").last
						counter += 1
					end
					auxStr << valExpr1+valExpr2
					return auxStr
				end
			end
		end
	# Concatenacion vertical
	when /^&/
		# Interpretacion de elemento identidad '#'
		if (valExpr1 == "")
			return valExpr2
		elsif (valExpr2 == "")
			return valExpr1
		else
			# Chequeo de dimension horizontal
			expr1HD = valExpr1.partition("\n").first.length
			expr2HD = valExpr2.partition("\n").first.length 
			if (expr1HD != expr2HD)
				puts "VerticalConcatERROR: both horizontal dimensions must be the same."
				puts
				abort
			else
				# Interpretacion de la instruccion
				return (valExpr1+"\n"+valExpr2)
			end
		end
	#################################################
	# Expresiones binarias booleanas de comparacion #
	#################################################
	when /^<=/
		return (valExpr1 <= valExpr2)
	when /^>=/
		return (valExpr1 >= valExpr2)
	when /^</
		return (valExpr1 < valExpr2)
	when /^>/
		return (valExpr1 > valExpr2)
	end
end

# Interpretador de expresiones parentizadas.
def parExp_Interpreter(expr)
	return expr_Interpreter(expr.expr)
end

# Interpretador de expresiones unarias.
def unaExp_Interpreter(expr)
	valExpr = expr_Interpreter(expr.elem)
	case expr.op
	when /^\$/
		exprHD = valExpr.partition("\n").first.length
		exprVD = valExpr.count("\n") + 1
		auxStr = valExpr
		charMatrix = Array.new(exprVD){Array.new(exprHD)}
		# Construccion de la matriz original
		for i in 0..exprVD-1
			for j in 0..exprHD-1
				charMatrix[i][j] = auxStr[j]
			end
			auxStr = auxStr.partition("\n").last
		end
		charMatrixRot = Array.new(exprHD){Array.new(exprVD)}
		# Construccion de la matriz  de rotacion.
		for i in 0..exprVD-1
			for j in 0..exprHD-1
				charMatrixRot[j][(exprVD-1)-i] = charMatrix[i][j]
			end
		end
		# Construccion de la salida.
		auxStr = ""
		for i in 0..exprHD-1
			for j in 0..exprVD-1
				auxStr << charMatrixRot[i][j]
			end
			if (i != exprHD-1)
				auxStr << "\n"
			end
		end
		return auxStr
	when /^'/
		exprHD = valExpr.partition("\n").first.length
		exprVD = valExpr.count("\n") + 1
		charMatrix = Array.new(exprVD){Array.new(exprHD)}
		auxStr = valExpr
		# Construccion de la matriz original.
		for i in 0..exprVD-1
			for j in 0..exprHD-1
				charMatrix[i][j] = auxStr[j]
			end
			auxStr = auxStr.partition("\n").last
		end
		# Construccion de la matriz traspuesta.
		charMatrix = charMatrix.transpose
		# Construccion de la salida
		auxStr = ""
		for i in 0..exprHD-1
			for j in 0..exprVD-1
				auxStr << charMatrix[i][j]
			end
			if (i != exprHD-1)
				auxStr << "\n"
			end
		end
		return auxStr
	when /^\^/
		return !(valExpr)
	when /^-/
		overflow?(-valExpr)
		return -(valExpr)
	end
end

def overflow?(int)
	if (int > 2147483647) or (int < -2147483647)
		puts "ERROR: integer overflow"
		puts
		abort
	end
end