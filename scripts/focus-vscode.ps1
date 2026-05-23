# focus-vscode.ps1 - Find and bring VS Code window to foreground
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32Focus {
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hWnd);
}
"@

$processes = Get-Process -Name "code" -ErrorAction SilentlyContinue |
    Where-Object { $_.MainWindowHandle -ne 0 -and $_.MainWindowTitle -ne "" }

foreach ($proc in $processes) {
    $hwnd = $proc.MainWindowHandle
    if ([Win32Focus]::IsIconic($hwnd)) {
        [Win32Focus]::ShowWindow($hwnd, 9)  # SW_RESTORE
    }
    [Win32Focus]::SetForegroundWindow($hwnd)
    break
}
