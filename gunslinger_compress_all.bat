@echo off

SET GUNS_PATH=G:\stalker\stcop\gunslinger_build

rmdir /s /q packed\
mkdir packed\
del gamedata.pack_#0

rem 1 - configs
rmdir /s /q gamedata\
mkdir gamedata
robocopy  %GUNS_PATH%\gamedata\configs gamedata\configs /MIR 
robocopy  %GUNS_PATH%\gamedata\scripts gamedata\scripts /MIR
robocopy  %GUNS_PATH%\gamedata\shaders gamedata\shaders /MIR
@echo function GetBuildStamp() > gamedata\scripts\gunsl_build_stamp.script 
@echo return "%DATE%" >> gamedata\scripts\gunsl_build_stamp.script 
@echo end >> gamedata\scripts\gunsl_build_stamp.script 
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_plaintext.db

rem 2 - camera anims
rmdir /s /q gamedata\
mkdir gamedata
robocopy  %GUNS_PATH%\gamedata\anims gamedata\anims /MIR
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_camanims.db

rem 3 - meshes without weapons
rmdir /s /q gamedata\
mkdir gamedata
robocopy  %GUNS_PATH%\gamedata\meshes gamedata\meshes /MIR
rmdir /s /q gamedata\meshes\dynamics\weapons
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_meshes.db

rem 4 - weapons A-F
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (a,b,c,d,e,f) do for /d %%a in (%GUNS_PATH%\gamedata\meshes\dynamics\weapons\wpn_%%i*) do robocopy "%%a" "gamedata\meshes\dynamics\weapons\%%~na" /MIR
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_meshes_af.db

rem 5 - weapons G-L (without hands)
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (g,h,i,j,k,l) do for /d %%a in (%GUNS_PATH%\gamedata\meshes\dynamics\weapons\wpn_%%i*) do robocopy "%%a" "gamedata\meshes\dynamics\weapons\%%~na" /MIR
rmdir /s /q gamedata\meshes\dynamics\weapons\wpn_hand
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_meshes_gl.db

rem 6 - weapons M-R
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (m,n,o,p,q,r) do for /d %%a in (%GUNS_PATH%\gamedata\meshes\dynamics\weapons\wpn_%%i*) do robocopy "%%a" "gamedata\meshes\dynamics\weapons\%%~na" /MIR
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_meshes_mr.db

rem 7 - weapons S-S
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (s) do for /d %%a in (%GUNS_PATH%\gamedata\meshes\dynamics\weapons\wpn_%%i*) do robocopy "%%a" "gamedata\meshes\dynamics\weapons\%%~na" /MIR
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_meshes_ss.db

rem 8 - weapons T-Z
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (t,u,v,w,x,y,z) do for /d %%a in (%GUNS_PATH%\gamedata\meshes\dynamics\weapons\wpn_%%i*) do robocopy "%%a" "gamedata\meshes\dynamics\weapons\%%~na" /MIR
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_meshes_tz.db

rem 8 - weapons meshes (other)
rmdir /s /q gamedata\
mkdir gamedata
for /d %%a in (%GUNS_PATH%\gamedata\meshes\dynamics\weapons\*) do call :ProcessNonWpn %%~na
goto EndProcessNonWpn
:ProcessNonWpn
set NAM=%1
set NAM_TRUNK=%NAM:~0,4%
if NOT "%NAM_TRUNK%" == "wpn_" (
robocopy "%GUNS_PATH%\gamedata\meshes\dynamics\weapons\%NAM%" "gamedata\meshes\dynamics\weapons\%NAM%" /MIR
)
goto :eof
:EndProcessNonWpn
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_meshes_wpn.db

rem 9 - XR-resources in the root of gamedata
rmdir /s /q gamedata\
mkdir gamedata
robocopy  %GUNS_PATH%\gamedata\ gamedata\
rmdir /s /q gamedata\meshes\dynamics\weapons
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_resources.db

rem 10 - sounds
rmdir /s /q gamedata\
mkdir gamedata
robocopy  %GUNS_PATH%\gamedata\sounds gamedata\sounds /MIR
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_sounds.db

rem 11 - hands pack (textures\act and meshes\dynamics\weapons\wpn_hand)
rmdir /s /q gamedata\
mkdir gamedata
robocopy  %GUNS_PATH%\gamedata\textures\act gamedata\textures\act /MIR
robocopy  %GUNS_PATH%\gamedata\meshes\dynamics\weapons\wpn_hand gamedata\meshes\dynamics\weapons\wpn_hand /MIR
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_hands.db

rem 12 - common textures (without act and wpn)
rmdir /s /q gamedata\
mkdir gamedata
for /d %%a in (%GUNS_PATH%\gamedata\textures\*) do call :ProcessCommonTex %%~na
goto EndProcessCommonTex
:ProcessCommonTex
set NAM=%1
set res=true
if "%NAM%" == "act" set res=false
if "%NAM%" == "wpn" set res=false
if %res%==true (
robocopy "%GUNS_PATH%\gamedata\textures\%NAM%" "gamedata\textures\%NAM%" /MIR
)
goto :eof
:EndProcessCommonTex
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_common.db

rem 13 - weapons textures A-D
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (a,b,c,d) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\%%i*" "gamedata\textures\wpn\"
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_ad.db

rem 14 - weapons textures E-G
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (e,f,g) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\%%i*" "gamedata\textures\wpn\"
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_fg.db

rem 15 - weapons textures H-P
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (h,i,j,k,l,m,n,o,p) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\%%i*" "gamedata\textures\wpn\"
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_hp.db

rem 16 - weapons textures Q-S
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (q,r,s) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\%%i*" "gamedata\textures\wpn\"
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_rs.db

rem 17 - weapons textures T-Z, excluding wpn_
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (t,u,v,x,y,z) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\%%i*" "gamedata\textures\wpn\"
for %%a in (%GUNS_PATH%\gamedata\textures\wpn\w*) do call :ProcessWpnTex %%a
goto EndProcessWpnTex
:ProcessWpnTex
set NAM=%~n1
set NAM_TRUNK=%NAM:~0,4%
set res=true
if "%NAM_TRUNK%" == "wpn_" set res=false
if %res%==true (
echo %1
xcopy %1 "gamedata\textures\wpn\"
)
goto :eof
:EndProcessWpnTex
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_tw.db

rem 18 - weapons textures wpn_A-wpn_G
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (a,b,c,d,e,f,g) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\wpn_%%i*" "gamedata\textures\wpn\"
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_wpn_ag.db

rem 19 - weapons textures wpn_H-wpn_K
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (h,i,j,k) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\wpn_%%i*" "gamedata\textures\wpn\"
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_wpn_hk.db

rem 20 - weapons textures wpn_L-wpn_M
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (l,m) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\wpn_%%i*" "gamedata\textures\wpn\"
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_wpn_lm.db

rem 21 - weapons textures wpn_N-wpn_R
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (n,o,p,q,r) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\wpn_%%i*" "gamedata\textures\wpn\"
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_wpn_pr.db

rem 22 - weapons textures wpn_S-wpn_S
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (s) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\wpn_%%i*" "gamedata\textures\wpn\"
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_wpn_ss.db

rem 23 - weapons textures wpn_T-wpn_Z
rmdir /s /q gamedata\
mkdir gamedata
for %%i in (t,u,v,w,x,y,z) do xcopy "%GUNS_PATH%\gamedata\textures\wpn\wpn_%%i*" "gamedata\textures\wpn\"
xrCompress.exe gamedata -ltx build.ltx -store
move gamedata.pack_#0 packed\guns_data_textures_wpn_wpn_tz.db

rmdir /s /q gamedata\
del log.txt
del engine.log

calc_guns_md5.bat

echo FINISHED!

rem pause
rem (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z)