@echo off

rem FOR /F %%I IN ('curl -s -u my-admin:admin http://localhost:8080/job/my-task-3/3/execution/node/2/ws/mci/scripts/.done') DO (
rem   if "%%I" equ "done" (
rem     echo DONE found...
rem   ) else (
rem     echo DONE not found...
	rem echo %%I
rem   )
rem )
rem pause

rem curl -s -u my-admin:admin http://localhost:8080/job/my-task-3/3/execution/node/3/ws/mci/scripts/.done | findstr -m "done"
rem echo curl-1 el=%errorlevel%

cmd /c type D:\dev\github\mci\scripts\bdn.groovy ^| D:\app\dev\jdk-18.0.2\bin\java -jar D:\dev\apps\jenkins\lib\2.459\cli-2.459.jar -auth my-admin:admin -s http://localhost:8080 groovysh

echo query /job/my-task-4/lastBuild/execution/node/3/ws/mci/scripts/.done
set COUNTER=0
set "BS="
set /p "=DONE not found...%COUNTER%" <nul
:loop
timeout /t 1 >nul
curl -s -u my-admin:admin http://localhost:8080/job/my-task-4/lastBuild/execution/node/3/ws/mci/scripts/.done | findstr -m "done" > nul
if %errorlevel% equ 0 (
  echo.
  echo DONE found, my-task-4 is done...
)
if %errorlevel% equ 1 (
  set /p "=%BS%%COUNTER%" <nul
  set /A COUNTER+=1
  goto :loop
)

pause

