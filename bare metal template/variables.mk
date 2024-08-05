# Основные параметры проекта
FILE 				= file
CPU					= cortex-m4
# Папки хранения файлов
SRC_DIR       		= src
INC_DIR       		= inc
EXE_DIR       		= exe
SPL_DIR				= spl

# Список объектных файлов
SOURCES 			= $(wildcard $(SRC_DIR)/*.c)
ASM_SOURCES 		= $(SPL_DIR)/startup_gd32f30x_hd.s
OBJECTS 			= $(SOURCES:.c=.o)
OBJECTS       		+= $(ASM_SOURCES:.s=.o)
# Компилятор GCC и опции его утилит
PREAMBLE 			= arm-none-eabi-
CC 					= $(PREAMBLE)gcc
	CC_OPTIONS  	= -mcpu=$(CPU)
	CC_OPTIONS  	+= -mthumb
	CC_OPTIONS  	+= -D GD32F30X_HD
	CC_OPTIONS  	+= -I $(INC_DIR)
	CC_OPTIONS  	+= -I $(SPL_DIR)
	CC_OPTIONS  	+= -Og
	CC_OPTIONS  	+= -fdata-sections
	CC_OPTIONS  	+= -ffunction-sections
	CC_OPTIONS  	+= -Wall
	CC_OPTIONS  	+= -c
	CC_OPTIONS  	+= -o
AS					= $(PREAMBLE)gcc
	AS_OPTIONS		= -x assembler-with-cpp
	LL_OPTIONS  	= -mcpu=$(CPU)
	LL_OPTIONS  	+= -mthumb
	LL_OPTIONS		+= -specs=nano.specs
	LL_OPTIONS		+= -specs=nosys.specs
	LL_OPTIONS		+= -u _printf_float
	LL_OPTIONS		+= -TLinkerScript.ld
	LL_OPTIONS		+= -Wl,--gc-sections
	LL_OPTIONS		+= -o
# Копировщик и его опции
COPIER				= $(PREAMBLE)objcopy
	CP_OPTIONS		= -O ihex
# Загрузчик и его опции
UPLOADER      		= openocd
	U_OPTIONS		= -f interface/stlink.cfg
	U_OPTIONS		+= -f target/gd32f30x.cfg 
	U_OPTIONS		+= -c "init"
	U_OPTIONS		+= -c "reset init"
	U_OPTIONS		+= -c "flash write_image erase $(EXE_DIR)/$(FILE).hex"
	U_OPTIONS		+= -c "reset" -c "exit"