ASM=nasm

SRC_DIR=boot
BUILD_DIR=build

all: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: $(BUILD_DIR)/main.bin
	cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/main_floppy.img
	truncate -s 1440k $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main.bin: $(SRC_DIR)/boot.asm
	$(ASM) $(SRC_DIR)/boot.asm -f bin -o $(BUILD_DIR)/main.bin

clean:
	rm -rf $(BUILD_DIR)/*.bin $(BUILD_DIR)/*.img
