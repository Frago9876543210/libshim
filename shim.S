.text

.macro symbol_shim undefined_symbol actual_symbol
.globl \undefined_symbol
.type  \undefined_symbol, @function
\undefined_symbol:
	jmp \actual_symbol@PLT
.endm

#include SYMBOLS_SHIM_PATH
