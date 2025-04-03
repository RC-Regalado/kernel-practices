ORG 0
BITS 16

_start:
  jmp short start
  nop

times 33 db 0

start:
  jmp 0x7c0:step2


handle_zero:
  mov ah, 0eh
  mov al, '0'
  mov bx, 0
  int 0x10

  iret

step2:
  cli                  ; Deshabilita interrupciones
  mov ax, 0x7c0        ; Carga el segmento 0x7C0 en AX
  mov ds, ax           ; Configura el segmento de datos (DS)
  mov es, ax           ; Configura el segmento extra (ES)
  mov ax, 0x00         ; Limpia AX
  mov ss, ax           ; Configura el segmento de pila (SS) en 0x0000
  mov sp, 0x7c0        ; Configura el puntero de pila (SP) en 0x07C0
  sti                  ; Habilita interrupciones nuevamente

  mov word[ss:0x00], handle_zero
  mov word[ss:0x02], 0x7c0

  mov ax, 0x00
  div 
print:
  mov bx, 0
.loop
  lodsb
  cmp al, 0
  je .done
  call print_char
  jmp .loop
.done
  ret

print_char:
  mov ah, 0eh;
  int 0x10
  ret

times 510-($ - $$) db 0 
dw 0xAA55
