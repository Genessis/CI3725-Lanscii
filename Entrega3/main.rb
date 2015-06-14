#!/usr/bin/env ruby
=begin
 *  UNIVERSIDAD SIMÓN BOLÍVAR
 *  Archivo: lanscii
 *
 *  Contenido:
 *          Interpretador LANSCII
 *
 *  Creado por:
 *			Genessis Sanchez	11-10935
 *          Daniela Socas		11-10979
 *
 *  Última modificación: 31 Mayo de 2015
=end

require './lexer.rb'
require './parser.rb'
require './tableHandler.rb'

# Chequeo de flags
arg = ARGV
printTokens = false
printAST = false
printSymbolTable = false

if arg.count == 1
	printSymbolTable = true
else 
	while arg.count >= 1
		case arg.first
		when "-s"
			printSymbolTable = true
		when "-t"
			printTokens = true
		when "-a"
			printAST = true
		end
		arg = arg.drop(1)
	end
end

file_name = ARGV.first
file = File.open(file_name, "r")
lexer = Lexer.new
if (lexer.identifier(file))
	parser = Parser.new(lexer)
	ast = parser.parse
	ast.printAST(0)
	program_Handler(ast)
#	begin
#		parser.parse
#
#	rescue => e
#		Error = SyntaxError.new()
#		puts "Error sintactico: #{e}"
#	end
end
file.close