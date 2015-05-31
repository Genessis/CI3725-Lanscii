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
		@types = [type1, type2]
		@branches = [var, expr]
	end
	def printAST(lvl)
		for i in 0..1
			for j in 1..lvl
				prit "| "
			end
			puts "#{@types[0]}:"
			@branches[i].printAST(lvl+1)
		end
	end
end