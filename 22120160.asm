.data
array: .space 1000      
prompt1: .asciiz "Enter the number of elements (N > 0): "
prompt2: .asciiz "Enter the elements of the array:\n"
prompt3: .asciiz "The entered array:\n"
prompt4: .asciiz "Sum of prime elements: "
label: .asciiz "Please enter again the number of elements because N <= 0.\nPlease enter N > 0.\nEnter the number of elements (N > 0):"
comma_space: .asciiz ", "
newline: .asciiz "\n"

.text
main:
    jal input_array   
    jal print_array   
    jal calculate_sum
    jal print_sum
    li $v0, 10        
    syscall

input_array:
    li $v0, 4
    la $a0, prompt1
    syscall

    input_N:
    li $v0, 5
    syscall
    move $t0, $v0  

    blez $t0, input_array_error    #if N <= 0, re-enter N

    li $v0, 4
    la $a0, prompt2
    syscall

    la $t1, array
    li $t2, 0

input_loop:
    beq $t2, $t0, input_done 
    li $v0, 5
    syscall
    sw $v0, 0($t1)   
    addi $t1, $t1, 4 
    addi $t2, $t2, 1 
    j input_loop

input_done:
    jr $ra           

input_array_error:
    li $v0, 4
    la $a0, label
    syscall

    j input_N  
print_array:
    li $v0, 4
    la $a0, prompt3
    syscall

    li $t2, 0
    la $t1, array
    li $t3, 0           
print_loop:
    beq $t2, $t0, print_done   
    lw $a0, 0($t1)      
    li $v0, 1
    syscall
    
    addi $t3, $t3, 1    
    blt $t3, $t0, print_comma_space 
    
    j print_done         

print_comma_space:
    li $v0, 4           
    la $a0, comma_space
    syscall
    
    addi $t1, $t1, 4    
    addi $t2, $t2, 1    
    j print_loop

print_done:
    jr $ra           

is_prime:
    li $t6, 2          # So chia chay tu 2
    li $t1, 0
    blez $t5, not_prime
    beq $t5, 1, not_prime 

check_divisor_loop:
    bge $t6, $t5, end_check_divisor_loop 
    div $t5, $t6     
    mfhi $t7            
    beq $t7, $zero, increment_count   
    addi $t6, $t6, 1
    j check_divisor_loop 


end_check_divisor_loop:
    bne $t1, $0, not_prime 
    li $v0, 1
    jr $ra

not_prime:
    li $v0, 0       
    jr $ra
    
increment_count:
    addi $t1, $t1, 1   
    addi $t6, $t6, 1 
    j end_check_divisor_loop

sum_of_primes:
    li $t3, 0         	# Khoi tao tong = 0  
    la $t4, array       
    li $t2, 0		# Bien chay
    
    sub $sp, $sp, 4
    sw $ra, ($sp)    

sum_loop:
    bge $t2, $t0, end_sum_loop
    lw $t5, 0($t4)      
    jal is_prime        
    beq $v0, 0, not_prime_in_array 

    add $t3, $t3, $t5   
    addi $t4, $t4, 4    
    addi $t2, $t2, 1
    j sum_loop

not_prime_in_array:
    addi $t4, $t4, 4    
    addi $t2, $t2, 1
    j sum_loop

end_sum_loop:
    move $v0, $t3       
    lw $ra, ($sp)
    add $sp, $sp, 4
    jr $ra

calculate_sum:
    sub $sp, $sp, 4
    sw $ra, ($sp)
    jal sum_of_primes
    move $t4, $v0 
    lw $ra, ($sp)
    add $sp, $sp, 4
    jr $ra
  
print_sum:
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 4
    la $a0, prompt4
    syscall

    li $v0, 1
    move $a0, $t4
    syscall

    jr $ra
