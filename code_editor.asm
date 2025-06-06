section .bss
    filename resb 100      ; Buffer for filename
    buffer resb 4096       ; Buffer for reading file content
    input_line resb 512    ; Buffer for user input

section .data
    msg_filename db "Enter file name: ", 0
    msg_existing db "Existing content:", 10, 0
    msg_text db "Edit content (press Enter to save line, Ctrl+D to finish):", 10, 0
    newline db 10, 0

section .text
    global _start

_start:
    ; Prompt for filename
    mov rax, 1              ; sys_write
    mov rdi, 1              ; STDOUT
    mov rsi, msg_filename
    mov rdx, 18
    syscall

    ; Read filename
    mov rax, 0              ; sys_read
    mov rdi, 0              ; STDIN
    mov rsi, filename
    mov rdx, 100
    syscall
    mov r10, rax            ; Save number of bytes read

    ; Remove newline
    dec r10
    mov byte [filename + r10], 0

    ; Try to open file in read-only mode first
    mov rax, 2              ; sys_open
    mov rdi, filename
    mov rsi, 0              ; O_RDONLY
    mov rdx, 0644           ; Permissions (not used for read-only)
    syscall
    mov r8, rax             ; Save FD for reading
    
    cmp r8, 0
    jl create_new_file      ; File doesn't exist? Create new file

    ; Print existing content message
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_existing
    mov rdx, 19
    syscall

read_loop:
    mov rax, 0              ; sys_read
    mov rdi, r8
    mov rsi, buffer
    mov rdx, 4096
    syscall
    test rax, rax
    jz done_read

    ; Display the read content
    push rax                ; Save bytes read
    mov rdi, 1              ; STDOUT
    mov rsi, buffer
    mov rdx, rax
    mov rax, 1              ; sys_write
    syscall
    pop rax                 ; Restore bytes read
    
    test rax, rax
    jnz read_loop           ; Continue reading if we got data

done_read:
    ; Close read descriptor
    mov rax, 3              ; sys_close
    mov rdi, r8
    syscall
    
    ; Open file for append
    mov rax, 2              ; sys_open
    mov rdi, filename
    mov rsi, 0x441          ; O_WRONLY | O_APPEND | O_CREAT
    mov rdx, 0644           ; Permissions
    syscall
    jmp start_editing

create_new_file:
    ; Open new file for writing
    mov rax, 2              ; sys_open
    mov rdi, filename
    mov rsi, 0x441          ; O_WRONLY | O_APPEND | O_CREAT
    mov rdx, 0644           ; Permissions
    syscall

start_editing:
    mov r9, rax             ; Save FD for writing

    ; Print instructions
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_text
    mov rdx, 50
    syscall

edit_loop:
    ; Read a line from user
    mov rax, 0              ; sys_read
    mov rdi, 0              ; STDIN
    mov rsi, input_line
    mov rdx, 512
    syscall
    test rax, rax
    jz close_write
    
    ; Write line to file
    mov rdx, rax
    mov rax, 1              ; sys_write
    mov rdi, r9             ; File descriptor
    mov rsi, input_line
    syscall

    jmp edit_loop

close_write:
    ; Close the file
    mov rax, 3              ; sys_close
    mov rdi, r9
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall