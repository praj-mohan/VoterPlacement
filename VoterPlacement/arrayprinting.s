.cpu cortex-a72
.fpu neon-fp-armv8

.data
output2: .asciz " X " @ occupied symbol
output3: .asciz " _ " @ empty symbol

.text
.align 2
.global arrayprinting
.type arrayprinting, %function


arrayprinting:
push {fp, lr} @ save fp, lr on the stack
add fp, sp, #4 @ points fp to where lr is on the stack


   @ save the values in r0 and r1
   mov r9, r0  @ r9 is the array
   mov r5, r1  @ r5 = booths

   mov r10, #0  @ i = 0; in C

   printloop:
      cmp r10, r5  @ i < booths; in C
      bge exit @ leaves the loop if r10 is greater or equal to r5 

      
      mov r0, #4 @r0 = 4
      mul r0, r0, r10 @ r0 = 4 * i 
      add r0, r0, r9  @ r0 = 4i + sp
      ldr r1, [r0] @ r1 is given the value of the array location

@ checks if r1 is valued 0 or 1
      cmp r1, #0
      beq occupied @ gives the occupied symbol if 0
      cmp r1, #1 
      beq empty  @ gives empty symbol if 1




occupied: 
ldr r0, =output2 @ memory is loaded into r0
bl printf
add r10, r10, #1 @ i++; in C
b printloop @ goes back to loop


empty:
ldr r0, =output3 @ memory is loaded into r0
bl printf
add r10, r10, #1 @ i++; in C
b printloop @ goes back to loop
 

   exit:
   sub sp, fp, #4 @ restore the value of sp and fp
   pop {fp, pc}
