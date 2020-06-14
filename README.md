# Trabajo Final Computadores II USAL

Juego Adivinar Parejas de Cartas

# NOTA FINAL: 5.0

- Pablo Jesús González Rubio

## Compilación

Se necesitan:

- `as6809`
- `aslink`
- `m6809-run`

Y se utiliza de la siguiente forma:

```bash
as6809 -o $1.asm
aslink -s $1.rel
m6809-run -C $2 $1.s19
```

## Enunciado

El juego tiene que mostrar el siguiente tablero (se empieza desde el 0):

`| A | E | G | B | F | D | C | F | H | C | D | H | B | E | G | A |`

Y acto seguido tiene que cambiarlo todo por X:

`| x | x | x | x | x | x | x | x | x | x | x | x | x | x | x | x |`

Luego se pide al usuario que introduzca dos posiciones y se verifica si son iguales. No puede elegirse una carta ya revelada.

Si son iguales se suma uno a la puntuación y se revelan. Si no lo son, se suma uno a los fallos y se vuelven a escribir las X correspondientes.


### Pseudoprograma

```
ldx #t
ldy #j

mostrar_tablero:
	fila? -> 2
	columna? -> 2
	calcular_posicion
	valida?
	lda b,y ;si !=x
;--------------------------
	;si =x
	lda b,x
	sta b,y
	mostrar_tablero
	fila? -> 4
	columna? -> 4
	calcular_posicion
	valida?
	lda b,x
	lda b,y
	mostrar_tablero

	;si iguales
	;si todas son iguales ir a FIN
	;si son distintas
	y[pos1]='x
	y[pos2]='x ==
			ldb pos1
			lda #'x
			sta b,y

	;si se quiere volver a jugar, iniciar el tablero todo a x otra vez.
	;mejor dejar algo bien hecho, que seguir y meter codigo que no funciona.

acabar:
	sta 	fin

	.org 	0xFFFE	; Vector de RESET
	.word 	programa
```
