.module imprimir_tablero
.globl  imprime_tablero
.globl  imprime_cadena
.globl  contador_tablero
.globl  intentos

texto_cont_tablero: .asciz "Tablero: "
texto_vidas:        .asciz "Intentos: "

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; imprime_tablero                                                  ;
;     saca por la pantalla el tablero cuando la X llega a 16       ;
;                                                                  ;
;   Entrada: X-direccion de comienzo de la cadena                  ;
;   Salida:  ninguna                                               ;
;   Registros afectados: X, CC.                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

imprime_tablero:
        pshs a,b

        ;Le suma a X el tablero en el que nos encontramos
        ;x = x + 16*pos
        lda #16
        ldb contador_tablero
        mul
        abx

        ldb #0
        bra salto_linea
        lda #'\t
        sta 0xFF00
        bucle:
                 lda ,x+
                 sta 0xFF00
                 incb

                 cmpb #4
                 beq salto_linea

                 cmpb #8
                 beq salto_linea

                 cmpb #12
                 beq salto_linea

                 cmpb #16
                 beq terminar
                 bra bucle

        salto_linea:
                 lda #'\n
                 sta 0xFF00
                 lda #'\t
                 sta 0xFF00
                 bra bucle
        terminar:
                 lda #'\n
                 sta 0xFF00
                 sta 0xFF00

                 lda #'\t
                 sta 0xFF00
                 ldx #texto_cont_tablero
                 jsr imprime_cadena
                 lda contador_tablero
                 adda #'0
                 sta 0xFF00
                 lda #'\n
                 sta 0xFF00

                 lda #'\t
                 sta 0xFF00
                 ldx #texto_vidas
                 jsr imprime_cadena
                 lda intentos
                 adda #'0
                 sta 0xFF00
                 lda #'\n
                 sta 0xFF00
                 puls a,b
                 rts
