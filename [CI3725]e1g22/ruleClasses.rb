class S
	def initialize(namedecl = nil, decl = nil, nameinst, inst)
		@opID = [namedecl, nameinst]
		@branches = [decl, inst]
	end	
	def printAST(lvl)
		@branches[1].printAST(0)
	end
end

class Instr
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
						print @opID[0]
						puts ": "
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
		puts "#{@instID}:"
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
		puts "#{@instID}:"
		@expr.printAST(lvl+1)
	end
end

class Cond
	# Donde type1 es :CONDITION, type2 es :THEN y tpy3 puede ser :ELSE
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