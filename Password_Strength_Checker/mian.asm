.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
Include Irvine32.inc

.data
    
    ; INPUT MESSAGES

	inputStr BYTE 100 DUP(0)
	promptStr BYTE "[]=> Enter your password: ", 0
	errorStr BYTE "Sorry: Password is weak. Please try again :((", 0
	successStr BYTE "Success: Your Password is strong. Good job :)", 0

    ; SUGGESTIONS

    suggUpper BYTE "[+] Password Must Contain atleast 1 Upper Case Character",  0ah, 0
    suggLower BYTE "[+] Password Must Contain atleast 1 Lower Case Character" , 0ah, 0
    suggDigit BYTE "[+] Password Must Contain atleast 1 Digit" , 0ah, 0
    suggSymbol BYTE "[+] Password Must Contain atleast 1 Symbol" , 0ah, 0
    suggLength BYTE "[+] Password Length must be >= 8", 0ah, 0


.code
main PROC

; Main Code
	; DISPLAYING MSG BOX
		;mov ebx,OFFSET caption
		;mov edx,OFFSET HelloMsg
		;call MsgBox

	mov edx, OFFSET promptStr
    call WriteString

    mov edx, OFFSET inputStr
    mov ecx, LENGTHOF inputStr
    call ReadString

	; NOW CHECKING THE STRING

	mov esi, OFFSET inputStr
    mov ebx, LENGTHOF inputStr

    ; Check password length
    cmp eax, 8
    jl sugg_length

    ; Check password complexity
    xor ecx, ecx ;initialize counter for uppercase letters
    xor edx, edx ;initialize counter for lowercase letters
    xor ebx, ebx ;initialize counter for digits
    xor edi, edi ;initialize counter for special characters
    lea esi, inputStr

    check_loop:
        mov al, [esi]
        cmp al, 0
        je check_done

        cmp al, 'A'
        jb check_lower
        cmp al, 'Z'
        ja check_lower
        inc ecx ;increment uppercase counter
        jmp check_next

    check_lower:
        cmp al, 'a'
        jb check_digit
        cmp al, 'z'
        ja check_digit
        inc edx ;increment lowercase counter
        jmp check_next

    check_digit:
        cmp al, '0'
        jb check_special
        cmp al, '9'
        ja check_special
        inc ebx ;increment digit counter
        jmp check_next

    check_special:
        
        inc edi ;skip non-special character
        jmp check_next

    check_next:
        inc esi ;advance to next character
        jmp check_loop

    check_done:
        cmp ecx, 0
        je miss_upper
        cmp edx, 0
        je miss_lower
        cmp ebx, 0
        je miss_digit
        cmp edi, 0
        je miss_symbol

        jmp check_done1 ;password must contain at least one uppercase, one lowercase, and one digit

    check_done1:
        mov edx, OFFSET successStr
        call WriteString
        jmp done

    miss_upper:
        mov edx, OFFSET suggUpper
        call WriteString
        jmp weak_password

    miss_lower:
        mov edx, OFFSET suggLower
        call WriteString
        jmp weak_password

    miss_digit:
        mov edx, OFFSET suggDigit
        call WriteString
        jmp weak_password

    miss_symbol:
        mov edx, OFFSET suggSymbol
        call WriteString
        jmp weak_password

    sugg_length:
        mov edx, OFFSET suggLength
        call WriteString
        jmp weak_password

    weak_password:
        mov edx, OFFSET errorStr
        call WriteString

    done:
        INVOKE ExitProcess, 0

main ENDP
END main
