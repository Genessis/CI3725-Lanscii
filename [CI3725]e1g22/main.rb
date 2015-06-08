#!/usr/bin/env ruby
=begin
 *  UNIVERSIDAD SIMÓN BOLÍVAR
 *  Archivo: main.rb
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

file_name = ARGV.first
file = File.open(file_name, "r")
lexer = Lexer.new
if (lexer.identifier(file))
	parser = Parser.new(lexer)

	begin
		parser.parse

	rescue => e
		Error = SyntaxError.new()
		puts "Error sintactico: #{e}"
	end
end
file.close