bits	64
section	.data
msg1:
	db	"Input x", 10, 0
msg2:
	db	"%f", 0
msg3:
	db	"  asinh(%.10f)=%.10f", 10, 0
msg4:
	db	"myasinh(%.10f)=%.10f", 10, 0
msg5:
	db  "Presision", 10, 0
msg6:
	db 	"Usage: ", 0
msg7:
	db	" filename", 10, 0
msg8:
	db	"ERROR: |x| < 1", 10, 0
mode:
	db	"w", 0
format:
	db "%d:	%.10f", 10, 0
section	.text
zero	dd	0.0
one	dd	1.0
two	dd	2.0
neg_one	dd	-1.0

extern	fprintf

myasinh:
	mov rdi, [rbp-file]
	xor	esi, esi
	mov esi, mode
	call fopen

	movss	xmm0, [rbp-x]
	movss	xmm1, [rbp-pr]
	movss	xmm2, [rbp-x]
	movss	xmm3, [rbp-x]

	push	rbp
	mov rbp, rsp
	sub rsp, 80

	movss	xmm4, [one]
	movss	xmm5, [one]
	movss	xmm6, [one]
	movss	xmm7, [one]

	movss	[rbp-8], xmm0 
	movss	[rbp-16], xmm1 
	movss	[rbp-24], xmm2 
	movss	[rbp-32], xmm3 
	movss	[rbp-40], xmm4 
	movss	[rbp-48], xmm5 
	movss	[rbp-56], xmm6 
	movss	[rbp-64], xmm7 
	
	
	mov rdi, rax
	mov rsi, format
	cvtss2si edx, xmm5
	mov	[rbp-72], rax
	mov eax, 1
	movss 	xmm0, xmm3
	cvtss2sd	xmm0, xmm0
	call	fprintf
	mov rax, [rbp-72]

	movss	xmm0, [rbp-8]
	movss	xmm1, [rbp-16]
	movss	xmm2, [rbp-24]
	movss	xmm3, [rbp-32]
	movss	xmm4, [rbp-40]
	movss	xmm5, [rbp-48]
	movss	xmm6, [rbp-56]
	movss	xmm7, [rbp-64]
	
.m0:
	movss	xmm4, xmm2
	mulss	xmm3, xmm0
	mulss	xmm3, xmm0
	movss	xmm6, xmm5
	mulss	xmm6, [two]
	subss	xmm6, [one]
	mulss	xmm3, xmm6
	mulss	xmm3, xmm6
	addss	xmm6, [one]
	divss	xmm3, xmm6
	addss	xmm6, [one]
	divss	xmm3, xmm6
	mulss	xmm3, [neg_one]
	addss	xmm2, xmm3
	addss	xmm5, [one]

	movss	[rbp-8], xmm0 
	movss	[rbp-16], xmm1 
	movss	[rbp-24], xmm2 
	movss	[rbp-32], xmm3 
	movss	[rbp-40], xmm4 
	movss	[rbp-48], xmm5 
	movss	[rbp-56], xmm6 
	movss	[rbp-64], xmm7 
	
	
	mov rdi, rax
	mov rsi, format
	cvtss2si edx, xmm5
	mov	[rbp-72], rax
	mov eax, 1
	movss 	xmm0, xmm3
	cvtss2sd	xmm0, xmm0
	call	fprintf
	mov rax, [rbp-72]

	movss	xmm0, [rbp-8]
	movss	xmm1, [rbp-16]
	movss	xmm2, [rbp-24]
	movss	xmm3, [rbp-32]
	movss	xmm4, [rbp-40]
	movss	xmm5, [rbp-48]
	movss	xmm6, [rbp-56]
	movss	xmm7, [rbp-64]

	movss	xmm7, xmm3
	ucomiss	xmm7, [zero]
	jae	.m1
	mulss	xmm7, [neg_one]
.m1:
	ucomiss	xmm7, xmm1
	jae	.m0
	movss	xmm0, xmm2
.exit:
	mov rdi, rax
	call fclose
	leave
	ret
x	equ	8
y	equ	x+8
pr  equ	y+8
file equ pr+8
extern	printf
extern 	fopen
extern 	fclose
extern	scanf
extern	asinh
global	main
main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, file

	cmp edi, 2
	jne	.error

	mov r15, [rsi+8]
	mov [rbp-file], r15 
.m0:
	mov	edi, msg1
	xor	eax, eax
	call	printf

	mov	edi, msg2
	lea	rsi, [rbp-x]
	xor	eax, eax
	call	scanf
.cmp1:
	movss	xmm0, [rbp-x]
	ucomiss	xmm0, [zero]
	jae	.next
	mulss	xmm0, [neg_one]
.next:
	ucomiss	xmm0, [one]
	jb .m1
	
	mov edi, msg8
	xor eax, eax
	call	printf
	
	jmp	.m0
.m1:
	mov edi, msg5
	xor	eax, eax
	call	printf

	mov edi, msg2
	lea rsi, [rbp-pr]
	xor eax, eax
	call	scanf

.asinh:
	movss	xmm0, [rbp-x]
	cvtss2sd	xmm0, xmm0
	call	asinh

	cvtsd2ss	xmm0, xmm0	
	movss	[rbp-y], xmm0
	mov	edi, msg3
	movss	xmm0, [rbp-x]
	movss	xmm1, [rbp-y]
	cvtss2sd xmm0, xmm0
	cvtss2sd xmm1, xmm1
	mov	eax, 2
	call	printf
.myasinh:
	movss	xmm0, [rbp-x]
	movss	xmm1, [rbp-pr]
	call	myasinh
	
	movss	[rbp-y], xmm0
	mov	edi, msg4
	movss	xmm0, [rbp-x]
	cvtss2sd	xmm0, xmm0
	movsd	xmm1, [rbp-y]
	cvtss2sd	xmm1, xmm1
	mov	eax, 2
	call	printf

	leave
	xor	eax, eax
	ret

.error:
	mov edi, msg6
	mov eax, 0
	call	printf
	mov rdi, [r13]
	mov eax, 0
	call	printf
	mov edi, msg7
	mov eax, 0
	call printf
	leave
	mov eax, 1
	ret
