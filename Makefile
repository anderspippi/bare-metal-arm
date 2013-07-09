#
# Makefile for the bare-metal-arm code.
#
#

# Check if the ARM compiler is on the PATH, else set a prefix for finding it.
ifneq ($(shell which arm-none-eabi-gcc), "")
  ARMPREFIX =
else
  ARMPREFIX = gcc-arm/bin
endif

CC = $(ARMPREFIX)arm-none-eabi-gcc
AR = $(ARMPREFIX)arm-none-eabi-ar
OBJCOPY = $(ARMPREFIX)arm-none-eabi-objcopy
OBJDUMP = $(ARMPREFIX)arm-none-eabi-objdump

DEBUG_OPTS = -g3 -gdwarf-2 -gstrict-dwarf
OPTS = -Os
TARGET = -mcpu=cortex-m0
CFLAGS = -ffunction-sections -fdata-sections -Wall -Wa,-adhlns="$@.lst" \
		 -fmessage-length=0 $(TARGET) -mthumb -mfloat-abi=soft \
		 $(DEBUG_OPTS) $(OPTS) -I .

LIBOBJS = _startup.o syscalls.o uart.o delay.o accel.o touch.o usb.o \
		ring.o tests.o

INCLUDES = freedom.h common.h

all: demo.srec demo.dump

libbare.a: $(LIBOBJS)
	$(AR) -rv libbare.a $(LIBOBJS)
	
clean:
	-rm *.o *.lst *.out libbare.a *.srec *.dump

%.o: %.c
	$(CC) $(CFLAGS) -c $<
	
%.dump: %.out
	$(OBJDUMP) --disassemble $< >$@
	
%.srec: %.out
	$(OBJCOPY) -O srec $< $@
	
%.out: %.o mkl25z4.ld libbare.a
	$(CC) $(CFLAGS) -T mkl25z4.ld -o $@ $< libbare.a

# Download and unpack the GCC ARM embedded toolchain (binaries)
gcc-arm:
	curl --location https://launchpad.net/gcc-arm-embedded/4.7/4.7-2012-q4-major/+download/gcc-arm-none-eabi-4_7-2012q4-20121208-linux.tar.bz2 | tar jx
	ln -s gcc-arm-none-eabi-4_7-2012q4 gcc-arm
