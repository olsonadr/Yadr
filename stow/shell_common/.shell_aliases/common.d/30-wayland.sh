# Wayland screenshot/OCR helpers
# Screenshot with slurp and grim
function screenshot() { grim -g "$(slurp)" "$@"; }
# Feed screenshot into tesseract
function ocr() { args="$*" && screenshot /tmp/screenshot.png && tesseract /tmp/screenshot.png "${args:=stdout}"; }

