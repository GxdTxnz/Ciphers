section .data
;записывать ключи

number DB '00000000',0ah
	len  equ $ - number

exit_message DB 'Ошибка '
exit_len  equ $ - exit_message

key1 DD 0x11111111
key2 DD 0x11111111
key3 DD 0x11111111
key4 DD 0x11111111
key5 DD 0x11111111
key6 DD 0x11111111
key7 DD 0x11111111
key8 DD 0x11111111

P0	 DD  12, 4, 6, 2, 10, 5, 11, 9, 14, 8, 13, 7, 0, 3, 15, 1
P1	 DD  6, 8, 2, 3, 9, 10, 5, 12, 1, 14, 4, 7, 11, 13, 0, 15
P2	 DD  11, 3, 5, 8, 2, 15, 10, 13, 14, 1, 7, 4, 12, 9, 6, 0
P3	 DD  12, 8, 2, 1, 13, 4, 15, 6, 7, 0, 10, 5, 3, 14, 9, 11
P4	 DD  7, 15, 5, 10, 8, 1, 6, 13, 0, 9, 3, 14, 11, 4, 2, 12
P5	 DD  5, 13, 15, 6, 9, 2, 12, 10, 11, 7, 8, 1, 4, 3, 14, 0
P6	 DD  8, 14, 2, 5, 6, 9, 1, 12, 15, 4, 11, 0, 13, 10, 3, 7
P7	 DD  1, 7, 14, 13, 0, 5, 8, 3, 4, 15, 10, 6, 9, 12, 11, 2

block_a1 DD 0x11111111 ; левая часть
block_a0 DD 0x11111111 ; правая часть	


argv1 DD 0
fd1 DD -1
fd2 DD -1
fdKey DD -1

buffer DD 0

section .text
	global _start
_start:
	
pop ebx ; argc
pop ebx ; argv [0]

pop ebx ; argv [1] файл исх.текста
mov eax , 5 ; sys_open
mov ecx , 0
mov edx , 0
int 0x80
mov [fd1], eax

pop ebx ; argv [2] файл шифр.текста
mov eax , 5 ; sys_open
mov ecx , 2 
mov edx , 0
int 0x80
mov [fd2], eax

pop ebx ; argv [3] файл ключа
mov eax , 5 ; sys_open
mov ecx , 0 ; O_RDONLY = 0
mov edx , 0
int 0x80
mov [fdKey], eax

mov eax , 3
mov ebx , [fdKey]
mov ecx , key1
mov edx , 32
int 0x80

cmp eax, 32
jne error_Key


mov eax , 6 ; sys_open
mov ebx, [fdKey]
int 0x80


mov eax , 19
mov ebx , [fd1]
mov ecx , 0
mov edx , 2; в конец, в еах длина от начала до конца файла в байтах
int 0x80
push eax
mov eax , 19
mov ebx , [fd1]
mov ecx , 0
mov edx , 0; в начало
int 0x80
pop eax

mov ebx, eax
shr  ebx, 3 ; деление на 8
and eax, 7
cmp eax, 0

je notadd1
add ebx, 1
notadd1:
mov ecx, ebx

Cycle:
cmp ecx, 1
push ecx
jne notLastBlock
mov ebx, 0h
mov [block_a0], ebx
mov [block_a1], ebx
notLastBlock:

mov eax , 3
mov ebx , [fd1]
mov ecx , block_a1
mov edx , 8
int 0x80




mov cx, 32

Magma:
	xor edx, edx
	mov eax, [block_a0]

	cmp cx, 32
	jne beginkey2
	keystep1:
	mov ebx, [key1]
	jmp endkey

beginkey2:
	cmp cx, 31
	jne beginkey3
	keystep2:
	mov ebx, [key2]
	jmp endkey

beginkey3:
	cmp cx, 30
	jnz beginkey4
	keystep3:
	mov ebx, [key3]
	jmp endkey

beginkey4:
	cmp cx, 29
	jnz beginkey5
	keystep4:
	mov ebx, [key4]
	jmp endkey
beginkey5:
	cmp cx, 28
	jnz beginkey6
	keystep5:
	mov ebx, [key5]
	jmp endkey
beginkey6:
	cmp cx, 27
	jnz beginkey7
	keystep6:
	mov ebx, [key6]
	jmp endkey
beginkey7:
	cmp cx, 26
	jnz beginkey8
	keystep7:
	mov ebx, [key7]
	jmp endkey
beginkey8:
	cmp cx, 25
	jnz beginkey9
	keystep8:
	mov ebx, [key8]
	jmp endkey
beginkey9:

	cmp cx, 24
	je keystep1

	cmp cx, 23
	je keystep2

	cmp cx, 22
	je keystep3

	cmp cx, 21
	je keystep4

	cmp cx, 20
	je keystep5

	cmp cx, 19
	je keystep6

	cmp cx, 18
	je keystep7

	cmp cx, 17
	je keystep8

	cmp cx, 16
	je keystep1

	cmp cx, 15
	je keystep2

	cmp cx, 14
	je keystep3

	cmp cx, 13
	je keystep4

	cmp cx, 12
	je keystep5

	cmp cx, 11
	je keystep6

	cmp cx, 10
	je keystep7

	cmp cx, 9
	je keystep8

	cmp cx, 8
	je keystep8

	cmp cx, 7
	je keystep7

	cmp cx, 6
	je keystep6

	cmp cx, 5
	je keystep5

	cmp cx, 4
	je keystep4

	cmp cx, 3
	je keystep3

	cmp cx, 2
	je keystep2

	cmp cx, 1
	je keystep1


endkey:

	add eax, ebx ; сложение по модулю 2^32


Transformation_t:
		
	push eax

	and eax, 0xF ; получить a(i)
	mov ebx, [P0+eax*4] ;получить p(i)
	shl ebx, 28
	add edx, ebx
	shr edx, 4 

	pop eax
	shr eax, 4 
	push eax

	and eax, 0xF ; получить a(i)
	mov ebx, [P1+eax*4] ;получить p(i)
	shl ebx, 28
	add edx, ebx
	shr edx, 4 

	pop eax
	shr eax, 4 
	push eax 	

	and eax, 0xF ; получить a(i)
	mov ebx, [P2+eax*4] ;получить p(i)
	shl ebx, 28
	add edx, ebx
	shr edx, 4 

	pop eax
	shr eax, 4 
	push eax 

	and eax, 0xF ; получить a(i)
	mov ebx, [P3+eax*4] ;получить p(i)
	shl ebx, 28
	add edx, ebx
	shr edx, 4 

	pop eax
	shr eax, 4 
	push eax 

	and eax, 0xF ; получить a(i)
	mov ebx, [P4+eax*4] ;получить p(i)
	shl ebx, 28
	add edx, ebx
	shr edx, 4 

	pop eax
	shr eax, 4 
	push eax 

	and eax, 0xF ; получить a(i)
	mov ebx, [P5+eax*4] ;получить p(i)
	shl ebx, 28
	add edx, ebx
	shr edx, 4 

	pop eax
	shr eax, 4 
	push eax 

	and eax, 0xF ; получить a(i)
	mov ebx, [P6+eax*4] ;получить p(i)
	shl ebx, 28
	add edx, ebx
	shr edx, 4 

	pop eax
	shr eax, 4 

	and eax, 0xF ; получить a(i)
	mov ebx, [P7+eax*4] ;получить p(i)
	shl ebx, 28
	add edx, ebx

	rol edx, 11
	
	mov ebx, [block_a1]; левая часть
	xor edx, ebx

cmp cx, 1
JE step_32
	
	mov ebx,[block_a0]
	mov [block_a1],  ebx ; старое содержимое правой половины переносится в левую половину
	mov [block_a0],  edx ; получившееся  число записывается в правую половину блока

	DEC CX
	cmp cx, 0
    	JNE Magma
step_32:
	mov [block_a1],  edx ; полученный результат пишется в левую часть


mov eax , 4
mov ebx , [fd2]
mov ecx , block_a1
mov edx , 8
int 0x80


pop ecx
dec ecx
cmp ecx, 0
JNE Cycle

mov eax, 1
mov ebx, 0
int 0x80

error_Key:

	mov eax,4
	mov ebx,1
	mov ecx, exit_message
	mov edx, exit_len
	int 0x80

mov eax, 1
mov ebx, 0
int 0x80