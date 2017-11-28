# CECS 341 Computer Architecture
# Lab Project 3
# Tower of Hanoi
# Andrew Myer
# Jacob Parcell
# 11/30/17
#
# convert the following c code to mips
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

# n = $s0
# $s1 = from_rod
# $s2 = to_rod
# $s3 = aux_rod
.data

.text
li $s1, 'A'	# from_rod = 'A' 
li $s2, 'B'	# to_rod = 'B'
li $s3, 'C'	# aux_rod = 'C'

main:
addi $s0,$s0,4	# int n = 4; // Number of disks

towerOfHanoi:
jr    $ra  
