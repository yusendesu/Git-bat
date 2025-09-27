@echo off
title 有诚的GIT管理工具

:init
set "project_dir=%cd%"
set /p "input_dir=请输入你的git项目地址(回车表示使用当前目录): "
if not "%input_dir%"=="" set "project_dir=%input_dir%"

cd /d "%project_dir%" 2>nul || (
    echo 错误：目录不存在或无法访问
    pause
    goto init
)

if not exist ".git" (
    echo ---------------------------------------
    echo 错误：当前目录不是git项目文件夹
    echo ---------------------------------------
    choice /c yn /n /m "要克隆一个仓库吗？"
    if %errorlevel% == 1 (call :git_clone)
    pause
    goto init
)

:start
cls
echo -----------------------------------
echo       有诚的git版本管理工具
echo -----------------------------------
echo 当前目录: %project_dir%
echo.
echo 1 配置git信息
echo 2 配置gitignore
echo 3 创建本地新分支
echo 4 提交修改
echo 5 查看状态
echo 6 拉取更新
echo 7 退出
echo.

choice /c 1234567 /n /m "请选择操作: "

goto option_%errorlevel%

:option_1
call :git_config
goto start

:option_2
start notepad .gitignore
goto start

:option_3
call :git_branch
goto start

:option_4
call :git_commit
goto start

:option_5
git status
pause
goto start

:option_6
git pull
pause
goto start

:option_7
exit /b 0

:git_config
set /p "username=请输入用户名: "
git config --global user.name "%username%"
set /p "email=请输入邮箱: "
git config --global user.email "%email%"
if %errorlevel% equ 0 (
    echo 配置成功!
) else (
    echo 配置失败!
)
pause
goto :eof

:git_clone
set /p "repo_url=请输入项目地址: "
git clone "%repo_url%"
if not %errorlevel% == 0 echo 克隆失败，请检查网络和地址!
pause
goto :eof

:git_branch
git branch
set /p "branch_name=请输入新分支名: "
git checkout -b "%branch_name%"
pause
goto :eof

:git_commit
git add .
git status
echo 这是目前的状态，你确定要提交吗？
choice /c yn /n /m "确定输入y，不确定输入n"
if %errorlevel% equ 2 goto :eof
set /p "commit_msg=请输入提交说明(你的修改内容): "
git commit -m "%commit_msg%"
if %errorlevel% == 0 (
    echo 提交成功!
    echo 已提交到本地仓库，还要继续提交到github吗
    choice /c yn /n /m "确定输入y，不确定输入n"
    echo %errorlevel%
    if %errorlevel% == 1 (git push origin HEAD)
)
pause
goto :eof