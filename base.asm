.model small
.stack 256
.data

;========================Variables declaradas aqui===========================
LETRERO DB 'INSERTE LA CADENA:INSERTE LA CADENA:INSERTE LA CAD$'	; Cadena a desplegar
buf db 51 dup (0)			                                        ; buffer de lectura de cadena

;============================================================================
.code
main:	
	mov ax,@data
	mov ds,ax
	mov es, ax              ;set segment register
    and sp, not 3           ;align stack to avoid AC fault
;====================================Código==================================  
mov ax,0b800h
mov es,ax					;segmento dir. de mem de video.
xor bx,bx					;puntero para video
xor di,di					;puntero letrero

ok:
mov al,letrero[di]			;leo caracter
cmp al,'$'					;verifico si terminó la candena
je fin						; 	
mov es:[bx],al				;coloco en pantalla
add bx,1					;apunto a atributo caracter en la pantalla
mov es:[bx],al				;coloco en pantalla
inc bx						;apunto a próximo caracter
inc di						;apunto a próximo caracter en la cadena
jmp ok

fin:
;============================================================================

.exit
;================================Funciones aqui==============================

printf:; espera en dl el caracter a mostrar.

push ax bx cx dx		;
mov ah,02				;para mostrar caracter
int 21h					;muestra caracter en pantalla


pop dx cx bx ax			;
ret						;

;============================================================================
end main


















