@echo off
chcp 1251>Nul
del /s "bin\as3\*.*" /q >NuL
neko tools\fdgcl.n AniCacheHX.hxproj "-as3 bin\as3 -D fdb -cmd tools\after.cmd"