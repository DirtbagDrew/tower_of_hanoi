# CECS 341 Computer Architecture
# Lab Project 3
# Tower of Hanoi
# Andrew Myer
# Jacob Parcell
# 11/30/17
#
# convert the following c code to mips *update* pretty different than C code
# C Code
# void towerOfHanoi(int n, char from_rod, char to_rod, char aux_rod)
# {
#     if (n == 1)
#     {
#         printf("n Move disk 1 from rod %c to rod %c", from_rod, to_rod);
#         return;
#     }
#     towerOfHanoi(n-1, from_rod, aux_rod, to_rod);
#     printf("n Move disk %d from rod %c to rod %c", n, from_rod, to_rod);
#     towerOfHanoi(n-1, aux_rod, to_rod, from_rod);
# }
#  
# int main()
# {
#     int n = 4; // Number of disks
#     towerOfHanoi(n, 'A', 'C', 'B');  // A, B and C are names of rods
#     return 0;
# }

# n = $t0
# $s0 = from_rod
# $s1 = to_rod
# $s2 = aux_rod
.data
askForDiskCount:
	.asciiz "\nEnter the number of disks: "
.text
li $s0, 'A'		# from_rod = 'A' 
li $s1, 'B'		# to_rod = 'B'
li $s2, 'C'		# aux_rod = 'C'

main:
li  $v0, 4
la $a0, askForDiskCount	# prompts user to enter disk count they want
syscall

li $v0, 5		# gets disk count from user 
syscall
add $t0, $v0, $zero 	# load user identified disk count into n 

add $a0,$0,$t0		# load n into $a0
addi $a1,$0,1		# numbers for each tower number
addi $a2,$0,2
addi $a2,$0,3

addi $t3, $zero, 1	
addi $t4, $zero, 2	
addi $t5, $zero, 3	
#jal towerOfHanoi

#j End

#towerOfHanoi:
#slti $t1, $a0, 1
#beq $t1, $t3, End	# if n < 1 end the program



#End:

#--------------------------checking if works---------------------------------------------
jal hanoi		#call hanoi for the first time
    
    ################################
    # When done, print exit prompt #
    ################################
    #li 	$v0, 4;      
    #la 	$a0, Exit;    			
    #syscall;
    
####################################################   
# Hanoi: the number if disks can be found in $a0   #
####################################################
hanoi:
	
	slti $t1, $a0, 1
	beq $t1, $t3, End	#if n<1, do nothing, end
	
	addi $sp, $sp, -20
	sw $ra, 0($sp)		#saves return address
	sw $a0, 4($sp)		#saves n on stack
	sw $a1, 8($sp)		#saves peg 1 on stack
	sw $a2, 12($sp)		#saves peg 2 on stack
	sw $a3, 16($sp)		#saves peg 3 on stack
	
	addi $a0, $a0, -1	#n = n-1
	
	############################################################
	#	This switches the pegs around			   #
	############################################################
	move $t2, $a2		#saves a2
	move $a2, $a3		#Changes destination to middle peg
	move $a3, $t2		#changes middle peg to final peg
	############################################################
	#							   #
	############################################################
	
	jal hanoi		#First recursive call with pegs switched
	
	lw $ra, 0($sp)		#loads return address
	lw $a0, 4($sp)		#loads n
	lw $a1, 8($sp)		#loads peg 1
	lw $a2, 12($sp)		#loads peg 2
	lw $a3, 16($sp)		#loads peg 3
	add $sp, $sp, 20
	
	#######################################
	#  Branches for printing prompts      #
	#######################################
	beq $a1, $t3, FromA	#if source is A
	beq $a1, $t4, FromB	#if source is B
	beq $a1, $t5, FromC	#if source is C
	#######################################
	# 				      #
	#######################################
	
hanoi2:

	addi $sp, $sp, -20
	sw $ra, 0($sp)		#saves return address
	sw $a0, 4($sp)		#saves n
	sw $a1, 8($sp)		#saves peg 1
	sw $a2, 12($sp)		#saves peg 2
	sw $a3, 16($sp)		#saves peg 3
	
	move $t6, $a1		#saves a1 for peg switch
	move $t7, $a2		#saves a2 for peg switch
	
	############################################################
	#	This switches the pegs around			   #
	############################################################
	move $a1, $a2		# Moves spare peg to source peg
	move $a2, $t6		# Moves source peg to spare peg		
	############################################################
	#							   #
	############################################################
	
	addi $a0, $a0, -1	#n = n-1
	jal hanoi		#second recursive call with pegs rearranged
	
	lw $ra, 0($sp)		#loads address after the first hanoi call
	addi $sp, $sp, 20
	jr $ra
End:
	jr $ra