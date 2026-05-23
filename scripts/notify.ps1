# notify.ps1 - Read hook stdin JSON, show slide-in notification popup

$rawInput = ""
try {
    # Read stdin with timeout to avoid hanging
    $rawInput = [Console]::In.ReadToEnd()
} catch {
    $rawInput = ""
}

$eventName = "unknown"
if ($rawInput -and $rawInput.Trim() -ne "") {
    try {
        $hookData = $rawInput | ConvertFrom-Json
        if ($hookData -and $hookData.hook_event_name) {
            $eventName = $hookData.hook_event_name
        }
    } catch {
        $eventName = "unknown"
    }
}

switch ($eventName) {
    "PermissionRequest" {
        $title = "Claude Code - Permission Required"
        $message = "Claude Code needs your authorization. Click here to open VS Code."
    }
    "TaskCompleted" {
        $title = "Claude Code - Task Complete"
        $message = "Task node has completed. Click here to view results."
    }
    "Stop" {
        $title = "Claude Code - Finished"
        $message = "Claude Code has finished processing."
    }
    "SubagentStop" {
        $title = "Claude Code - Subagent Finished"
        $message = "Subagent task has completed."
    }
    default {
        $title = "Claude Code"
        $message = "Claude Code needs your attention."
    }
}

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$windowWidth = 360
$windowHeight = 120
$margin = 16
$left = $screen.Right - $windowWidth - $margin
$top = $screen.Bottom - $windowHeight - $margin

$xamlTitle = [System.Security.SecurityElement]::Escape($title)
$xamlMessage = [System.Security.SecurityElement]::Escape($message)

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent"
    Topmost="True"
    ShowInTaskbar="False"
    ResizeMode="NoResize"
    Width="$windowWidth"
    Height="$windowHeight"
    Left="$left"
    Top="$($top + 100)"
    Cursor="Hand">
    <Window.Resources>
        <Storyboard x:Key="SlideIn">
            <DoubleAnimation Storyboard.TargetProperty="(Window.Top)"
                From="$($top + 100)" To="$top" Duration="0:0:0.25">
                <DoubleAnimation.EasingFunction>
                    <CubicEase EasingMode="EaseOut"/>
                </DoubleAnimation.EasingFunction>
            </DoubleAnimation>
        </Storyboard>
        <Storyboard x:Key="FadeOut">
            <DoubleAnimation Storyboard.TargetProperty="Opacity"
                From="1" To="0" Duration="0:0:0.3"/>
        </Storyboard>
    </Window.Resources>
    <Border Background="#F0FFFFFF" CornerRadius="10" BorderBrush="#D0D0D0" BorderThickness="1"
            Margin="0" Padding="16,14">
        <Border.Effect>
            <DropShadowEffect BlurRadius="16" ShadowDepth="0" Opacity="0.15" Color="Black"/>
        </Border.Effect>
        <Grid>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>

            <Border Grid.Column="0" Width="40" Height="40" CornerRadius="8"
                    VerticalAlignment="Center" Margin="0,0,12,0">
                <Border.Background>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                        <GradientStop Color="#D97706" Offset="0"/>
                        <GradientStop Color="#F59E0B" Offset="1"/>
                    </LinearGradientBrush>
                </Border.Background>
                <TextBlock Text="!" FontSize="22" FontWeight="Bold"
                           HorizontalAlignment="Center" VerticalAlignment="Center"
                           Foreground="White"/>
            </Border>

            <StackPanel Grid.Column="1" VerticalAlignment="Center">
                <TextBlock x:Name="TitleText" FontSize="14" FontWeight="SemiBold"
                           Foreground="#1A1A1A" TextWrapping="Wrap" Margin="0,0,0,4"
                           Text="${xamlTitle}"/>
                <TextBlock x:Name="MessageText" FontSize="12"
                           Foreground="#666666" TextWrapping="Wrap" MaxWidth="240"
                           Text="${xamlMessage}"/>
            </StackPanel>

            <Button x:Name="CloseButton" Grid.Column="2" Width="24" Height="24"
                    VerticalAlignment="Top" Margin="8,0,0,0" Cursor="Hand">
                <Button.Template>
                    <ControlTemplate TargetType="Button">
                        <Border Background="#1A000000" CornerRadius="12">
                            <TextBlock Text="X" FontSize="11" Foreground="#666666"
                                       HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Button.Template>
            </Button>
        </Grid>
    </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$focusScript = "F:\claude_all\window\scripts\focus-vscode.ps1"

$window.Add_MouseLeftButtonDown({
    $argList = "-NoProfile -ExecutionPolicy Bypass -File `"$focusScript`""
    Start-Process -FilePath "powershell" -ArgumentList $argList -WindowStyle Hidden
    $window.Close()
})

$window.Add_MouseRightButtonDown({
    $window.Close()
})

$closeButton = $window.FindName("CloseButton")
if ($closeButton) {
    $closeButton.Add_Click({ $window.Close() })
}

$window.Add_Loaded({
    $sb = $window.FindResource("SlideIn")
    if ($sb) { $sb.Begin($window) }
})

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(10)
$timer.Add_Tick({
    $fo = $window.FindResource("FadeOut")
    if ($fo) {
        $fo.Add_Completed({ $window.Close() })
        $fo.Begin($window)
    }
    $timer.Stop()
})
$timer.Start()

$window.ShowDialog()
