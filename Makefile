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
	canvas_r=5 canvas_c=5 $(BUILDER)
	canvas_r=10 canvas_c=10 $(BUILDER)
	canvas_r=15 canvas_c=15 $(BUILDER)
	canvas_r=20 canvas_c=20 $(BUILDER)
	canvas_r=50 canvas_c=50 $(BUILDER)

.PHONY: build_index
build_index:
	in_f=$(INPUT_FOLDER) out_f=$(OUTPUT_FOLDER) out_p=$(OUTPUT_PREFIX) $(BUILDER_INDEX)

.PHONY: clean
clean:
	rm -rf $(OUTPUT_FOLDER)/$(OUTPUT_PREFIX)*
