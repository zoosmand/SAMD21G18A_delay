Stack_Size EQU 0x00000400

  AREA STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem SPACE Stack_Size
__initial_sp


Heap_Size EQU 0x00000200

  AREA HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem SPACE Heap_Size
__heap_limit



  PRESERVE8
  THUMB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  AREA RESET, DATA, READONLY
  ALIGN

  GET samd21g18a.inc
  GET vectors.inc
  GET macroses.inc


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  AREA |.text|, CODE, READONLY
  ALIGN

  GBLA	GCNT
GCNT SETA	0


tmpa     RN R1
tmpd     RN R2
tmp      RN R7


; Events Register Flags
_MEIF_    EQU 0 ; Main Event Interval Flag
_BF_      EQU 1 ; Blink Flag
_DF_      EQU 2 ; Delay Flag
_NSF_     EQU 3 ; No Sleep Flag


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ENTRY
  AREA |.text|, CODE, READONLY

  GET init.inc




;======================== MAIN Loop ===========================;
MAIN PROC

  FLAG_CHK "clear", _EREG_, _MEIF_, _MAIN_check_delay
  FLAG "clear", _EREG_, (1<<_MEIF_)
  BL TEST_PIN_BLINK

_MAIN_check_delay
  FLAG_CHK "clear", _EREG_, _DF_, _MAIN_check_sleep
  FLAG "set", _EREG_, (1<<_NSF_)

; execute routine while timer clocking delay time 
;--------------------------------------------------------------;
  FLAG_CHK "clear", _EREG_, _BF_, _MAIN_check_delay_next
  BL LED_BLINK
;--------------------------------------------------------------;

_MAIN_check_delay_next
  LDR tmpa, =TC5
  LDRB tmpd, [tmpa, #TC_STATUS_offset]
  LSRS tmpd, #TC_STATUS_STOP_Pos + 1
  BCC _MAIN_check_sleep

  FLAG "clear", _EREG_, (1<<_NSF_)

  LDR tmpa, =_DELAY_wait_exit
  MOV PC, tmpa

_MAIN_check_sleep
  FLAG_CHK "set", _EREG_, _NSF_, MAIN

_MAIN_sleep
  WFI
  B.N MAIN
_MAIN_exit
  B.N MAIN
  ENDP
;==============================================================;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  AREA |.text|, CODE, READONLY
  ALIGN
  GET utils.inc
  GET interrupts.inc

  GET var.inc

  END
