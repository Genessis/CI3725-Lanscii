=begin
 *  UNIVERSIDAD SIMÓN BOLÍVAR
 *  Archivo: lexer.rb
 *
 *  Contenido:
 *          Script de cconsulta de la base de datos de estudiantes.
 *			Pre taller 1. 
 *
 *  Creado por:
 *			Genessis Sanchez
 *          Daniela Socas
 *
 *  Último midificación: 30 de Abril de 2015
=end

class Token
	# Creamos metodos para acceder a los atributos privados de la clase.
	attr_accessor :id
	attr_accessor :symbol
	attr_accessor :position
	def initialize (id = nil, symbol, position)
		@id = id
		@symbol = symbol
		@position = position
	end
end

class Lexer
=begin
	atr:   @tokensList: lista de tokens validos del lenguaje.
		   @errList: lista de tokens no validos del lenguaje.
=end	
=begin
	funcion: initialize: inicializa la clase Lexer.
=end
	def initialize
		@tokensList = Array.new
		@errList = Array.new
	end
=begin
	funcion: identifier: identifica los tokens validos e invalidos en un archivo.
	@param: file: archivo a analizar.
=end
	def identifier(file)
		lineNum = 0
		file.each_line do |line|
			# En cada iteracion (salto de linea), el numero de linea aumenta.
			# y el numero de columna vuelve a 1.
			lineNum += 1
			colNum = 1
			# Cuando lo que queda de la linea es un salto de pagina, pasamos a la
			# proxima linea (arriba)
			while line != ""
				# Este case sirve para matchear regexs con los 'when' en lo que quede de linea.
				case line
				# En este ejemplo, como el archivo de prueba es de texto, va a matchear
				# cada palabra.

=begin
				when /^[a-zA-Z+]/
					word = line[/^[a-zA-Z]+/]
					line = line.partition(word).last
					@tokensList << Token.new("WORD", word, [lineNum, colNum])
					colNum += word.size
=end 

				# Este es para los espacios en blanco, saltos de liena o tabulaciones.
				when /^[\s\t]+/
					word = line[/^[\s\t]+/]
					line = line.partition(word).last
					colNum += word.size
				

				# AGREGANDO TOKENS LIST.
				# Va a matchear todas las palabras, son de tipo IDENTIFIER. 
				when /^[a-zA-Z+][_a-zA-Z0-9+]/
					word = line[/^[a-zA-Z][_a-zA-Z0-9]+/]
					line = line.partition(word).last
					@tokensList << Token.new("IDENTIFIER", word, [lineNum, colNum])
					colNum += word.size

				# Va a matchear todos los numeros, son de tipo NUMBER. 
				when /^[0-9]+[^a-zA-Z]/
					word = line[/^[0-9]+[^a-zA-Z]/]
					line = line.partition(word).last
					@tokensList << Token.new("NUMBER", word, [lineNum, colNum])
					colNum += word.size

				# Va a matchear los @, son de tipo AT. 
				when /^[@]/
					word = line[/^[@]/]
					line = line.partition(word).last
					@tokensList << Token.new("AT", word, [lineNum, colNum])
					colNum += word.size

				# Va a matchear todos !, son de tipo EXCLAMATION MARK. 
				when /^[!]/
					word = line[/^[!]/]
					line = line.partition(word).last
					@tokensList << Token.new("EXCLAMATION MARK", word, [lineNum, colNum])
					colNum += word.size

				# Va a matchear todos }, es de tipo LCURLY. 
				when /^[{]/
					word = line[/^[{]/]
					line = line.partition(word).last
					@tokensList << Token.new("LCURLY", word, [lineNum, colNum])
					colNum += word.size					

				# Va a matchear todos }, es de tipo RCURLY. 
				when /^[}]/
					word = line[/^[}]/]
					line = line.partition(word).last
					@tokensList << Token.new("RCURLY", word, [lineNum, colNum])
					colNum += word.size						

				# Va a matchear todos ), es de tipo RPARENTHESIS. 
				when /^[)]/
					word = line[/^[)]/]
					line = line.partition(word).last
					@tokensList << Token.new("RPARENTHESIS", word, [lineNum, colNum])
					colNum += word.size	

				# Va a matchear todos (, es de tipo LPARENTHESIS. 
				when /^[(]/
					word = line[/^[(]/]
					line = line.partition(word).last
					@tokensList << Token.new("LPARENTHESIS", word, [lineNum, colNum])
					colNum += word.size	

				# Va a matchear todos |, es de tipo PIPE. 
				when /^[|]/
					word = line[/^[|]/]
					line = line.partition(word).last
					@tokensList << Token.new("PIPE", word, [lineNum, colNum])
					colNum += word.size

				# Va a matchear todos ;, es de tipo SEMICOLON. 
				when /^[;]/
					word = line[/^[;]/]
					line = line.partition(word).last
					@tokensList << Token.new("SEMICOLON", word, [lineNum, colNum])
					colNum += word.size	

				# Va a matchear todos ?, es de tipo QUESTIONMARK. 
				when /^[?]/
					word = line[/^[?]/]
					line = line.partition(word).last
					@tokensList << Token.new("QUESTIONMARK", word, [lineNum, colNum])
					colNum += word.size

				# Va a matchear todos -, es de tipo MINUS. 
				when /^[-]/
					word = line[/^[-]/]
					line = line.partition(word).last
					@tokensList << Token.new("MINUS", word, [lineNum, colNum])
					colNum += word.size

				# Va a matchear todos <|>, es de tipo CANVAS. 
				when /^[<|>]/
					word = line[/^[<|>]/]
					line = line.partition(word).last
					@tokensList << Token.new("CANVAS", "(|)", [lineNum, colNum])
					colNum += word.size	

				# Va a matchear todos =, es de tipo EQUALS. 
				when /^[=]/
					word = line[/^[=]/]
					line = line.partition(word).last
					@tokensList << Token.new("EQUALS", word, [lineNum, colNum])
					colNum += word.size	

				# Va a matchear todos :, es de tipo COLON. 
				when /^[:]/
					word = line[/^[:]/]
					line = line.partition(word).last
					@tokensList << Token.new("COLON", word, [lineNum, colNum])
					colNum += word.size		


				# Va a matchear todos ;, es de tipo PERCENT. 
				when /^[%]/
					word = line[/^[%]/]
					line = line.partition(word).last
					@tokensList << Token.new("PERCENT", word, [lineNum, colNum])
					colNum += word.size	

				# Va a matchear todos ;, es de tipo PERCENT. 
				when /^[+]/
					word = line[/^[+]/]
					line = line.partition(word).last
					@tokensList << Token.new("PLUS", word, [lineNum, colNum])
					colNum += word.size					



				# y esto es para todo lo que no sean palabras validas (letras en este ejemplo).
				else
					word = line[/^./]
					line = line.partition(word).last
					@errList << Token.new("", word, [lineNum, colNum])
					colNum += word.size
				end
			end
		end
		# Si hubo algun caracter invalido, se imprime y se borra el arreglo de tokens validos.
		if (@errList.length > 0)
			@tokensList.drop(@tokensList.length)
			for err in @errList
				puts "ERROR: Unexpected character: '#{err.symbol}' at line: " \
							"#{err.position[0]}, column: #{err.position[1]} \n"
			end
		# Si todos los caracteres son validos, se imprimen los tokens.
		else
			for tok in @tokensList
				puts "token #{tok.id} value (#{tok.symbol}) at line: #{tok.position[0]}," \
								" column: #{tok.position[1]} \n"
			end
		end
	end
end


file_name = ARGV.first
file = File.open(file_name, "r")
lexer = Lexer.new
lexer.identifier(file)
file.close