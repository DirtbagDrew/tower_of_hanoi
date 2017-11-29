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
askForDiskCount: .asciiz "\nEnter the number of disks: "

disc1: 	.asciiz "X            " #using 13 characters total
disc2:  .asciiz "XX           "
disc3:  .asciiz "XXX          "
disc4:  .asciiz "XXXX         "
disc5:  .asciiz "XXXXX        "
disc6:  .asciiz "XXXXXX       "
disc7:  .asciiz "XXXXXXX      "
disc8:  .asciiz "XXXXXXXX     "
disc9:  .asciiz "XXXXXXXXX    "
disc10: .asciiz "XXXXXXXXXX   "
nodisc: .asciiz "             "

.text
li $s0, 'A'		# from_rod = 'A' 
li $s1, 'B'		# to_rod = 'B'
li $s2, 'C'		# aux_rod = 'C'

main:
li  $v0, 4
la  $a0, askForDiskCount	# prompts user to enter disk count they want
syscall

li $v0, 5		# gets disk count from user 
syscall

add  $a0, $v0, $zero 	# load user identified disk count into n 
addi $a1, $0, 1		# from_rod
addi $a2, $0, 3		# to_rod
addi $a3, $0, 2		#aux_rod

addi $t3, $zero, 1	
addi $t4, $zero, 2	
addi $t5, $zero, 3	
jal towerOfHanoi

j End

towerOfHanoi:
addi $sp, $sp, -20	# adjust stack for 5 items: 4 arguments and 1 address

sw $ra, 16($sp)		# save address
sw $a3, 12($sp)		# save aux_rod
sw $a2, 8($sp)		# save to_rod
sw $a1, 4($sp)		# save from_rod
sw $a0, 0($sp)		# save n

slti $t0, $a0, 2 	# if n < 2, then t0 = 1

beq $t0, $0, continue # branch of n >= 2

addi $sp, $sp, 20 	# pop 5 items from the stack

#print move

jr $ra			# return after printing

continue: 
addi $a0, $a0, -1 	# n - 1
addi $t0, $a2, 0	# create temp for to_rod
addi $a2, $a3, 0	# set to_rod to value of aux_rod
addi $a3, $t0, 0	# set aux_rod to value of to_rod

jal towerOfHanoi

lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $a3, 12($sp)
lw $ra, 16($sp)

addi $a0, $a0, -1 	# n - 1
addi $t0, $a1, 0	# create temp for from_rod
addi $a1, $a3, 0	# set from_rod to value of aux+rod
addi $a3, $t0, 0	# set aux_rod to value of from_rod

#print move

jal towerOfHanoi

lw $ra, 16($sp)
addi $sp, $sp, 20 	# pop 5 items from the stack

lw $a0, 0($sp)

jr $ra

End:
