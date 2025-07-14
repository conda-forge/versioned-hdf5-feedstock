@echo on
setlocal enabledelayedexpansion

%PYTHON% -m build --wheel --no-isolation --skip-dependency-check
if %ERRORLEVEL% neq 0 exit 1

for /f %%f in ('dir /b /S .\dist') do (
    %PYTHON% -m pip install %%f
    if %ERRORLEVEL% neq 0 exit 1
)
