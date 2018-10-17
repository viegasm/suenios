/*
 * Punto 1
 */
class Persona {

	var edad
	var felicidad
	// Suenios pendientes
	var sueniosPendientes = []
	var carrerasQueQuiereEstudiar = []
	var plataQueQuiereGanar
	var lugaresQueQuiereConocer = []
	var hijos = []
	// Suenios cumplidos
	var sueniosCumplidos = []
	var carrerasEstudiadas = []

	method carrerasQueQuiereEstudiar() {
		return carrerasQueQuiereEstudiar
	}

	method carrerasEstudiadas() {
		return carrerasEstudiadas
	}

	method plataQueQuiereGanar() {
		return plataQueQuiereGanar
	}

	method hijos() {
		return hijos
	}

	method removerSuenioDeseado(suenio) {
		sueniosPendientes.remove(suenio)
	}

	method agregarSuenioCumplido(suenio) {
		sueniosCumplidos.add(suenio)
	}

	method sumarFelicidad(_felicidad) {
		felicidad = felicidad + _felicidad
	}

	method agregarHijo(hijo) {
		hijos.add(hijo)
	}

	method lugaresQueQuiereConocer() {
		return lugaresQueQuiereConocer
	}

	/*
	 * Punto 4
	 */
	method felicidoniaPendiente() {
		return sueniosPendientes.sum({ suenio => suenio.felicidonios() })
	}

	method esFeliz() {
		return felicidad > self.felicidoniaPendiente()
	}

	/*
	 * Punto 5
	 */
	method esAmbiciosa() {
		return ((sueniosPendientes.size() + sueniosCumplidos.size() > 3) && (self.felicidoniaPendiente() > 100))
	}

}

class Suenio {

	var property felicidonios

	method cumplirSuenio(suenio, persona) {
		suenio.validarSuenio(suenio)
		persona.removerSuenioDeseado(suenio)
		persona.agregarSuenioCumplido(suenio)
		persona.sumarFelicidad(suenio.felicidonios())
	}

}

class EstudiarCarrera inherits Suenio {

	var carrera

	constructor(_carrera) {
		carrera = _carrera
	}

	method validarSuenio(persona) {
		// carrera que no quiere estudiar la persona
		if (persona.carrerasQueQuiereEstudiar().filter(carrera).size(0)) {
			self.error("La persona no desea estudiar la carrera")
		}
			// ya se recibio en esta carrera
		if (!persona.carrerasEstudiadas().filter(carrera).size(0)) {
			self.error("La persona ya estudio la carrera")
		}
	}

}

class ConseguirTrabajo inherits Suenio {

	var sueldo

	method validarSuenio(persona) {
		// gana menos plata de la deseada
		if (sueldo < persona.plataQueQuiereGanar()) {
			self.error("El sueldo es menor al deseado")
		}
	}

}

class AdoptarHijo inherits Suenio {

	var nombres = []

	method validarSuenio(persona) {
		if (!persona.hijos().size(0)) {
			self.error("No puede adoptar hijos porque ya tiene")
		}
	}

	override method cumplirSuenio(suenio, persona) {
		super(suenio, persona)
		nombres.forEach({ nombre => persona.agregarHijo(nombre)})
	}

}

class TenerHijo inherits Suenio {

	var nombre

	override method cumplirSuenio(suenio, persona) {
		super(suenio, persona)
		persona.agregarHijo(nombre)
	}

}

class Viajar inherits Suenio {

	var lugar

	method validarSuenio(persona) {
		// No esta en la lista de lugares a la que la persona quiere viajar
		if (persona.lugaresQueQuiereConocer().filter(lugar).size(0)) {
			self.error("No esta en la lista de lugares a la que la persona quiere viajar")
		}
	}

}

/*
 * Punto 2
 */
class SuenioMultiple inherits Suenio {

	var suenios = []

	method cumplirSuenios(persona) {
		suenios.forEach({ suenio => suenio.validarSuenio(suenio)})
		suenios.forEach({ suenio => persona.removerSuenioDeseado(suenio)})
		suenios.forEach({ suenio => persona.agregarSuenioCumplido(suenio)})
		suenios.forEach({ suenio => persona.sumarFelicidad(suenio.felicidonios())})
	}

}

/*
 * Punto 3
 */
class PersonaRealista inherits Persona {

	method suenioMasPreciado() {
		return self.ordenarSueniosSegunFelicidonios(sueniosPendientes).first()
	}

	method ordenarSueniosSegunFelicidonios(suenios) {
		return suenios.sortedBy({ suenio1 , suenio2 => suenio1.felicidonios() > suenio2.felicidonios() })
	}

}

class PersonaAlocada inherits Persona {

	method suenioMasPreciado() {
		return sueniosPendientes.anyOne()
	}

}

class PersonaObsesiva inherits Persona {

	method suenioMasPreciado() {
		return sueniosPendientes.first()
	}

}

