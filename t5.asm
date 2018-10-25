
.model small
.stack 256
.data

;========================Variables declaradas aqui===========================
letreromsj DB 'Hola Hola        asdasd  asdas   $'	; Cadena a desplegar

letrero DB 'Digite el archivo a leer -->: $'
uncaracter db 1 dup (' ')    
error1 DB 'El archivo no pudo ser abierto o no existe : $'
; texto a solicita la cadena
arregloConDatos db 51 dup (0)           ; buffer de lectura de cadena
filename db "myfile.txt", 0 ;C:\asm\asm_work_file\mifile.txt
puntero dw ?
;============================================================================

; tratando de hacer una funcion
	printf macro texto				; espera en dl el caracter a mostrar.
	mov ah,09                    ; Para mostrar en pantalla una cadena
	mov dx, offset texto       ; posición de la cadena a montar
	int 21h                      ; llamó al sistema
	endm
; tratando de hacer una funcion
.code
main:	
	mov ax,@data
	mov ds,ax
	mov es, ax              ;set segment register
    and sp, not 3           ;align stack to avoid AC fault
;====================================Código==================================
	printf letrero
;====================================leer el archivo a buscar==================================
ciclodelectura:
	mov ah,01                    ; para lectura de teclado.
	int 21h                      ; llamada al SO
	cmp al,13                    ; verificar si se pulsa el Enter.
	je leer_archivo     ; saltamos a solicitar el caracter si presiona enter
	mov arregloConDatos[bx],al   ; copiar el carácter tomado en el buffer.
	cmp bx,50                    ; verificó si debo de salir.
	je leer_archivo     ; si escribimos más de 50 caracteres dejo de leer
	inc bx                       ; apuntó a la sgte. posición del buffer.
	jmp ciclodelectura           ; continuó leyendo
;====================================Abrir el archivo==================================
leer_archivo:
	mov ah, 3dh
	mov cx, 0
	mov al, 2 
	mov dx, offset filename;arregloConDatos
	int 21h
	jc error
	mov puntero, ax
	jmp imprimir_archivo

;====================================Error al abrir el archivo==================================
	error: 
	printf error1       ; posición de la cadena a montar
	jmp fin 

imprimir_archivo:
	mov ax,0b800h
	mov es,ax	
	mov bx, 0
	call limpia
print_pantalla:				;segmento dir. de mem de video.
	mov bx, 0					;puntero para video
	mov di, 0					;puntero letrero

	ok:
	call leer_caracter          ;mov al,arregloConDatos[di]
	cmp ax,0					;verifico si terminó la candena
	je fin	
	mov al,uncaracter
	;cmp al,10  					;verifico si terminó la candena
	;je enter_
	mov es:[bx], al				;coloco en pantalla
	inc bx	
	inc bx					;apunto a próximo caracter
	jmp ok
	
	leer_caracter:; espera en dl el caracter a mostrar.
	push bx cx dx		;
	mov ah,3fh				;para mostrar caracter
	mov bx,puntero
	mov dx,offset uncaracter
	mov cx,1
	int 21h						; 
	pop dx cx bx			;
	ret						;
enter_:
	push ax cx dx		;
	;add bx ,1		; 
	pop dx cx  ax			;
	ret						


limpia:		;
	mov al,' ' 
	mov es:[bx], al				;coloco en pantalla
	cmp bx, (80*80*2)+(25*2)
	je print_pantalla
	inc bx
	jmp limpia 		;	


fin:
	;cerrar archivo 
	mov ah, 3eh
	mov bx , puntero
	int 21h
;============================================================================
.exit
;================================Funciones aqui==============================
					;

;============================================================================
end main