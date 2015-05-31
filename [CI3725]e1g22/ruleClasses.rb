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

	def initialize(nameinst1, inst1, nameinst2, inst2)
		@opID = [nameinst1, nameinst2]
		@branches = [inst1, inst2]
	end

	def printAST(lvl)
		
	end
