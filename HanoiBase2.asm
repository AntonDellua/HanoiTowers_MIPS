#HANOI TOWERS
#
#Made by Anton Delgadillo, Luis Alberto and Macias Castillon, Alondra Itzel
#
#ToDo:
#1. Optimize and go for the record!
.data

.text
	addi $a0, $0, 8 # n
	addi $a1, $0, 0x10010000 # Source Tower, src
	addi $a2, $0, 0x10010020 # Auxiliar Tower, aux
	addi $a3, $0, 0x10010040 # Destination Tower, des
	add $t0, $a0, $0 # Store n in temp for loop
LOOP:
	sw $t0, 0($a1) # Store top disk
	addi $t0, $t0, -1 # Decrease n by 1
	addi $a1, $a1, 4 # Increase src
	bne $t0, $0, LOOP # n must be 0
	# Hanoi(disk, src, aux, des)
	jal HANOI
	j EXIT
HANOI:
	# If (n==2)
	bne $a0, 2, ELSE
	lw $t0, -4($a1) # Retrieve top disk from src
	sw $0, -4($a1) # Delete it to complete Pop from src
	sw $t0, 0($a2) # Save it on aux
	addi $a2, $a2, 4 # Increse aux
	addi $a1, $a1, -4 # Decrease src
	lw $t0, -4($a1) # Retrieve top disk from src
	sw $0, -4($a1) # Delete it to complete Pop from src
	sw $t0, 0($a3) # Save it on des
	addi $a3, $a3, 4 # Increse des
	addi $a1, $a1, -4 # Decrease src
	lw $t0, -4($a2) # Retrieve top disk from aux
	sw $0, -4($a2) # Delete it to complete Pop from src
	sw $t0, 0($a3) # Save it on des
	addi $a3, $a3, 4 # Increse des
	addi $a2, $a2, -4 # Decrease aux
	jr $ra
ELSE:
	# Recursive Stack Init
	addi $sp, $sp, -8 # Prepare Stack
	sw $ra, 4($sp) # Push $ra
	sw $a0, 0($sp) # Push n
	# Hanoi(disk-1, src, des, aux)
	addi $a0, $a0, -1 # n--
	# Swap aux and des
	add $t0, $a2, $0
	add $a2, $a3, $0
	add $a3, $t0, $0

	jal HANOI

	# Swap aux and des
	add $t0, $a2, $0
	add $a2, $a3, $0
	add $a3, $t0, $0
	# Move disk
	lw $t0, -4($a1) # Retrieve top disk from src
	sw $0, -4($a1) # Delete it to complete Pop from src
	sw $t0, 0($a3) # Save it on des
	addi $a3, $a3, 4 # Increse des
	addi $a1, $a1, -4 # Decrease src
	# Swap src and aux
	add $t0, $a2, $zero
	add $a2, $a1, $zero
	add $a1, $t0, $zero

	jal HANOI

	# Swap src and aux
	add $t0, $a2, $zero
	add $a2, $a1, $zero
	add $a1, $t0, $zero
	# Recursive Stack Recover
	lw $ra, 4($sp) # Pop $ra
	lw $a0, 0($sp) # Pop n
	addi $sp, $sp, 8 # Release Stack

	jr $ra
EXIT: