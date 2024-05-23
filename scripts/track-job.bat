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

:loop
timeout /t 1 >nul
curl -s -u my-admin:admin http://localhost:8080/job/my-task-4/1/execution/node/3/ws/mci/scripts/.done | findstr -m "done" > nul
if %errorlevel% equ 0 echo DONE found...
if %errorlevel% equ 1 (
  echo DONE not found...
  goto :loop
)

pause

