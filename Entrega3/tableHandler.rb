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
	$symTable.insert(listI.id.term, [nil, type])
	if (listI.listI != nil)
		listI_Handler(type, listI.listI)
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
	typeVar = $symTable.lookup(idVar)
#	expression_Handler()
end