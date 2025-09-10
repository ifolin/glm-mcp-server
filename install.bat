@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title GLM MCP Server 一键安装
color 0A

echo.
echo ========================================
echo      GLM MCP Server 一键安装工具
echo ========================================
echo.

cd /d "%~dp0"

echo [1/6] 检查Python环境...
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Python，请先安装Python
    echo 下载地址：https://www.python.org/downloads/
    echo 请确保安装时勾选"Add Python to PATH"
    pause
    exit /b 1
)
echo [✓] Python环境正常

echo.
echo [2/6] 检查Claude Code配置...
set CLAUDE_CONFIG_DIR=%USERPROFILE%\.claude
if not exist "%CLAUDE_CONFIG_DIR%" (
    echo [错误] 未检测到Claude Code配置目录
    echo 请确保已安装Claude Code
    pause
    exit /b 1
)
echo [✓] Claude Code配置目录存在

echo.
echo [3/6] 安装Python依赖包...
echo 正在安装：zhipuai mcp python-dotenv
pip install zhipuai mcp python-dotenv
if errorlevel 1 (
    echo [警告] 部分依赖包安装失败，请检查网络连接
    echo 可以手动运行：pip install zhipuai mcp python-dotenv
    pause
)

echo.
echo [4/6] 配置GLM API密钥...
echo.
echo 请从智谱AI控制台获取您的API密钥：https://open.bigmodel.cn/console
echo.

:: 检查是否已配置API密钥
set API_KEY_CONFIGURED=0
for /f "tokens=2 delims==" %%a in ('set GLM_API_KEY 2^>nul') do (
    if not "%%a"=="" (
        set API_KEY_CONFIGURED=1
        echo [信息] 检测到已配置的GLM_API_KEY：%%a
    )
)

if !API_KEY_CONFIGURED!==0 (
    set /p GLM_API_KEY=请输入您的GLM API密钥： 
    
    if "!GLM_API_KEY!"=="" (
        echo [错误] API密钥不能为空
        pause
        exit /b 1
    )
    
    :: 设置系统环境变量
    setx GLM_API_KEY "!GLM_API_KEY!" /M
    echo [✓] API密钥已保存到系统环境变量
    
    :: 设置其他环境变量
    setx GLM_API_BASE "https://open.bigmodel.cn/api/paas/v4/" /M
    setx GLM_IMAGE_MODEL "glm-4.5v" /M
    echo [✓] 其他配置已保存
) else (
    echo [✓] API密钥已配置，跳过设置步骤
)

echo.
echo [5/6] 配置Claude MCP服务器...
set MCP_CONFIG_FILE=%CLAUDE_CONFIG_DIR%\mcp.json

:: 创建MCP配置文件
echo { > "%MCP_CONFIG_FILE%"
echo   "mcpServers": { >> "%MCP_CONFIG_FILE%"
echo     "glm-mcp": { >> "%MCP_CONFIG_FILE%"
echo       "command": "python", >> "%MCP_CONFIG_FILE%"
echo       "args": ["%~dp0main.py"], >> "%MCP_CONFIG_FILE%"
echo       "env": { >> "%MCP_CONFIG_FILE%"
echo         "GLM_API_BASE": "https://open.bigmodel.cn/api/paas/v4/", >> "%MCP_CONFIG_FILE%"
echo         "GLM_IMAGE_MODEL": "glm-4.5v" >> "%MCP_CONFIG_FILE%"
echo       } >> "%MCP_CONFIG_FILE%"
echo     } >> "%MCP_CONFIG_FILE%"
echo   } >> "%MCP_CONFIG_FILE%"
echo } >> "%MCP_CONFIG_FILE%"

echo [✓] MCP配置文件已创建：%MCP_CONFIG_FILE%

echo.
echo [6/6] 更新Claude Code权限配置...
set SETTINGS_FILE=%CLAUDE_CONFIG_DIR%\settings.json

:: 检查settings.json是否存在，不存在则创建
if not exist "%SETTINGS_FILE%" (
    echo { > "%SETTINGS_FILE%"
    echo   "$schema": "https://json.schemastore.org/claude-code-settings.json", >> "%SETTINGS_FILE%"
    echo   "env": {}, >> "%SETTINGS_FILE%"
    echo   "includeCoAuthoredBy": false, >> "%SETTINGS_FILE%"
    echo   "permissions": { >> "%SETTINGS_FILE%"
    echo     "allow": [], >> "%SETTINGS_FILE%"
    echo     "deny": [] >> "%SETTINGS_FILE%"
    echo   }, >> "%SETTINGS_FILE%"
    echo   "hooks": {} >> "%SETTINGS_FILE%"
    echo } >> "%SETTINGS_FILE%"
)

:: 备份原文件
copy "%SETTINGS_FILE%" "%SETTINGS_FILE%.backup" >nul 2>&1

:: 创建临时文件来处理JSON
set TEMP_FILE=%TEMP%\claude_settings.tmp.json

:: 使用Python来正确处理JSON
python -c "
import json
import os

settings_file = r'%SETTINGS_FILE%'
temp_file = r'%TEMP_FILE%'

# 读取现有配置
try:
    with open(settings_file, 'r', encoding='utf-8') as f:
        settings = json.load(f)
except:
    settings = {}

# 确保permissions结构存在
if 'permissions' not in settings:
    settings['permissions'] = {'allow': [], 'deny': []}

# 添加glm-mcp权限
if 'mcp__glm-mcp__read_image' not in settings['permissions']['allow']:
    settings['permissions']['allow'].append('mcp__glm-mcp__read_image')

# 写入文件
with open(temp_file, 'w', encoding='utf-8') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)

print('Settings updated successfully')
"

if exist "%TEMP_FILE%" (
    move /y "%TEMP_FILE%" "%SETTINGS_FILE%" >nul
    echo [✓] Claude Code权限配置已更新
) else (
    echo [警告] 权限配置更新失败，请手动添加 'mcp__glm-mcp__read_image' 到权限列表
)

echo.
echo ========================================
echo             安装完成！
echo ========================================
echo.
echo 重要提示：
echo 1. 请重新启动Claude Code以使配置生效
echo 2. 重启后，您可以在任何项目中使用 @图像 来分析图片
echo 3. 如需更新API密钥，请修改系统环境变量 GLM_API_KEY
echo 4. 日志文件位置：%~dp0mcpserver.log
echo.
echo 按任意键退出...
pause >nul