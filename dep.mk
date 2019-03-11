$(BUILD_DIR)/main.o:  $(BUILD_DIR)/constants.o $(BUILD_DIR)/benchmarks.o
$(BUILD_DIR)/benchmarks.o: $(BUILD_DIR)/timing.o $(BUILD_DIR)/constants.o
