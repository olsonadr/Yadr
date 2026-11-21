# Lab hardware helpers (serial, usb hub, devmem, touchpad)
alias fix_touchpad='sudo modprobe -r i2c_hid;sudo modprobe i2c_hid;sudo modprobe -r psmouse;sudo modprobe psmouse'

# Most common screen config
function my_screen() { screen -L $1 115200 8N1; }

# Acroname usb hub control
alias usb_hub="/usr/local/usb_hub_software/bin/AcronameHubCLI"
function usb_hub_toggle() { usb_hub -p $1 -e 0 && usb_hub -p $1 -e 1; }

# Devmem2 parsers
function devmem_check_cc() { scc "$1" devmem2 $2 w | awk '/Read at address/ {print $6}' | sed 's/^0x//' | xargs -I{} echo "obase=2; ibase=16; {}" | bc | xargs -i{} bash -c 'printf "%032s\n" "{}"' | sed 's/ /0/g'; }
function devmem_check() { s "$1" devmem2 $2 w | awk '/Read at address/ {print $6}' | sed 's/^0x//' | xargs -I{} echo "obase=2; ibase=16; {}" | bc | xargs -i{} bash -c 'printf "%032s\n" "{}"' | sed 's/ /0/g'; }
function devmem2_bin_print() { echo 'function devmem2_bin() { if [[ "$1" = "-h" ]]; then printf "Usage: devmem2_bin <hex_address> [b|h|w|l] [num_nibbles_to_print]\\n\\nIf \$1 not given, '"'"'w'"'"' assumed (get 1 word or 4 bytes).\\nIf \$2 not given, '"'"'8'"'"' assumed (print 8 nibbles/4 bytes of binary).\\n\\n"; else devmem2 $1 ${2:-w} | tee wow-tmp | awk '"'"'/Read at address/ { print $6 }'"'"' | xargs printf "%0${3:-8}x" | xxd -r -p | xxd -b -c 8 | awk '"'"'{ gsub ("^0*", "", $1) ; gsub (":$", "", $1) ; gsub ("^$", "0", $1) ; printf "BIN "$1":\t" ; for (i=2; i<NF; i++) printf $i" "; print " "}'"'"' >> wow-tmp ; cat wow-tmp ; rm wow-tmp ; fi; }'; }
function devmem2_bin() { if [[ "$1" = "-h" ]]; then printf "Usage: devmem2_bin <hex_address> [b|h|w|l] [num_nibbles_to_print]\n\nIf \$1 not given, 'w' assumed (get 1 word or 4 bytes).\nIf \$2 not given, '8' assumed (print 8 nibbles/4 bytes of binary).\n\n"; else
    devmem2 $1 ${2:-w} | tee wow-tmp | awk '/Read at address/ { print $6 }' | xargs printf "%0${3:-8}x" | xxd -r -p | xxd -b -c 8 | awk '{ gsub ("^0*", "", $1) ; gsub (":$", "", $1) ; gsub ("^$", "0", $1) ; printf "BIN "$1":\t" ; for (i=2; i<NF; i++) printf $i" "; print " "}' >>wow-tmp
    cat wow-tmp
    rm wow-tmp
fi; }

