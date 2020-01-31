rmdir /s /q gamedata_unpacked\
FOR %%G in ("packed\*.db") DO converter -dir gamedata_unpacked -unpack -xdb %%G
