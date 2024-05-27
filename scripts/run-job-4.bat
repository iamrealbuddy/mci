@echo off

rem run pipeline job defn.

wsl docker info
echo.

set /p stk=start docker stack....
if "%stk%" neq "" (
 start run-new.bat
 pause
)

rem set job=my-job-py-alpine
set job=my-task-4
set scm=D:\dev\github\mci
set jenkh=D:\dev\apps\jenkins
set javah=D:\app\dev\jdk-18.0.2
set cli-jar-old=%jenkh%\data\war\WEB-INF\lib\cli-2.455.jar
set cli-jar=%jenkh%\lib\2.459\cli-2.459.jar

echo.
echo job list...
%javah%\bin\java -jar %cli-jar% -auth my-admin:admin -s http://localhost:8080 list-jobs
pause

set /p dlj=delete job %job%...
if "%dlj%" neq "" (
  echo deleting...
  %javah%\bin\java -jar %cli-jar% -auth my-admin:admin -s http://localhost:8080 delete-job %job%
  echo.
  echo job list...
  %javah%\bin\java -jar %cli-jar% -auth my-admin:admin -s http://localhost:8080 list-jobs
  pause
)

echo.
echo search job %job%
SETLOCAL ENABLEDELAYEDEXPANSION
set jbf=
FOR /F "tokens=* USEBACKQ" %%F IN (`%javah%\bin\java -jar %cli-jar% -auth my-admin:admin -s http://localhost:8080 list-jobs`) DO (
  if "%%F" equ "%job%" (
    set jbf=%%F
    echo job %job% found...
  )
)

rem echo.
rem echo jbf is....%jbf%
rem pause

if "%jbf%" equ "" (
  echo job %job% not found....create
  %javah%\bin\java -jar %cli-jar% -auth my-admin:admin -s http://localhost:8080 create-job %job% < %scm%\jobs\%job%.xml
  echo.
  echo job list...
  %javah%\bin\java -jar %cli-jar% -auth my-admin:admin -s http://localhost:8080 list-jobs
  pause
)
ENDLOCAL

echo.
echo start job %job%...
pause
%javah%\bin\java -jar %cli-jar% -auth my-admin:admin -s http://localhost:8080 build -s -v %job%
pause

%scm%\scripts\track-job.bat
pause
