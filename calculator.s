#
# Usage: ./calculator <op> <arg1> <arg2>
#

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

# int main(int argc, char argv[][])
main:
  # Function prologue
  enter $0, $0

  # Variable mappings:
  # op -> %r12
  # arg1 -> %r13
  # arg2 -> %r14
  movq 8(%rsi), %r12  # op = argv[1]
  movq 16(%rsi), %r13 # arg1 = argv[2]
  movq 24(%rsi), %r14 # arg2 = argv[3]


  # Hint: Convert 1st operand to long int
  # Converting 1st operand from a single word string to long int
  movq %r13, %rdi
  # Using atol function. rdi to convert using atol to rax.
  # Then transfer output of atol(rax) back to r13
  call atol
  movq %rax, %r13

  # Hint: Convert 2nd operand to long int
  # Similar to first operand conversion.
  movq %r14, %rdi
  # Using atol function. rdi to convert using atol to rax.
  # Then transfer output of atol(rax) back to r14
  call atol
  movq %rax, %r14

  # Hint: Copy the first char of op into an 8-bit register
  # i.e., op_char = op[0] - something like mov 0(%r12), ???
  mov 0(%r12), %r12b


  # if (op_char == '+') {
  # }
  # compare + with %r12b
  cmp $43, %r12b
  je addition

  # else if (op_char == '-') {
  # }
  # compare - with %r12b
  cmp $45, %r12b
  je subtraction

  # else if (op_char == '*') {
  # }
  # compare * with %r12b
  cmp $42, %r12b
  je multiplication

  # else if (op_char == '/') {
  # }
  cmp $47, %r12b
  je division

  # else {
  #   // print error
  # }
  jmp unknown_error

  addition:
    add %r14, %r13
    mov $format, %rdi
    # format the data
    mov %r13, %rsi
    # mov r13 to rsi to print
    # call printing function

    jmp printing_output


  subtraction:
    sub %r14, %r13
    # format the data
    mov $format, %rdi
    mov %r13, %rsi
    # mov r13 to rsi to print
    # call printing function
    jmp printing_output


  multiplication:
    imul %r14, %r13
    # format the data
    mov $format, %rdi
    # mov r13 to rsi to print
    mov %r13, %rsi
    # call printing function
    jmp printing_output


  division:

    # check if the denominator is a zero
    cmp $0, %r14

    je zero_error

    mov %r13, %rax
    cqo

    idiv %r14

    # format the data
    mov $format, %rdi

    # mov rax to rdi to print
    mov %rax, %rsi

    # call printing function
    jmp printing_output




  # unrecognised op, not from +, - , * or %
  unknown_error:
    mov $unknown_op_error, %rdi
    jmp printing_output

  # for dealing with division by zero
  zero_error:
    mov $div_by_zero_error, %rdi
    jmp printing_output

  # used to print output 
  printing_output:
    mov $0, %al
    call printf

  # Function epilogue
  leave
  ret

# Start of the data section
.data

div_by_zero_error:
  .asciz "Division by 0 is not defined\n"

unknown_op_error:
  .asciz "Unknown Operation\n"

format: 
  .asciz "%ld\n"
  