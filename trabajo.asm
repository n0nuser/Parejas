fin     	.equ 0xFF01
pantalla 	.equ 0xFF00
teclado		.equ	0xFF02

.globl 	programa
.globl  contador_tablero
.globl  intentos

.globl 	tablero_lista
.globl	tablero_numero
.globl	tablero_tamano

.globl  imprime_cadena
.globl  imprime_tablero
.globl  limpia_pantalla

;Se utilizan para almacena la posicion de la letra y la letra
primera_letra_pos:      .byte 0
primera_letra_char:     .asciz ""
primera_letra_texto:    .asciz "\033[93m\n\tPRIMERA LETRA\n\t-------------\033[0m"
segunda_letra_pos:      .byte 0
segunda_letra_char:     .asciz ""
segunda_letra_texto:    .asciz "\033[93m\n\n\tSEGUNDA LETRA\n\t-------------\033[0m"

;Texto pregunta filas y columnas
;Almacena los resultados de [(fila-1)*ancho]+columna
pregunta_fil:       .asciz "\tIntroduzca una fila: "
pregunta_col:       .asciz "\n\tIntroduzca una columna: "
operacion_pos:      .byte 0

;Indicador numero de tablero y intentos restantes
num_aciertos:       .byte 0 ;Para pasar al siguiente tablero
contador_tablero:   .byte 0
intentos:           .byte 0

tablero_x:          .asciz "XXXXXXXXXXXXXXXX"

enter:                .asciz ") Pulse intro."
success:              .asciz "\tEnhorabuena, has completado el tablero."
success_final:        .asciz "\tENHORABUENA, has completado todos los tableros."
instrucciones_texto:  .ascii ") El usuario debe elegir dos letras segun su fila y columna,"
                      .ascii "\n   Si son iguales, estas dos letras quedaran reveladas."
                      .ascii "\n   Si no son iguales, volveran a su puesto y se tapara con X."
                      .ascii "\n   Si se completa el tablero, se pasara al siguiente y asi hasta que se completen todos,"
                      .asciz "   entonces se volvera al primer tablero.\n\n"
menu:  .asciz "\33[1;31mMEMORAMA (v.777)\n\n\33[1;34m1) Jugar\n2) Instrucciones\nS) Salir\33[0m\n"


programa:
        lds #0xF000 ;Crea valor de pila
p_menu:
        jsr limpia_pantalla
        ldx #menu
        jsr imprime_cadena
        ldb teclado
        ;;;;;;;;
        cmpb #'1
        bne no_jugar
        jsr jugar
        ;;;;;;;;
    no_jugar:
        cmpb #'2
        beq instrucciones
        ;;;;;;;;
        cmpb #'S
        beq acabar
        ;;;;;;;;
        jsr limpia_pantalla
        bra p_menu

acabar:
        sta 	fin
;//////////////;
;--SUBRUTINAS--;
;//////////////;
instrucciones:
        ldx #instrucciones_texto
        jsr imprime_cadena
        jsr limpia_pantalla
        bra p_menu

;///////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////
voltea_todas_x:
;-----------
        pshs a,b
        ldx #tablero_x
        bucle_x:
          ;CARGA TODO EL TABLERO CON X
          lda #'X
          sta ,x+
          ;Asi compruebo si ha llegado a EOL
          lda ,x
          beq ret
          bra bucle_x
        ret:
          puls a,b
          rts

;///////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////
jugar:
;----
        lda #0
        sta num_aciertos
        ldx #enter
        jsr imprime_cadena
        jsr limpia_pantalla
        jsr voltea_todas_x
        ldx #tablero_lista
        jsr imprime_tablero
seguir1:
        jsr limpia_pantalla
        ldx #tablero_x
        jsr imprime_tablero

        ;//////// PREGUNTA POSICION LETRA \\\\\\\\
primera_letra:
;-------------
        ldx #primera_letra_texto
        jsr imprime_cadena
        lda #'\n
        sta pantalla
        ldx #pregunta_fil
        jsr imprime_cadena
        lda teclado
        ;Si se pulsa X se vuelve al programa
        cmpa #'X
        lbeq terminar_programa
        ;Si es menor que 1 filas vuelve
        cmpa #'1
        blt seguir1
        ;Si es mayor que 4 filas vuelve
        cmpa #'4
        bhi seguir1

        suba #'0
        ;[(fila-1)*ancho]+columna
        deca                       ; a = fila -1
        ldb tablero_tamano         ; b = 4
        mul                        ; d = (fila-1)*4
        std operacion_pos          ; operacion_pos = d

        columna1:
            clra ;Me aseguro de que D = 0
            clrb
            ldx #pregunta_col
            jsr imprime_cadena
            ldb teclado
            ;Si se pulsa X se vuelve al programa
            cmpb #'X
            lbeq terminar_programa
            ;Si es menor que 1 filas vuelve
            cmpb #'1
            blt columna1
            ;Si es mayor que 4 filas vuelve
            cmpb #'4
            bhi columna1

        subb #'0                   ; b = columna
        decb                       ; b = columna-1
        addd operacion_pos         ; d = d + operacion_pos
        std primera_letra_pos      ; primera_letra_pos = d
                                   ; (posicion numerica 1 letra)

        ;Comprueba que la letra no estaba ya cambiada
        ldx #tablero_x
        lda b,x
        cmpa #'X
        lbne seguir1

        ;---Muestra letra---
        ldy #tablero_lista
        lda b,y
        sta b,x
        sta primera_letra_char

seguir2:
        jsr limpia_pantalla
        ldx #tablero_x
        jsr imprime_tablero

segunda_letra:
;-------------
        ldx #segunda_letra_texto
        jsr imprime_cadena
        lda #'\n
        sta pantalla
        fila1:
        ldx #pregunta_fil
        jsr imprime_cadena
        lda teclado
        ;Si se pulsa X se vuelve al programa
        cmpa #'X
        lbeq terminar_programa
        ;Si es menor que 1 filas vuelve
        cmpa #'1
        lblt segunda_letra
        ;Si es mayor que 4 filas vuelve
        cmpa #'4
        lbhi segunda_letra

        suba #'0
        ;[(fila-1)*ancho]+columna
        deca                       ; a = fila -1
        ldb tablero_tamano         ; b = 4
        mul                        ; d = (fila-1)*4
        std operacion_pos          ; operacion_pos = d

        columna2:
            clra ;Me aseguro de que D = 0
            clrb
            ldx #pregunta_col
            jsr imprime_cadena
            ldb teclado
            ;Si se pulsa X se vuelve al programa
            cmpb #'X
            lbeq terminar_programa
            ;Si es menor que 1 filas vuelve
            cmpb #'1
            blt columna2
            ;Si es mayor que 4 filas vuelve
            cmpb #'4
            bhi columna2

        subb #'0                   ; b = columna
        decb                       ; b = columna -1
        addd operacion_pos         ; b = b + operacion_pos
        std segunda_letra_pos      ; segunda_letra_pos = b
                                   ; (posicion numerica 2 letra)

        ;Comprueba que la letra no estaba ya cambiada
        ldx #tablero_x
        lda b,x
        cmpa #'X
        lbne segunda_letra

        ;---Muestra letra---
        ldy #tablero_lista
        lda b,y
        sta b,x
        sta segunda_letra_char

;
;//////// COMPARAR LAS LETRAS \\\\\\\\
;          inc intentos
;          lda primera_letra_char
;          cmpa segunda_letra_char
;          bne incorrecto
;          bra correcto
;          incorrecto:
;            ;Cambia las letras erróneas a X otra vez
;            ldx #tablero_x
;            lda #'X
;            ldb primera_letra_pos
;            sta b,x
;            ldb segunda_letra_pos ;Aqui hay basura ??
;            sta b,x
;            lbra seguir1
;
;          correcto:
;            ;Incrementa aciertos en 2
;            clra
;            inc num_aciertos
;            ldb num_aciertos
;            ;Comprueba si quedan parejas por completar
;            cmpb #8
;            lbne seguir1
;            sgte_tab:
              inc contador_tablero
;              lda contador_tablero
;              cmpa #7
;              beq final
;                jsr limpia_pantalla
;                ldx #success
;                jsr imprime_cadena
;                ;Si ha terminado el tablero, incrementa el contador y va al menu
;                inc contador_tablero
;                bra terminar_programa
;              final:
;                jsr limpia_pantalla
;                lda #0
;                sta contador_tablero
;                sta intentos
;                ldx #success_final
;                jsr imprime_cadena
;                bra terminar_programa
terminar_programa:
          clra
          clrb
          rts

;///////////////;
;///////////////;
.area FIJA(ABS)
.org 	  0xFFFE	; Vector de RESET
.word 	programa
