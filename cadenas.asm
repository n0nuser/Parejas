		.module cadenas ;_CODE REL ;codigo reubicable
		.globl  imprime_cadena 
		;Lo que es necesario poner en los dos archivos
													 ;Es el nombre de la funcion a modularizar

imprime_cadena:
	pshs a
	lc_bucle:
		lda ,x+
		beq lc_ret
		sta 0xFF00 ;PANTALLA
		bra lc_bucle
	lc_ret:
		puls a
		rts
