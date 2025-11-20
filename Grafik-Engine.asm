.data

# Array A
a_arr: .float 1, 2, 3
b_arr: .float 1, 2, 3
dimension: .word 3

# Messages
msga: .ascii "Insira o Array A: \0"
msgb: .ascii "Insira o Array B: \0"

msgsum: .ascii "Soma AzBz AyBy AxBx\n\0"
msgpe: .ascii "Produto Escalar\n\0"
msgmag: .ascii "\nMagnetude\n\0"
msgnor: .ascii "\nNormalização\n\0"
endl: .ascii "\n\0"

.text

# Load dimensions and array
lw $t0, dimension
la $t1, a_arr


# A loop
A_loop:
beq $t0 ,$zero, a_exit_loop


li $v0, 4
la $a0, msga
syscall

li $v0, 6
syscall

s.s $f0, ($t1) # save number in array


add $t1, $t1, 4
subi $t0, $t0, 1
j A_loop

a_exit_loop:

lw $t0, dimension
la $t2, b_arr

# B loop
B_loop:
beq $t0 ,$zero, b_exit_loop


li $v0, 4
la $a0, msgb
syscall

li $v0, 6
syscall

s.s $f0, ($t2)


add $t2, $t2, 4
subi $t0, $t0, 1
j B_loop

b_exit_loop:

li $v0, 4
la $a0, msgsum
syscall

# Calc sum loop
lw $t0, dimension
sum_loop:
	beq $t0 ,$zero, sum_exit_loop
	
	subi $t1, $t1, 4
	subi $t2, $t2, 4
	
	l.s $f8, ($t1)
	l.s $f6, ($t2)
	
	#Makes the sum
	add.s $f12, $f6, $f8
	
	li $v0, 2 # Print sum
	syscall
	
	# Store mul for the scalar product
	mul.s $f12, $f6, $f8
	add.s $f4, $f4, $f12
	
	mul.s $f14, $f8, $f8
	add.s $f2, $f2, $f14




	li $v0, 4
	la $a0, endl
	syscall


	subi $t0, $t0, 1
	j sum_loop

sum_exit_loop:


li $v0, 4
la $a0, msgpe
syscall

mov.s $f12, $f4
li $v0, 2
syscall

li $v0, 4
la $a0, msgmag
syscall

# Magnetude
sqrt.s $f2, $f2
mov.s $f12, $f2
li $v0, 2
syscall

li $v0, 4
la $a0, msgnor
syscall


lw $t0, dimension

norm_loop:
	beq $t0 ,$zero, norm_exit_loop
		
	l.s $f8, ($t1)
		
	div.s $f16, $f8, $f2
	
	li $v0, 2
	mov.s $f12, $f16
	syscall

	li $v0, 4
	la $a0, endl
	syscall

	addi $t1, $t1, 4
	subi $t0, $t0, 1
	j norm_loop

norm_exit_loop:


exit:
li $v0, 10
syscall
