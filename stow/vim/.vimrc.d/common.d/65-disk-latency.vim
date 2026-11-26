"=============================="
" Disk latency (slow shared disk) "
"=============================="
" Do not wait for a physical disk flush on every write / swap-file update.
" 30 :w of a 200 KB file: 6-8 s -> 0.4 s on the SWIS hosts (see docs/DISK_LATENCY.md).
if exists('&fsync') | set nofsync | endif
