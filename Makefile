BUILDER := "./builder.sh"
INPUT_FOLDER := "./resources"
BUILDER_INDEX := "./build_index.sh"
OUTPUT_FOLDER := "./public"
OUTPUT_PREFIX := "draw_"

.PHONY: all
all: build_all build_index
	@echo "All build done !"

.PHONY: build
build:
	$(BUILDER)

.PHONY: build_all
build_all:
	canvas_r=8 canvas_c=8 $(BUILDER)
	canvas_r=16 canvas_c=16 $(BUILDER)
	canvas_r=24 canvas_c=24 $(BUILDER)
	canvas_r=32 canvas_c=32 $(BUILDER)

.PHONY: build_index
build_index:
	in_f=$(INPUT_FOLDER) out_f=$(OUTPUT_FOLDER) out_p=$(OUTPUT_PREFIX) $(BUILDER_INDEX)

.PHONY: clean
clean:
	rm -rf $(OUTPUT_FOLDER)/$(OUTPUT_PREFIX)*
