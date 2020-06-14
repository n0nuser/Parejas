.module cls
.globl limpia_pantalla
.globl imprime_cadena

clear:  .asciz "\33[2J"

limpia_pantalla:
        pshs a,b
          lda 0xFF02 ;teclado
          ldx #clear
          jsr imprime_cadena
        puls a,b
        rts
