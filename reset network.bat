netsh interface ip reset
ipconfig /flushdns
ipconfig /registerdns
ipconfig /release
ipconfig /release *
ipconfig /renew
gpupdate /force

shutdown -r -f -t 0
