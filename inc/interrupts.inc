__Interrupts

;=========================== SysTick ==========================;
SysTick_HANDLER PROC
  PUSH {R1-R2, R7, LR}

  FLAG "set", _EREG_, (1<<_MEIF_)

  LDR tmpa, =WDT
  LDR tmpd, =WDT_CLEAR_CLEAR
  STR tmpd, [tmpa, #WDT_CLEAR_offset]

_SysTick_HANDLER_wdt_wait_sync
  LDRB tmpd, [tmpa, #WDT_STATUS_offset]
  LSRS tmpd, #WDT_STATUS_SYNCBUSY_Pos + 1
  BCS _SysTick_HANDLER_wdt_wait_sync

  LDR tmpa, =SYST_CSR
  LDR tmpd, [tmpa]
  LDR tmp, =SYST_CSR_COUNTFLAG
  TST tmpd, tmp
  BAL _SysTick_HANDLER_exit

_SysTick_HANDLER_exit
  POP {R1-R2, R7, PC}
  ENDP
;==============================================================;


  END