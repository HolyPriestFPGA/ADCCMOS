for %%a in (".") do set CURRENT_DIR_NAME=%%~na
c:\altera\13.0sp1\quartus\bin\quartus_jli -c 2 output\%CURRENT_DIR_NAME%_rom.jam -a ERASE
c:\altera\13.0sp1\quartus\bin\quartus_jli -c 2 output\%CURRENT_DIR_NAME%_rom.jam -a BLANK_CHECK
c:\altera\13.0sp1\quartus\bin\quartus_jli -c 2 output\%CURRENT_DIR_NAME%_rom.jam -a PROGRAM  
c:\altera\13.0sp1\quartus\bin\quartus_jli -c 2 output\%CURRENT_DIR_NAME%_rom.jam -a VERIFY
pause
