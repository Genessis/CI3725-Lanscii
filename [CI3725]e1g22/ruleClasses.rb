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
