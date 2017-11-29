.data
tower1: .space 100
tower2: .space 100
tower3: .space 100
newLine: .asciiz "\n"
blank: .asciiz "|\n"

ex: .asciiz "x"

number_prompt:  .asciiz "Please enter the next number.  Enter -1 when done: "

.text
la $s5, tower1		# allocate array tower1 to $s5
la $s6, tower2		# allocate array tower2 to $s6
la $s7, tower3		# allocate array tower3 to $s7

li $t0, 25 # t0 is a constant n
li $t1, 0 # t1 is our counter (i)
add $t7, $t1,1

loop:
beq $t1, $t0, refresh_counter # if t1 == 10 we are done
sll $t2, $t1, 2		# multiply t1 by 4

add $t3,$t2,$s5		# $t3 = $tower1[i]
add $t4,$t2,$s6		# $t4 = $tower1[i]
add $t5,$t2,$s6		# $t5 = $tower1[i]

sw $t7, 0($t3)		# tower1[i] = i
sw $0, 0($t4)		# tower2[i] = 0
sw $0, 0($t5)		# tower3[i] = 0

addi $t1, $t1, 1 # add 1 to t1
add $t7, $t7,1
j loop # jump back to the top

refresh_counter:
li $t1, 0 # t1 is our counter (i)
j print_loop

print_loop:
beq $t1, $t0, end # if t1 == 10 we are done

sll $t2, $t1, 2		# multply t1 by 4

add $t3,$t2,$s5		# $t3 = $tower1[i]
add $t4,$t2,$s6		# $t4 = $tower1[i]
add $t5,$t2,$s7		# $t5 = $tower1[i]

lw $s0, 0($t3)		# tower1[i] = i
lw $s1, 0($t4)		# tower2[i] = 0
lw $s2, 0($t5)		# tower3[i] = 0

beq $s0, 0, num0
j numgreater0

num0:
li $v0, 4 
la $a0, blank
syscall
j increment

numgreater0:
#sub $a0,$s0,1
#add $a0,$s0,$0 # t0 is a constant 10
#li $a1, 0 # t1 is our counter (i)

#xloop:
add $a1,$s0,$0 # t0 is a constant 10
li $a2, 0 # t1 is our counter (i)
xxloop:
beq $a2, $a1, xend # if t1 == 10 we are done

li $v0, 4 
la $a0, ex
syscall

addi $a2, $a2, 1 # add 1 to t1
j xxloop # jump back to the top

xend:
li $v0, 4 
la $a0, newLine
syscall
j increment

increment:
addi $t1, $t1, 1 # add 1 to t1
j print_loop # jump back to the top

end:


#-------------------------------------
# prints as numbers
#-------------------------------------
#li $v0, 1 
#la $a0, ($s0)
#syscall

#li $v0, 1 
#la $a0, ($s1)
#syscall

#li $v0, 1 
#la $a0, ($s2)
#syscall

#li $v0, 4 
#la $a0, newLine
#syscall
#--------------------------------------


