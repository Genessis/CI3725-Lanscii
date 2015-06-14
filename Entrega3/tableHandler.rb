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

$symTable = SymbolTable.new(0)

def program_Handler(ast)
	scope_Handler(ast.scope)
end

def scope_Handler(scope)
	symTableAux = SymbolTable.new(1, $symTable)
	$symTable = symTableAux
	decl_Handler(scope.decl)
	instr_Handler(scope.inst)
	$symTable = $symTable.father
end

def decl_Handler(decl)
	case decl.type
	when :AT
		listI_Handler(:CANVAS, decl.listI)
	when :PERCENT
		listI_Handler(:NUMBER, decl.listI)
	when :EXCLAMATION_MARK
		listI_Handler(:BOOLEAN, decl.listI)
	end
	if (decl.decl != nil)
		decl_Handler(decl.decl)
	end
end

def listI_Handler(type, listI)
	if !($symTable.contains(listI.id.term))
		$symTable.insert(listI.id.term, [type, nil])
		if (listI.listI != nil)
			listI_Handler(type, listI.listI)
		end
	else
		puts "ERROR: variable '#{listI.id.term}' was declared before" \
				" at the same scope."
	end
end

def instr_Handler(instr)
	case instr.opID[0]
	when :INSTR
		instr.branches.each do |i|
			instr_Handler(i)
		end
	when :ASSIGN
		assign_Handler(instr.branches[0])
	end
end

def assign_Handler(assign)
	idVar = assign.branches[0].term
	typeVar = $symTable.lookup(idVar)[0]
	typeExpr = expression_Handler(assign.branches[1])
	if (typeVar != typeExpr)
		puts "ERROR: type dismatch."
	else
		puts "Son iguales"
	end
end

def expression_Handler(expr)
	# Procesar como binaria
	if expr.instance_of?(BinExp)
		return binExp_Handler(expr)
	# Procesar como unaria
	elsif expr.instance_of?(UnaExp)
		unaExp_Handler(expr)
		return true
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

def binExp_Handler(expr)
	typeExpr1 = expression_Handler(expr.elems[0])
	typeExpr2 = expression_Handler(expr.elems[1])
	if (typeExpr1 != typeExpr2)
		return nil
	end
	case expr.op
	when /^\/\\/
		puts "Entre en y"
		if typeExpr1 == :BOOLEAN
			return :BOOLEAN
		else
			return nil
		end
	when /^\\\//
		puts "Entre en o"
		if typeExpr1 == :BOOLEAN
			return :BOOLEAN
		else
			return nil
		end
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

def parExp_Handler(expr)
	return expression_Handler(expr.expr)
end

def unaExp_Handler(expr)
#	puts "Es unaria"
	return expression_Handler(expr.expr)
end