rmdir /s /q compressed\
mkdir compressed
for %%i in (packed\*.db) do (
makecab %%i "compressed\%%~ni.db"
)