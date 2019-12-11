@echo off

for %%F in (%1) do set filename=%%~nxF

SET fileCount=0

for /f "tokens=1,*" %%a in ('tasklist ^| find /I /C "%filename%"') do set fileCount=%%a

for /f "tokens=1,* delims= " %%a in ("%*") do set ALL_BUT_FIRST=%%b

IF %fileCount% gtr 5 (
	%1 %ALL_BUT_FIRST%
) ELSE (
	start "" %1 %ALL_BUT_FIRST%
)