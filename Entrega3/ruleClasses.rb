#!/usr/bin/env ruby
=begin
 *  UNIVERSIDAD SIMÓN BOLÍVAR
 *  Archivo: ruleClasses.rb
 *
 *  Contenido:
 *          Clases para imprimir el AST de LANSCII
 *
 *  Creado por:
 *			Genessis Sanchez	11-10935
 *          Daniela Socas		11-10979
 *
 *  Último midificación: 31 Mayo de 2015
=end

#####################################
# Clases asociadas a instrucciones. #
#####################################

class S
	# Donde scope es de la clase Scope.
	attr_accessor :scope
	def initialize(scope)
		@scope = scope
	end	
	def printAST(lvl)
		@scope.printAST(0)
	end
end

class Scope
	# Donde inst es de la clase Instr
	attr_accessor :inst
	attr_accessor :decl
	def initialize(inst, decl = nil)
		@inst = inst
		@decl = decl
	end
	def printAST(lvl)
		@inst.printAST(lvl)
	end
end

class Decl
	# Donde type es de la clase Type, listI es de la clase ListI y 
	# decl es de la clase Decl
	attr_accessor :type
	attr_accessor :listI
	attr_accessor :decl
	def initialize(type, listI, decl = nil)
		@type = type
		@listI = listI
		@decl = decl 
	end	
end

#class Type
#	attr_accessor :type
#	def initialize(type)
#		@type = type
#	end	
#end

class ListI
	# Donde id es de la clase Terms (:IDENTIFIER) y listI es de la clase ListI
	attr_accessor :id
	attr_accessor :listI
	def initialize(id, listI = nil)
		@id = id
		@listI = listI
	end	
end

class Instr
	attr_accessor :opID
	attr_accessor :branches
	# Donde nameinst1 puede ser :INSTR, :READ, :WRITE, :ASSIGN, :COND, :IND_LOOP, 
	# => :DET_LOOP o :S y nameinst2 tiene que ser :INSTR.
	def initialize(nameinst1, inst1, nameinst2 = nil, inst2 = nil)
		@opID = [nameinst1, nameinst2]
		@branches = [inst1, inst2]
	end
	def printAST(lvl)
		@branches.each do |branch|
			if branch != nil
				if @opID[0] == :INSTR
					branch.printAST(lvl)
				else
					for i in 1..lvl
						print "| "
					end
					puts "#{@opID[0]}: "
					branch.printAST(lvl+1)
				end
			end
		end
	end
end

class Assign
	attr_accessor :types
	attr_accessor :branches
	def initialize(type1, var, type2, expr)
		@types = [type1, type2]	# Donde type1 es :VARIABLE y type2 es :EXPRESSION
		@branches = [var, expr] # Donde var es clase Term y expr es clase Expr
	end
	def printAST(lvl)
		# Escribirá el nombre de cada operación y llamará a los prints de las clases
		# => involucradas
		for i in 0..1
			for j in 1..lvl
				print "| "
			end
			puts "#{@types[i]}:"
			@branches[i].printAST(lvl+1)
		end
	end
end

#class Read
#	def initialize(instID, var)
#		@instID = instID	# Donde intID es :READ
#		@var = var 	# Donde Var es clase Var
#	end
#	def printAST(lvl)
#		for i in 1..lvl
#			print "| "
#		end
#		puts "#{@instID}"
#		@var.printAST(lvl+1)
#	end
#end
#
#class Write
#	def initialize(instID,expr)
#		@instID = instID	# Donde intID es :WRITE
#		@expr = expr 	# Donde Var es clase Var
#	end
#	def printAST(lvl)
#		for i in 1..lvl
#			print "| "
#		end
#		puts "#{@instID} :"
#		@expr.printAST(lvl+1)
#	end
#end

class Cond
	attr_accessor :types
	attr_accessor :elems
	# Donde type1 es :CONDITION, type2 es :THEN y type3 puede ser :ELSE
	# Donde expr es de la clase Expr, inst1 e inst2 son de la clase Instr.
	def initialize(type1, expr, type2, inst1, type3=nil, inst2=nil)
		@types = [type1, type2, type3]
		@elems = [expr, inst1, inst2]
	end
	def printAST(lvl)
		for i in 0..2
			if @types[i] != nil
				for j in 1..lvl
					print "| "
				end
				puts "#{@types[i]}:"
				@elems[i].printAST(lvl+1)
			end
		end
	end
end

class ILoop
	attr_accessor :types
	attr_accessor :elems
	# Donde type1 es :WHILE y type2 es :DO
	# Donde expr es de la clase Expr e inst es de la clase Instr
	def initialize(type1, expr, type2, inst)
		@types = [type1, type2]
		@elems = [expr, inst]
	end
	def printAST(lvl)
		for i in 0..1
			for j in 1..lvl
				print "| "
			end
			puts "#{@types[i]}:"
			@elems[i].printAST(lvl+1)
		end		
	end
end

class DLoop
	attr_accessor :types
	attr_accessor :elems
	# Donde type1 es :VARIABLE, type2 y type3 son :EXPRESSION y type4 es :INSTR
	# Donde var es de la clase Var, expr1 y expr2 son de la clase Expr e
	# => inst es de la clase Instr
	def initialize(type1, var, type2, expr1, type3, expr2, type4=nil, inst=nil)
		@types = [type1, type2, type3, type4]
		@elems = [var, expr1, expr2, inst]		
	end
	def printAST(lvl)
		for i in 0..3
			if (@elems[i] != nil)
				for j in 1..lvl
					print "| "
				end
				puts "#{@types[i]}:"
				@elems[i].printAST(lvl+1)
			end
		end
	end	
end

###################################
# Clases asociadas a expresiones. #
###################################

class BinExp
	attr_accessor :elems
	attr_accessor :op
	# Donde type0 es :OPERATION, op puede ser +, -, *, /, %, ~, \/, /\, <, <=,
	# >, >=, =, ' o &, type1 y type2 son :EXPRESSION y expr1 y expr2 son expresiones
	def initialize(op, expr1, expr2)
		@elems = [expr1, expr2]
		@op = op
	end
	def printAST(lvl)
		for i in 1..lvl
			print "| "
		end
		puts "OPERATION: #{@op}"
		@elems.each do |elem|
			elem.printAST(lvl+1)
		end
	end
end

class UnaExp
	attr_accessor :elem
	attr_accessor :op
	def initialize(op, expr)
		@elem = expr
		@op = op
	end
	def printAST(lvl)
		for i in 1..lvl
			print "| "
		end
		puts "OPERATION: #{@op}"
		@elem.printAST(lvl+1)
	end
end

# Donde type es :EXPRESSION y expr es una expresion cualquiera
class ParExp
	attr_accessor :type
	attr_accessor :expr
	def initialize(type, expr)
		@type = type
		@expr = expr		
	end
	def printAST(lvl)
		for i in 1..lvl
			print "| "
		end
		puts "#{@type}"
		@expr.printAST(lvl+1)		
	end	
end

class Terms
	attr_accessor :nameTerm
	attr_accessor :term
	def initialize(nameTerm, term)
		@nameTerm = nameTerm
		@term = term
	end
	def printAST(lvl)
		for i in 1..lvl
			print "| "
		end		
		case @nameTerm
		when :IDENTIFIER, :CANVAS, :NUMBER, :TRUE, :FALSE 
			puts "#{@nameTerm}: #{@term}"
		end 
	end
end