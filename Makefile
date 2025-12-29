# Makefile for Resume Generation
# Requires: pandoc, weasyprint (optional: pdflatex for LaTeX output)

# Source files
SOURCE = resume.md
CSS = styles/resume.css
OUTPUT_DIR = output

# Output files
PDF = $(OUTPUT_DIR)/resume.pdf
HTML = $(OUTPUT_DIR)/resume.html
DOCX = $(OUTPUT_DIR)/resume.docx

# Default target
all: pdf html docx

# Create output directory
$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

# Generate PDF (via HTML with CSS using weasyprint)
pdf: html $(OUTPUT_DIR)
	weasyprint $(HTML) $(PDF)

# Alternative: PDF generation using LaTeX (ignores CSS, uses LaTeX typography)
pdf-latex: $(OUTPUT_DIR)
	pandoc $(SOURCE) \
		--from markdown \
		--to pdf \
		--pdf-engine=pdflatex \
		-V geometry:margin=1in \
		-V colorlinks=true \
		-V linkcolor=blue \
		-o $(PDF)

# Generate HTML
html: $(OUTPUT_DIR)
	pandoc $(SOURCE) \
		--from markdown \
		--to html5 \
		--css $(CSS) \
		--standalone \
		--embed-resources \
		--metadata pagetitle="Resume" \
		-o $(HTML)

# Generate DOCX
docx: $(OUTPUT_DIR)
	pandoc $(SOURCE) \
		--from markdown \
		--to docx \
		-o $(DOCX)

# Generate plain text
txt: $(OUTPUT_DIR)
	pandoc $(SOURCE) \
		--from markdown \
		--to plain \
		-o $(OUTPUT_DIR)/resume.txt

# Clean generated files
clean:
	rm -rf $(OUTPUT_DIR)

# Watch for changes and rebuild (requires inotifywait)
watch:
	@echo "Watching for changes... (Press Ctrl+C to stop)"
	@while true; do \
		inotifywait -e modify $(SOURCE) $(CSS) 2>/dev/null && make pdf html; \
	done

# Help target
help:
	@echo "Available targets:"
	@echo "  all        - Generate PDF, HTML, and DOCX (default)"
	@echo "  pdf        - Generate PDF with CSS styling (weasyprint)"
	@echo "  pdf-latex  - Generate PDF using LaTeX (ignores CSS)"
	@echo "  html       - Generate standalone HTML"
	@echo "  docx       - Generate Microsoft Word document"
	@echo "  txt        - Generate plain text version"
	@echo "  clean      - Remove all generated files"
	@echo "  watch      - Watch for changes and auto-rebuild PDF+HTML"
	@echo "  help       - Show this help message"

.PHONY: all pdf pdf-latex html docx txt clean watch help
