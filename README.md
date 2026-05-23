# Claude Code Desktop Notifier

当 Claude Code 需要用户点权限或任务节点完成时，Windows 右下角弹出侧边滑入通知窗口。点击通知自动将 VS Code 窗口带到前台。

## 效果

- 右下角滑入式通知弹窗（WPF）
- 点击通知 → 自动聚焦 VS Code
- 10 秒后自动淡出消失
- 支持浅色/深色主题（可在脚本中切换颜色）

## 触发事件

| 事件 | 说明 |
|------|------|
| `PermissionRequest` | Claude Code 需要权限授权时 |
| `TaskCompleted` | 任务节点完成时 |
| `Stop` | Claude Code 处理完成时 |
| `SubagentStop` | 子代理任务完成时 |

## 部署

### 1. 克隆仓库

```powershell
git clone https://github.com/你的用户名/claude-code-notifier.git F:/claude_all/window
```

如果已有该目录，直接下载两个脚本即可：

```powershell
# 只需两个文件
mkdir F:\claude_all\window\scripts -Force
# 将 scripts/notify.ps1 和 scripts/focus-vscode.ps1 放入该目录
```

### 2. 配置 Claude Code Hooks

编辑 `C:\Users\Shang\.claude\settings.json`，添加以下 `hooks` 字段（与现有字段平级）：

```json
{
  "hooks": {
    "PermissionRequest": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"F:/claude_all/window/scripts/notify.ps1\"",
            "async": true,
            "timeout": 15
          }
        ]
      }
    ],
    "TaskCompleted": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"F:/claude_all/window/scripts/notify.ps1\"",
            "async": true,
            "timeout": 15
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"F:/claude_all/window/scripts/notify.ps1\"",
            "async": true,
            "timeout": 15
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"F:/claude_all/window/scripts/notify.ps1\"",
            "async": true,
            "timeout": 15
          }
        ]
      }
    ]
  }
}
```

**注意：** 如果 `settings.json` 中已有 `hooks` 字段，将上述四个事件合并进去，而不是覆盖。

### 3. 验证部署

重启 Claude Code 后，或直接在终端测试：

```powershell
# 测试通知弹窗
echo '{"hook_event_name":"PermissionRequest"}' | powershell -NoProfile -ExecutionPolicy Bypass -File "F:\claude_all\window\scripts\notify.ps1"

# 测试 VS Code 聚焦
powershell -NoProfile -ExecutionPolicy Bypass -File "F:\claude_all\window\scripts\focus-vscode.ps1"
```

### 4. 测试真实场景

在 Claude Code 中触发需要权限的操作（如运行未授权的 bash 命令），右下角应弹出通知。

## 自定义

### 切换浅色/深色主题

编辑 `scripts/notify.ps1`，修改以下颜色值：

**深色主题（默认注释掉的配色）：**
```powershell
Background="#E8232328"      # 深灰背景
Foreground="#F0F0F0"        # 浅色标题
Foreground="#A0A0A0"        # 灰色正文
```

**浅色主题（当前默认）：**
```powershell
Background="#F0FFFFFF"      # 白色背景
Foreground="#1A1A1A"        # 深色标题
Foreground="#666666"        # 灰色正文
```

### 调整通知时长

修改第 164 行的 `FromSeconds(10)` 为你想要的秒数。

### 添加更多事件

在 `settings.json` 的 `hooks` 中添加新的事件名，如 `PermissionDenied`、`PostToolUse` 等。

## 需求

- Windows 10/11
- PowerShell 5.1（系统自带）
- Claude Code（VSCode 扩展）
