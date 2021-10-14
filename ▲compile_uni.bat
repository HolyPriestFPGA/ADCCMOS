for %%a in (".") do set CURRENT_DIR_NAME=%%~na
echo. >>%CURRENT_DIR_NAME%.qsf 
echo set_global_assignment -name DEVICE EP2C8F256C8 >>%CURRENT_DIR_NAME%.qsf 
echo set_global_assignment -name CYCLONEII_M4K_COMPATIBILITY OFF >>%CURRENT_DIR_NAME%.qsf
c:\altera\13.0sp1\quartus\bin\quartus_map %CURRENT_DIR_NAME%
c:\altera\13.0sp1\quartus\bin\quartus_cdb %CURRENT_DIR_NAME% --vqm=%CURRENT_DIR_NAME%.vqm