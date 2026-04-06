# VS Code Claude Code Proxy Fix — 403 Forbidden / Request Not Allowed

[English](#english) | [中文](#中文)

---

## English

### Problem

When using **Cline** or **Claude Code** inside VS Code, you get errors like:

```
Failed to authenticate
API Error: 403
{"error":{"type":"forbidden","message":"Request not allowed"}}
```

But when you run Claude Code **directly in the terminal** (after setting proxy env vars manually), it works fine.

### Root Cause

VS Code and its extensions do **not** automatically inherit proxy environment variables from your shell. When VS Code spawns extension host processes or child processes (like Claude Code), those processes may not have the proxy variables set — so their HTTP requests go out without a proxy and get blocked.

This is **not** a Claude account problem, and **not** a proxy software problem. It is a process environment inheritance issue specific to how VS Code launches extensions and subprocesses.

### Solution: Silent Proxy Launcher (`.vbs`)

Create a VBScript launcher that:
1. Sets all required proxy environment variables **before** launching VS Code
2. Launches VS Code silently (no black console window)
3. Can be pinned to the Start Menu or Taskbar

The launcher file is: [`launch_vscode_proxy.vbs`](./launch_vscode_proxy.vbs)

### Usage

1. **Download** `launch_vscode_proxy.vbs` from this repository.

2. **Edit** the file to match your environment:

   > ⚠️ **You MUST change these two values to match your setup:**
   >
   > - `http://127.0.0.1:2048` → your actual proxy address and port
   > - `D:\Microsoft VS Code\Code.exe` → your actual VS Code installation path

3. **Double-click** the `.vbs` file to launch VS Code with proxy settings applied.

4. **Optional — Pin to Start Menu or Taskbar:**
   - Right-click the `.vbs` file → **Create shortcut**
   - Right-click the shortcut → **Pin to Start** or drag to Taskbar

### How It Works

```
VBScript sets env vars
        ↓
VS Code launches (inherits env vars)
        ↓
Extension host inherits env vars
        ↓
Claude Code subprocess inherits env vars
        ↓
HTTP requests go through proxy ✓
```

The key insight: by setting proxy variables in the **parent process** before VS Code starts, all child processes (including extension hosts and Claude Code) inherit them automatically.

### Environment Variables Set

| Variable | Value |
|---|---|
| `HTTP_PROXY` | `http://127.0.0.1:2048` |
| `HTTPS_PROXY` | `http://127.0.0.1:2048` |
| `ALL_PROXY` | `http://127.0.0.1:2048` |
| `http_proxy` | `http://127.0.0.1:2048` |
| `https_proxy` | `http://127.0.0.1:2048` |
| `all_proxy` | `http://127.0.0.1:2048` |
| `NO_PROXY` | `127.0.0.1,localhost` |
| `no_proxy` | `127.0.0.1,localhost` |

Both uppercase and lowercase variants are set because different tools and runtimes (Node.js, Python, Go, etc.) may check either form.

### Requirements

- Windows (tested on Windows 10/11)
- VS Code installed
- A local HTTP proxy running (e.g., Clash, V2Ray, etc.)

### Keywords

VS Code Claude Code 403 forbidden, Cline 403 error, Claude API proxy Windows, VS Code extension proxy environment variable, Request not allowed Claude, Claude Code proxy not working VS Code, HTTPS_PROXY VS Code extension host, claude code not working behind proxy, cline extension 403 error behind firewall, VS Code extension host no proxy, claude code proxy bypass, anthropic API 403 windows, claude code firewall fix, VBScript VS Code launcher proxy, VS Code silent launcher proxy environment, cline forbidden error fix

---

## 中文

### 问题描述

在 VS Code 中使用 **Cline** 或 **Claude Code** 时，出现如下报错：

```
Failed to authenticate
API Error: 403
{"error":{"type":"forbidden","message":"Request not allowed"}}
```

但在终端里手动设置代理环境变量后，直接运行 Claude Code 是完全正常的。

### 根本原因

VS Code 及其扩展**不会**自动从你的 Shell 继承代理环境变量。当 VS Code 启动扩展宿主进程或子进程（如 Claude Code）时，这些进程可能没有代理变量，导致 HTTP 请求直连外网被拦截。

这**不是** Claude 账号问题，也**不是**代理软件本身的问题，而是 VS Code 启动扩展和子进程时的进程环境变量继承问题。

### 解决方案：静默代理启动器（`.vbs`）

创建一个 VBScript 启动器，功能如下：
1. 在启动 VS Code **之前**设置所有必要的代理环境变量
2. 静默启动 VS Code（不弹出黑色控制台窗口）
3. 可固定到开始菜单或任务栏

启动器文件：[`launch_vscode_proxy.vbs`](./launch_vscode_proxy.vbs)

### 使用方法

1. **下载**本仓库中的 `launch_vscode_proxy.vbs`。

2. **编辑**文件，修改以下两处以匹配你的实际环境：

   > ⚠️ **必须修改这两个值：**
   >
   > - `http://127.0.0.1:2048` → 你的代理地址和端口
   > - `D:\Microsoft VS Code\Code.exe` → 你的 VS Code 实际安装路径

3. **双击** `.vbs` 文件，即可带代理启动 VS Code。

4. **可选 — 固定到开始菜单或任务栏：**
   - 右键 `.vbs` 文件 → **创建快捷方式**
   - 右键快捷方式 → **固定到「开始」** 或拖到任务栏

### 原理说明

```
VBScript 设置环境变量
        ↓
VS Code 启动（继承环境变量）
        ↓
扩展宿主进程继承环境变量
        ↓
Claude Code 子进程继承环境变量
        ↓
HTTP 请求通过代理发出 ✓
```

关键点：在 VS Code 启动**之前**，由父进程设置好代理变量，之后所有子进程（包括扩展宿主和 Claude Code）都会自动继承。

### 设置的环境变量

| 变量名 | 值 |
|---|---|
| `HTTP_PROXY` | `http://127.0.0.1:2048` |
| `HTTPS_PROXY` | `http://127.0.0.1:2048` |
| `ALL_PROXY` | `http://127.0.0.1:2048` |
| `http_proxy` | `http://127.0.0.1:2048` |
| `https_proxy` | `http://127.0.0.1:2048` |
| `all_proxy` | `http://127.0.0.1:2048` |
| `NO_PROXY` | `127.0.0.1,localhost` |
| `no_proxy` | `127.0.0.1,localhost` |

同时设置大写和小写两种形式，因为不同工具和运行时（Node.js、Python、Go 等）对变量名的大小写要求不同。

### 运行环境

- Windows（在 Windows 10/11 上测试通过）
- 已安装 VS Code
- 本地有正在运行的 HTTP 代理软件（如 Clash、V2Ray 等）

### 搜索关键词

VS Code Claude Code 403 forbidden, Cline 403 报错, Claude API 代理 Windows, VS Code 扩展代理环境变量, Request not allowed Claude, Claude Code 代理不生效 VS Code, HTTPS_PROXY 扩展宿主, Claude Code 无法连接, VS Code 代理设置不生效, Cline 扩展 403 错误, Claude Code 防火墙代理, anthropic API 403 中国大陆, VBS 静默启动 VS Code 代理, VS Code 子进程环境变量继承, claude code behind proxy china

---

## License

MIT
