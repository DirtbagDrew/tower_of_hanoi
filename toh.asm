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
jal towerOfHanoi

j End

towerOfHanoi:
slti $t1, $a0, 1
beq $t1, $t3, End	# if n < 1 end the program



End:
