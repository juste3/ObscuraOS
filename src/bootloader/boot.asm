org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

; -------------------------------
; FAT12 BIOS Parameter Block
; -------------------------------
jmp short start
nop

bdb_oem:                     db 'MSWIN4.1'        ; OEM identifier
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0x00E0
bdb_total_sectors:          dw 2880
bdb_media_descriptor:       db 0xF0
bdb_sectors_per_fat:        dw 9
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; -------------------------------
; Extended Boot Record
; -------------------------------
ebr_drive_number:           db 0
                            db 0                 ; reserved
ebr_signature:              db 0x29
ebr_volume_id:              db 0x12, 0x34, 0x56, 0x78
ebr_volume_label:           db 'OBSCURA  OS'     ; 11 bytes
ebr_system_id:              db 'FAT12   '        ; 8 bytes

; -------------------------------
; Start of code
; -------------------------------
start:
    jmp main

; -------------------------------
; Put string to screen
; Params: DS:SI -> string
; -------------------------------
puts:
    push ax
    push si
.next:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .next
.done:
    pop si
    pop ax
    ret

; -------------------------------
; LBA to CHS conversion
; Input: AX=LBA
; Output: CX=sector+track, DH=head
; -------------------------------
lba_to_chs:
    push ax
    push dx

    xor dx, dx
    div word [bdb_sectors_per_track]
    inc dx                          ; sector = (LBA % spt) + 1
    mov cx, dx                     ; cx = sector

    xor dx, dx
    div word [bdb_heads]
    mov dh, dl                     ; head
    mov ch, al                     ; track (low 8 bits)
    shl ah, 6
    or cl, ah                      ; track (high 2 bits)

    pop dx
    pop ax
    ret

; -------------------------------
; Read sector from floppy
; AX = LBA, DL = drive number, BX = buffer
; -------------------------------
disk_read:
    push ax
    push bx
    push cx
    push dx
    push di

    mov cx, 1                      ; read 1 sector
    push cx
    call lba_to_chs
    pop ax                         ; AL = sector count

    mov ah, 0x02                   ; INT 13h read sectors
    mov al, cl                     ; AL = sectors to read
    mov ch, ch                     ; cylinder low bits
    mov cl, cl                     ; sector + cylinder high bits
    mov dh, dh                     ; head
    mov dl, [ebr_drive_number]
    mov es, bx                     ; ES:BX = buffer (set externally)
    xor bx, bx                     ; BX=0 to use ES:0000
    int 0x13
    jc floppy_error                ; jump if carry flag (error)

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

disk_reset:
    pusha
    mov ah, 0x00
    int 0x13
    popa
    ret

; -------------------------------
; Main
; -------------------------------
main:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov [ebr_drive_number], dl

    mov ax, 1          ; LBA = 1 (2nd sector)
    mov bx, 0x7E0      ; Load to ES:BX = 0000:07E0
    call disk_read

    mov si, msg_hello
    call puts

    jmp $

floppy_error:
    mov si, msg_error
    call puts
    jmp $

; -------------------------------
; Messages
; -------------------------------
msg_hello: db "Hello from ObscuraOS!", ENDL, 0
msg_error: db "Disk read failed!", ENDL, 0

; -------------------------------
; Boot Signature (magic number)
; -------------------------------
times 510 - ($ - $$) db 0
dw 0xAA55
