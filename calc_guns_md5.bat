echo Calculating archives MD5 
del "packed_md5.log"
FOR %%G in ("packed\*.db") DO call :ProcessArcMd5 %%G
goto EndProcessArcMd5
:ProcessArcMd5
set NAM=%~n1
echo | set /p dummyName=%NAM%.db - >> "packed_md5.log"
md5.exe %1 >> "packed_md5.log"
goto :eof
:EndProcessArcMd5