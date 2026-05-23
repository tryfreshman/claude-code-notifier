# Claude Code Desktop Notifier / Claude Code 桌面通知弹窗

[English](#english) | [中文](#中文)

---

## English

A zero-dependency Windows notification system for Claude Code. When Claude Code needs your permission or a task completes, a WPF notification window slides in from the bottom-right corner. Click it to bring VS Code to the foreground.

### Features

- Slide-in WPF notification from screen bottom-right
- Click to auto-focus VS Code window (restores from minimized)
- Auto-dismiss with fade-out after 10 seconds
- Light theme (dark theme colors available in comments)
- Zero dependencies — PowerShell 5.1 only (built into Windows)

### Trigger Events

| Event | Description |
|------|-------------|
| `PermissionRequest` | Claude Code needs authorization |
| `TaskCompleted` | A task node has completed |
| `Stop` | Claude Code finished processing |
| `SubagentStop` | A subagent task completed |

### Deployment

#### 1. Clone or Download

```powershell
git clone https://github.com/tryfreshman/claude-code-notifier.git F:/claude_all/window
```

Or download just the two scripts into `F:\claude_all\window\scripts\`.

#### 2. Configure Claude Code Hooks

Edit `C:\Users\YourName\.claude\settings.json`, add the `"hooks"` field alongside existing fields:

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

> **Note:** If `hooks` already exists, merge the four events into it — don't replace.

#### 3. Verify

```powershell
# Test notification popup
echo '{"hook_event_name":"PermissionRequest"}' | powershell -NoProfile -ExecutionPolicy Bypass -File "F:\claude_all\window\scripts\notify.ps1"

# Test VS Code focus
powershell -NoProfile -ExecutionPolicy Bypass -File "F:\claude_all\window\scripts\focus-vscode.ps1"
```

### Customization

**Switch theme** — edit color values in `scripts/notify.ps1`:

```
Light (default): Background="#F0FFFFFF"  Title="#1A1A1A"  Body="#666666"
Dark:            Background="#E8232328"  Title="#F0F0F0"  Body="#A0A0A0"
```

**Change duration** — modify `FromSeconds(10)` on line 164.

**Add events** — add more hook event names in `settings.json` (e.g. `PermissionDenied`, `PostToolUse`).

### Requirements

- Windows 10/11
- PowerShell 5.1 (pre-installed)
- Claude Code (VS Code extension)

### Similar Projects

- [code-notify](https://github.com/mylee04/code-notify) — Cross-platform, npm-based, multi-tool support
- [AgentTray](https://github.com/sprklai/agenttray) — System tray app with Tauri, hotkeys, rich dashboard
- [BurnClaw](https://github.com/asantinos/burnclaw) — Windows tray widget with usage stats
- [@claude-code-hooks/notification](https://www.npmjs.com/package/@claude-code-hooks/notification) — npm CLI, PowerShell toast

---

## 中文

零依赖的 Claude Code Windows 桌面通知系统。当需要点权限或任务完成时，右下角弹出 WPF 通知窗口，点击即可将 VS Code 带到前台。

### 功能

- WPF 通知弹窗从屏幕右下角滑入
- 点击通知自动聚焦 VS Code（支持从最小化还原）
- 10 秒后自动淡出消失
- 浅色主题（深色配色已注释可切换）
- 零依赖 — 仅需 Windows 自带 PowerShell 5.1

### 触发事件

| 事件 | 说明 |
|------|------|
| `PermissionRequest` | Claude Code 需要权限授权 |
| `TaskCompleted` | 任务节点完成 |
| `Stop` | Claude Code 处理完成 |
| `SubagentStop` | 子代理任务完成 |

### 部署步骤

#### 1. 克隆仓库

```powershell
git clone https://github.com/tryfreshman/claude-code-notifier.git F:/claude_all/window
```

或直接下载 `scripts/notify.ps1` 和 `scripts/focus-vscode.ps1` 放入 `F:\claude_all\window\scripts\`。

#### 2. 配置 Hooks

编辑 `C:\Users\你的用户名\.claude\settings.json`，添加 `"hooks"` 字段：

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

> **注意：** 如果已有 `hooks` 字段，将四个事件合并进去，不要覆盖。

#### 3. 验证

```powershell
# 测试通知弹窗
echo '{"hook_event_name":"PermissionRequest"}' | powershell -NoProfile -ExecutionPolicy Bypass -File "F:\claude_all\window\scripts\notify.ps1"

# 测试 VS Code 聚焦
powershell -NoProfile -ExecutionPolicy Bypass -File "F:\claude_all\window\scripts\focus-vscode.ps1"
```

### 自定义

**切换主题** — 编辑 `scripts/notify.ps1` 中的颜色值：

```
浅色（默认）：Background="#F0FFFFFF"  Title="#1A1A1A"  Body="#666666"
深色：        Background="#E8232328"  Title="#F0F0F0"  Body="#A0A0A0"
```

**调整时长** — 修改第 164 行 `FromSeconds(10)` 中的秒数。

**添加事件** — 在 `settings.json` 的 `hooks` 中添加更多事件名。

### 系统需求

- Windows 10/11
- PowerShell 5.1（系统自带）
- Claude Code（VSCode 扩展）

### 同类项目

- [code-notify](https://github.com/mylee04/code-notify) — 跨平台、npm 生态、多工具支持
- [AgentTray](https://github.com/sprklai/agenttray) — 系统托盘应用、全局热键、丰富仪表盘
- [BurnClaw](https://github.com/asantinos/burnclaw) — Windows 托盘 + 用量统计
- [@claude-code-hooks/notification](https://www.npmjs.com/package/@claude-code-hooks/notification) — npm CLI 通知
