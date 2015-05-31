#####################################
# Clases asociadas a instrucciones. #
#####################################

class S
	# Donde scope es de la clase Scope.
	def initialize(scope)
		@scope = scope
	end	
	def printAST(lvl)
		@scope.printAST(0)
	end
end

class Scope
	# Donde inst es de la clase Instr
	def initialize(inst)
		@inst = inst
	end
	def printAST(lvl)
		@inst.printAST(lvl)
	end	
end

class Instr
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
	def intialize(type1, var, type2, expr)
		@types = [type1, type2]	# Donde type1 es :VARIABLE y type2 es :EXPRESSION
		@branches = [var, expr] # Donde var es clase Var y expr es clase Expr
	end
	def printAST(lvl)
		# Escribirá el nombre de cada operación y llamará a los prints de las clases
		# => involucradas
		for i in 0..1
			for j in 1..lvl
				print "| "
			end
			puts "#{@types[0]}:"
			@branches[i].printAST(lvl+1)
		end
	end
end

class Read
	def initialize(instID, var)
		@instID = instID	# Donde intID es :READ
		@var = var 	# Donde Var es clase Var
	end
	def printAST(lvl)
		for i in 1..lvl
			print "| "
		end
		@var.printAST(lvl+1)
	end
end

class Write
	def initialize(instID,expr)
		@instID = instID	# Donde intID es :WRITE
		@expr = expr 	# Donde Var es clase Var
	end
	def printAST(lvl)
		for i in 1..lvl
			print "| "
		end
		@expr.printAST(lvl+1)
	end
end

class Cond
	# Donde type1 es :CONDITION, type2 es :THEN y type3 puede ser :ELSE
	# Donde expr es de la clase Expr, inst1 e inst2 son de la clase Instr.
	def initialize(type1, expr, type2, inst1, type3=nil, inst2=nil)
		@types = [type1, type2, type3]
		@elems = [expr, inst1, inst2]
	end
	def printAST(lvl)
		for i in 0..2
			if @types[i] != nil
				for i in 1..lvl
					print "| "
				end
				puts "#{@types[i]}:"
				@elems[i].printAST(lvl+1)
			end
		end
	end
end

class ILoop
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
			@elems.printAST(lvl+1)
		end		
	end
end

class DLoop
	# Donde type1 es :VARIABLE, type2 y type3 son :EXPRESSION y type4 es :INSTR
	# Donde var es de la clase Var, expr1 y expr2 son de la clase Expr e
	# => inst es de la clase Instr
	def initialize(type1, var, type2, expr1, type3, expr2, type4, inst)
		@types = [type1, type2, type3, type4]
		@elems = [var, expr1, expr2, inst]		
	end
	def printAST(lvl)
		for i in 0..3
			if (elem[i] != nil)
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
	# Donde type0 es :OPERATION, op puede ser +, -, *, /, %, ~, \/, /\, <, <=,
	# >, >=, =, ' o &, type1 y type2 son :EXPRESSION y expr1 y expr2 son expresiones
	def initialize(op, type1, expr1, type2, expr2)
		@types = [type1, type2]
		@elemes = [expr1, expr2]
		@op = op
	end
	def printAST(lvl)
		for i in 1..lvl
			print "| "
		end
		puts "#{@type[0]}: #{op}"
		@elems.each do |elem|
			elem.printAST(lvl+1)
		end
	end
end



class Terms
	def initialize(nameTerm, term)
		@opID = nameTerm
		@term = [term]
	end
	def printAST(lvl)
		for i in 1..lvl
			print "| "
		end		
		case @opID
		when :IDENTIFIER, :CANVAS, :NUMBER, :TRUE, :FALSE 
			puts "#{@opID}: #{@term[0]}"
		else
			puts 'error'
		end 
	end
end