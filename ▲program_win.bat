for %%a in (".") do set CURRENT_DIR_NAME=%%~na
move /y C:\Users\Ponitkov\Desktop\FPGA\%CURRENT_DIR_NAME%.zip C:\Users\Ponitkov\Desktop\FPGA\project\XTH-40M1-02\DD4\%CURRENT_DIR_NAME%
"C:\Program Files\WinRAR\WinRAR.exe" x -y %CURRENT_DIR_NAME%
c:\altera\13.0sp1\quartus\bin\quartus_jli -c 2 -aPROGRAM output\%CURRENT_DIR_NAME%.jam 
pause
