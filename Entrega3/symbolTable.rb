#!/usr/bin/env ruby
=begin
 *  UNIVERSIDAD SIMÓN BOLÍVAR
 *  Archivo: symbolTable.rb
 *
 *  Contenido:
 *          Clase para la tabla de Simbolos de LANSCII.
 *
 *  Creado por:
 *			Genessis Sanchez	11-10935
 *          Daniela Socas		11-10979
 *
 *  Último midificación: 9 de junio de 2015
=end

class SymbolTable

#	attr_accessor :symTable
	attr_accessor :father
	attr_accessor :id
	def initialize(id, father = nil)
		@symTable = Hash.new
		@father = father
		@id = id
	end
	
	def insert(key, values)
		return @symTable.store(key, values)
	end

	def delete(key)
		return @symTable.delete(key)
	end
	
	def contains(key)
		return @symTable.include?(key)
	end

	def update(key, value)
		if !(contains(key))
			if (@father != nil)
				return @father.update(key, value)
			else
				puts "ERROR: la variable '#{key}' no ha sido declarada."
				return false
			end
		else
			@symTable[key] = value
			return true
		end		
	end

	def lookup(key)
		if !(contains(key))
			if (@father != nil)
				return @father.lookup(key)
			else
				puts "ERROR: la variable '#{key}' no ha sido declarada."
				return nil
			end
		else
			return @symTable[key]
		end
	end
end