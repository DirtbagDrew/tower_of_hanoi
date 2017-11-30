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

disc1: 	 .asciiz "X            " #using 13 characters total
disc2:   .asciiz "XX           "
disc3:   .asciiz "XXX          "
disc4:   .asciiz "XXXX         "
disc5:   .asciiz "XXXXX        "
disc6:   .asciiz "XXXXXX       "
disc7:   .asciiz "XXXXXXX      "
disc8:   .asciiz "XXXXXXXX     "
disc9:   .asciiz "XXXXXXXXX    "
disc10:  .asciiz "XXXXXXXXXX   "
nodisc:  .asciiz "             "
newLine: .asciiz "\n"

.text

la $s0, 0x100100c0 	# s0 = address of firt column array, length = 10
la $s1, 0x100100e8	# s1 = address of second column array, length = 10
la $s2, 0x10010110	# s2 = address of third column array, length = 10

main:
li  $v0, 4
la  $a0, askForDiskCount	# prompts user to enter disk count they want
syscall

li $v0, 5		# gets disk count from user 
syscall

add  $a0, $v0, $zero 	# load user identified disk count into n 
addi $s3, $a0, 0	# set s3 to n

# load discs into initial position

addi $t0, $0, 1		# t0 = 1
addi $t4, $0, 0		# t4 = 0

addi $t1, $s0, 0	# save initial value of s0 which is address of A
addi $t2, $s1, 0	# save initial value of s0 which is address of A
addi $t3, $s2, 0	# save initial value of s0 which is address of A

loop:
blt  $a0, $t0, endLoop	# end loop if a0 < t0
sw $t0, 0($s0)		# save t0 into s0
sw $t4, 0($s1)		# save 0 into s1
sw $t4, 0($s2)		# save 0 into s2

addi $t0, $t0, 1	# increment t0 by 1
addi $s0, $s0, 4	# increment s0 by 4 to go to next address
addi $s1, $s1, 4	# increment s1 by 4 to go to next address
addi $s2, $s2, 4	# increment s2 by 4 to go to next address

j loop

endLoop:

addi $s0, $t1, 0	#reset s0 to be the initial address of column 1
addi $s1, $t2, 0	#reset s0 to be the initial address of column 2
addi $s2, $t3, 0	#reset s0 to be the initial address of column 3

addi $a1, $0, 1		# set from_rod
addi $a2, $0, 3		# set to_rod
addi $a3, $0, 2		# set aux_rod

jal towerOfHanoi

j exit

towerOfHanoi:
addi $sp, $sp, -20	# adjust stack for 5 items: 4 arguments and 1 address

sw $ra, 16($sp)		# save address
sw $a3, 12($sp)		# save aux_rod
sw $a2, 8($sp)		# save to_rod
sw $a1, 4($sp)		# save from_rod
sw $a0, 0($sp)		# save n

slti $t0, $a0, 2 	# if n < 2, then t0 = 1

beq $t0, $0, continue   # branch if n >= 2

addi $sp, $sp, 20 	# pop 5 items from the stack

addi $t3, $ra, 0	# store ra
jal moveDisc		#moves disc in stack using current argument values	
#print move
addi $ra, $t3, 0	# reset ra

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

addi $t3, $ra, 0	# store ra
jal moveDisc		#moves disc in stack using current argument values	
#print move
addi $ra, $t3, 0	# reset ra

addi $a0, $a0, -1 	# n - 1
addi $t0, $a1, 0	# create temp for from_rod
addi $a1, $a3, 0	# set from_rod to value of aux+rod
addi $a3, $t0, 0	# set aux_rod to value of from_rod

jal towerOfHanoi

lw $ra, 16($sp)
addi $sp, $sp, 20 	# pop 5 items from the stack

lw $a0, 0($sp)

jr $ra

moveDisc:
addi $t2, $ra, 0	# save return address
jal findFromRodValue	# finds value of top disc of from_rod and stores it in $v0
jal findToRod		# finds which rod the to_rod is and stores address in v1

addi $t1, $0, 1		# incrementer to check if whole array is 0

	findAddressLoop:
	lw  $t0, 0($v1)			# load value of index of to_rod into t0
	bne $t0, $0, addressFound	# if value at index of to_rod != 0, then the first disc is found
	beq $t1, $s3, rodEmpty		# leaves loop if all indexes of rod are 0
	addi $v1, $v1, 4		# increment address of to_rod if value not found yet
	addi $t1, $t1, 1		# increment t1
	j findAddressLoop
	
	addressFound:
	addi $v1, $v1, -4	# go back to first empty space before top disc
	sw $v0, 0($v1)
	
	rodEmpty:
	sw $v0, 0($v1)
	
addi $ra, $t2, 0		# reset ra

jr $ra

findFromRodValue:
	
	findFromRod:			# returns address of from_rod in v0
	addi $t0, $0, 1			# set incrementer to 0
	beq  $t0, $a1, from_rodIs1	# branch if the from_rod = 1

	addi $t0, $t0, 1		# increment t0 by 1
	beq  $t0, $a1, from_rodIs2	# branch if the from_rod = 2

	addi $t0, $t0, 1		# increment t0 by 1
	beq  $t0, $a1, from_rodIs3	# branch if the from_rod = 3

	from_rodIs1:
	addi $v0, $s0, 0	# set address of rod 1 to v0 and return
	j fromRodFound
	
	from_rodIs2:
	addi $v0, $s1, 0	# set address of rod 2 to v0 and return
	j fromRodFound
	
	from_rodIs3:
	addi $v0, $s2, 0	# set address of rod 3 to v0 and return
	j fromRodFound
	
	fromRodFound:
	
		addi $t1, $0, 1		# incrementer to check if whole array is 0
		findValueLoop:
		lw  $t0, 0($v0)		# load value of top index of from_rod
		bne $t0, $0, valueFound	# if value at index of from_rod != 0, then the first disc is found
		#beq $t1, $s3, empty		# leaves loop if all indexes of rod are 0
		addi $v0, $v0, 4	# increment address of from_rod if value not found yet
		addi $t1, $t1, 1		# increment t1
		j findValueLoop
		
	#empty: 
	
		
	valueFound:
	addi $t1, $0, 0
	sw   $t1, 0($v0)	# save 0 to former index of top disc
	addi $v0, $t0, 0	# set v0 to top disc index
	jr $ra			# return to moveDisc
	

findToRod:			# returns address of to_rod in v1
addi $t0, $0, 1			# set incrementer to 0
beq  $t0, $a2, to_rodIs1	# branch if the to_rod = 1

addi $t0, $t0, 1		# increment t0 by 1
beq  $t0, $a2, to_rodIs2	# branch if the to_rod = 2

addi $t0, $t0, 1		# increment t0 by 1
beq  $t0, $a2, to_rodIs3	# branch if the to_rod = 3

	to_rodIs1:
	addi $v1, $s0, 0	# set address of rod 1 to v1 and return
	jr $ra
	
	to_rodIs2:
	addi $v1, $s1, 0	# set address of rod 2 to v1 and return
	jr $ra
	
	to_rodIs3:
	addi $v1, $s2, 0	# set address of rod 3 to v1 and return
	jr $ra


exit:
