@echo off
echo 测试GLM MCP安装脚本
echo.

cd /d "%~dp0"

echo [测试1] 检查Python环境...
python --version
if errorlevel 1 (
    echo [失败] Python未安装
) else (
    echo [成功] Python已安装
)

echo.
echo [测试2] 检查依赖包...
python -c "import zhipuai; print('zhipuai: OK')" 2>nul
if errorlevel 1 (
    echo [警告] zhipuai未安装
) else (
    echo [成功] zhipuai已安装
)

python -c "import mcp; print('mcp: OK')" 2>nul
if errorlevel 1 (
    echo [警告] mcp未安装
) else (
    echo [成功] mcp已安装
)

python -c "import dotenv; print('dotenv: OK')" 2>nul
if errorlevel 1 (
    echo [警告] dotenv未安装
) else (
    echo [成功] dotenv已安装
)

echo.
echo [测试3] 检查配置文件...
if exist .env (
    echo [信息] .env文件存在
    type .env | findstr "GLM_API_KEY"
) else (
    echo [信息] .env文件不存在
)

echo.
echo [测试4] 检查MCP配置...
if exist "%USERPROFILE%\.claude\mcp.json" (
    echo [信息] MCP配置文件存在
    findstr "glm-mcp" "%USERPROFILE%\.claude\mcp.json"
) else (
    echo [信息] MCP配置文件不存在
)

echo.
echo [测试5] 检查环境变量...
echo GLM_API_KEY: %GLM_API_KEY%
echo GLM_API_BASE: %GLM_API_BASE%
echo GLM_IMAGE_MODEL: %GLM_IMAGE_MODEL%

echo.
echo [测试6] 测试配置加载...
python -c "from config import config; print('配置加载测试:'); print('API Key:', '设置' if config.glm_api_key else '未设置'); print('API Base:', config.glm_api_base); print('Model:', config.glm_image_model)"

echo.
echo 测试完成！
pause