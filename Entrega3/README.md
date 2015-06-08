 *  UNIVERSIDAD SIMÓN BOLÍVAR
 *	CI3725-Lanscii 
 *  Archivo: README 
 *
 *  Contenido:
 *          Archivo de texto que ayuda a comprender la 2da entrega.
 *			
 *
 *  Creado por:
 *			Génessis Sanchez  	11-10935
 *          Daniela Socas		11-10979

NAME:
	main.rb -  análisis léxico de un archivo.
	
	Incluye:
		parser.y
		parser.rb
		ruleclasses.rb

SYNOPSIS:
	ruby main.rb [FILE]

BREVE EXPLICACION:
 	Decidimos usar racc de Ruby para compilar el parser.
 	Dado que sólo nos interesa hacer el análisis léxico y semántico en esta etapa, 
 	no tomamos en cuenta errores semńticos o de declaración de variables por 
 	congruencia de tipos.
 	Esta entrega del proyecto se encuentra finalizada y es capaz de imprimir el 
 	árbol sintáctico abstracto de un programa presente en un archivo y de mostrar 
 	los errores léxicos en caso de haberlos y el 1er error sintáctico en case de
 	haberlo.

DIFICULTADES:
	Se nos hizo un poco engorroso hacer este proyecto dada la poca documentación
	que existe sobre la herramienta utilizada para el parser de ruby: racc. La
	poca que hay no es muy buena tampoco.
