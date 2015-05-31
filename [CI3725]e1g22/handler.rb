#!/usr/bin/ruby 
=begin
 *  UNIVERSIDAD SIMÓN BOLÍVAR
 *  Archivo: handler.rb
 *
 *  Contenido:
 *          /clases del Parser.
 *
 *  Creado por:
 *			Genessis Sanchez	11-10935
 *          Daniela Socas		11-10979
 *
 *  Último midificación: 31 Mayo de 2015
=end

class S
	def initialize(symbol1=nil, decl=nil,symbol2,insts)
		@symbol = [symbol1, symbol2	]
		@decl = [decl]
		@insts = [insts]
		
	end
	
	def print_ast
		@inst.each do |inst|
			inst.print_ast(ind+1)
	end

end	

#Ahorita no me preocupo por types, primero inst
class Decl
	def initialize()

end

class Type 
	def initialize

	end	
end

class Inst 
	def initialize(,)
		
	end

class Expr_arit 
	def initialize(type, values, ind)

	end

	def print_ast
		
	end
end

class Leaf
	def initialize(symbol, value )
		@symbol = symbol
		@value = value
		@ident = 0 
		
	end
	
	def print_ast
		$ast= $ast.push(["#@symbol: #@value", @ident])
	end

end




