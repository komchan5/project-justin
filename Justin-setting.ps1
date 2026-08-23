param([switch]$Install, [switch]$Silent)

# Justin setting - Windows 11 / FiveM latency profile
# Run with: powershell -ExecutionPolicy Bypass -File .\Justin-setting.ps1

$ErrorActionPreference = 'Stop'
$RemoteSourceUrl = 'https://raw.githubusercontent.com/komchan5/project-justin/main/Justin-setting.ps1'
if ($env:JUSTIN_INSTALL_MODE -eq '1') { $Install = $true }

# Default mode is a self-contained graphical launcher. The same file relaunches
# itself elevated with -Install after the correct key is entered.
if (-not $Install) {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    [Windows.Forms.Application]::EnableVisualStyles()

    function Set-RoundedRegion($control,[int]$radius) {
        $path = [Drawing.Drawing2D.GraphicsPath]::new()
        $diameter = $radius * 2
        $rect = [Drawing.Rectangle]::new(0,0,$control.Width,$control.Height)
        $path.AddArc($rect.Left,$rect.Top,$diameter,$diameter,180,90)
        $path.AddArc($rect.Right-$diameter,$rect.Top,$diameter,$diameter,270,90)
        $path.AddArc($rect.Right-$diameter,$rect.Bottom-$diameter,$diameter,$diameter,0,90)
        $path.AddArc($rect.Left,$rect.Bottom-$diameter,$diameter,$diameter,90,90)
        $path.CloseFigure()
        $control.Region = [Drawing.Region]::new($path)
        $path.Dispose()
    }

    $form = [Windows.Forms.Form]::new()
    $form.Text = 'Justin Setting'
    $form.Size = [Drawing.Size]::new(1080, 620)
    $form.AutoScaleMode = 'Dpi'
    $form.ClientSize = [Drawing.Size]::new(1060,580)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'None'
    $form.MaximizeBox = $false
    $form.BackColor = [Drawing.Color]::FromArgb(7,8,11)
    $form.ForeColor = [Drawing.Color]::White
    $form.Font = [Drawing.Font]::new('Segoe UI',10)
    try {
        $backgroundUrl = 'https://raw.githubusercontent.com/komchan5/project-justin/main/project-justin-background.png'
        $backgroundBytes = [Net.WebClient]::new().DownloadData($backgroundUrl)
        $backgroundStream = [IO.MemoryStream]::new($backgroundBytes)
        $loadedBackground = [Drawing.Image]::FromStream($backgroundStream)
        $form.BackgroundImage = [Drawing.Bitmap]::new($loadedBackground)
        $form.BackgroundImageLayout = 'Stretch'
        $loadedBackground.Dispose()
        $backgroundStream.Dispose()
    } catch {
        # Keep the built-in dark fallback if the optional artwork is unavailable.
    }

    $title = [Windows.Forms.Label]::new()
    $title.Text = 'PROJECT JUSTIN'
    $title.Font = [Drawing.Font]::new('Segoe UI Black',25)
    $title.Location = [Drawing.Point]::new(48,36)
    $title.BackColor = [Drawing.Color]::Transparent
    $title.AutoSize = $true
    $form.Controls.Add($title)
    $title.Visible = $false

    $sub = [Windows.Forms.Label]::new()
    $sub.Text = 'MAX PERFORMANCE  |  NETWORK OPTIMIZER'
    $sub.ForeColor = [Drawing.Color]::FromArgb(155,164,184)
    $sub.Location = [Drawing.Point]::new(51,83)
    $sub.BackColor = [Drawing.Color]::Transparent
    $sub.AutoSize = $true
    $form.Controls.Add($sub)
    $sub.Visible = $false

    $panel = [Windows.Forms.Panel]::new()
    $panel.Location = [Drawing.Point]::new(36,36)
    $panel.Size = [Drawing.Size]::new(430,510)
    $panel.BackColor = [Drawing.Color]::FromArgb(23,24,29)
    $form.Controls.Add($panel)
    Set-RoundedRegion $panel 18

    $cardAccent = [Windows.Forms.Panel]::new()
    $cardAccent.Location = [Drawing.Point]::new(0,0)
    $cardAccent.Size = [Drawing.Size]::new(430,3)
    $cardAccent.BackColor = [Drawing.Color]::FromArgb(210,214,225)
    $panel.Controls.Add($cardAccent)

    $label = [Windows.Forms.Label]::new()
    $label.Text = 'LICENSE KEY'
    $label.ForeColor = [Drawing.Color]::FromArgb(155,164,184)
    $brandIcon = [Windows.Forms.Label]::new()
    $brandIcon.Text = 'J'
    $brandIcon.TextAlign = 'MiddleCenter'
    $brandIcon.Font = [Drawing.Font]::new('Segoe UI Black',12)
    $brandIcon.ForeColor = [Drawing.Color]::Black
    $brandIcon.BackColor = [Drawing.Color]::White
    $brandIcon.Location = [Drawing.Point]::new(28,28)
    $brandIcon.Size = [Drawing.Size]::new(34,34)
    $panel.Controls.Add($brandIcon)
    Set-RoundedRegion $brandIcon 8

    $cardTitle = [Windows.Forms.Label]::new()
    $cardTitle.Text = 'PROJECT JUSTIN V.1'
    $cardTitle.Font = [Drawing.Font]::new('Segoe UI Black',19)
    $cardTitle.ForeColor = [Drawing.Color]::White
    $cardTitle.Location = [Drawing.Point]::new(28,80)
    $cardTitle.AutoSize = $true
    $panel.Controls.Add($cardTitle)

    $cardSub = [Windows.Forms.Label]::new()
    $cardSub.Text = 'ENTER YOUR LICENSE KEY TO UNLOCK THE OPTIMIZER'
    $cardSub.Font = [Drawing.Font]::new('Segoe UI Semibold',7)
    $cardSub.ForeColor = [Drawing.Color]::FromArgb(175,180,193)
    $cardSub.Location = [Drawing.Point]::new(31,116)
    $cardSub.AutoSize = $true
    $panel.Controls.Add($cardSub)

    $label.Location = [Drawing.Point]::new(28,151)
    $label.Font = [Drawing.Font]::new('Segoe UI Semibold',9)
    $label.AutoSize = $true
    $panel.Controls.Add($label)

    $key = [Windows.Forms.TextBox]::new()
    $keyHost = [Windows.Forms.Panel]::new()
    $keyHost.Location = [Drawing.Point]::new(27,178)
    $keyHost.Size = [Drawing.Size]::new(376,46)
    $keyHost.BackColor = [Drawing.Color]::FromArgb(35,37,44)
    $panel.Controls.Add($keyHost)
    Set-RoundedRegion $keyHost 10

    $keyIcon = [Windows.Forms.Label]::new()
    $keyIcon.Text = 'O--'
    $keyIcon.Font = [Drawing.Font]::new('Segoe UI Semibold',9)
    $keyIcon.ForeColor = [Drawing.Color]::FromArgb(205,208,218)
    $keyIcon.Location = [Drawing.Point]::new(13,13)
    $keyIcon.AutoSize = $true
    $keyHost.Controls.Add($keyIcon)

    $key.Location = [Drawing.Point]::new(57,10)
    $key.Size = [Drawing.Size]::new(304,25)
    $key.Font = [Drawing.Font]::new('Segoe UI',12)
    $key.BackColor = [Drawing.Color]::FromArgb(35,37,44)
    $key.ForeColor = [Drawing.Color]::White
    $key.BorderStyle = 'None'
    $keyHost.Controls.Add($key)

    $features = [Windows.Forms.Label]::new()
    $features.Text = "[OK] LOW LATENCY POWER PLAN`r`n[OK] NETWORK AND TCP OPTIMIZATION`r`n[OK] FIVEM PRIORITY AND TIMER RESOLUTION"
    $features.Location = [Drawing.Point]::new(29,126)
    $features.Size = [Drawing.Size]::new(365,78)
    $features.Font = [Drawing.Font]::new('Segoe UI Semibold',9.5)
    $features.ForeColor = [Drawing.Color]::FromArgb(224,226,234)
    $panel.Controls.Add($features)
    $features.Visible = $false

    $remember = [Windows.Forms.CheckBox]::new()
    $remember.Text = 'REMEMBER ME'
    $remember.Checked = $true
    $remember.Font = [Drawing.Font]::new('Segoe UI Semibold',8)
    $remember.ForeColor = [Drawing.Color]::FromArgb(220,222,230)
    $remember.Location = [Drawing.Point]::new(28,239)
    $remember.Size = [Drawing.Size]::new(170,25)
    $remember.BackColor = [Drawing.Color]::Transparent
    $panel.Controls.Add($remember)

    $progress = [Windows.Forms.ProgressBar]::new()
    $progress.Location = [Drawing.Point]::new(28,219)
    $progress.Size = [Drawing.Size]::new(364,5)
    $panel.Controls.Add($progress)
    $progress.Visible = $false

    $status = [Windows.Forms.Label]::new()
    $status.Text = 'Enter the access key to continue.'
    $status.ForeColor = [Drawing.Color]::FromArgb(155,164,184)
    $status.Location = [Drawing.Point]::new(29,331)
    $status.Size = [Drawing.Size]::new(374,30)
    $status.TextAlign = 'MiddleCenter'
    $panel.Controls.Add($status)

    $button = [Windows.Forms.Button]::new()
    $button.Text = 'L O G I N'
    $button.Location = [Drawing.Point]::new(27,276)
    $button.Size = [Drawing.Size]::new(376,48)
    $button.FlatStyle = 'Flat'
    $button.FlatAppearance.BorderSize = 0
    $button.BackColor = [Drawing.Color]::FromArgb(74,77,88)
    $button.ForeColor = [Drawing.Color]::White
    $button.Font = [Drawing.Font]::new('Segoe UI Semibold',10)
    $button.Cursor = [Windows.Forms.Cursors]::Hand
    $panel.Controls.Add($button)
    Set-RoundedRegion $button 10

    $mini = [Windows.Forms.Label]::new()
    $mini.Text = 'LOW PING     STABLE     OPTIMIZED'
    $mini.Font = [Drawing.Font]::new('Segoe UI Semibold',8)
    $mini.ForeColor = [Drawing.Color]::FromArgb(185,188,197)
    $mini.Location = [Drawing.Point]::new(90,478)
    $mini.AutoSize = $true
    $panel.Controls.Add($mini)

    $support = [Windows.Forms.Label]::new()
    $support.Text = 'PROJECT JUSTIN  |  UPDATED 2026  |  V.1'
    $support.Font = [Drawing.Font]::new('Segoe UI Semibold',7)
    $support.ForeColor = [Drawing.Color]::FromArgb(150,154,166)
    $support.Location = [Drawing.Point]::new(99,367)
    $support.AutoSize = $true
    $panel.Controls.Add($support)

    $wave = [Windows.Forms.Panel]::new()
    $wave.Location = [Drawing.Point]::new(30,396)
    $wave.Size = [Drawing.Size]::new(370,66)
    $wave.BackColor = [Drawing.Color]::Transparent
    $wave.Add_Paint({
        param($sender,$e)
        $e.Graphics.SmoothingMode=[Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $colors=@([Drawing.Color]::FromArgb(205,205,212),[Drawing.Color]::FromArgb(90,94,106),[Drawing.Color]::FromArgb(55,58,68))
        for($line=0;$line -lt 3;$line++){
            $points=[System.Collections.Generic.List[Drawing.PointF]]::new()
            for($x=0;$x -le 370;$x+=4){
                $y=33+[Math]::Sin(($x/42.0)+($line*1.7))*(17-($line*3))
                $points.Add([Drawing.PointF]::new($x,[single]$y))
            }
            $p=[Drawing.Pen]::new($colors[$line],1.4)
            $e.Graphics.DrawCurve($p,$points.ToArray())
            $p.Dispose()
        }
    })
    $panel.Controls.Add($wave)

    $closeButton = [Windows.Forms.Button]::new()
    $closeButton.Text = 'X'
    $closeButton.Location = [Drawing.Point]::new(1017,13)
    $closeButton.Size = [Drawing.Size]::new(30,30)
    $closeButton.FlatStyle = 'Flat'
    $closeButton.FlatAppearance.BorderSize = 0
    $closeButton.BackColor = [Drawing.Color]::FromArgb(120,18,20,25)
    $closeButton.ForeColor = [Drawing.Color]::White
    $closeButton.Font = [Drawing.Font]::new('Segoe UI',15)
    $closeButton.Cursor = [Windows.Forms.Cursors]::Hand
    $closeButton.Add_Click({$form.Close()})
    $form.Controls.Add($closeButton)
    Set-RoundedRegion $closeButton 15

    $minButton = [Windows.Forms.Button]::new()
    $minButton.Text = '-'
    $minButton.Location = [Drawing.Point]::new(980,13)
    $minButton.Size = [Drawing.Size]::new(30,30)
    $minButton.FlatStyle = 'Flat'
    $minButton.FlatAppearance.BorderSize = 0
    $minButton.BackColor = [Drawing.Color]::FromArgb(120,18,20,25)
    $minButton.ForeColor = [Drawing.Color]::White
    $minButton.Cursor = [Windows.Forms.Cursors]::Hand
    $minButton.Add_Click({$form.WindowState='Minimized'})
    $form.Controls.Add($minButton)
    Set-RoundedRegion $minButton 15

    $dragging=$false; $dragOffset=[Drawing.Point]::Empty
    $form.Add_MouseDown({if($_.Button -eq 'Left'){$script:dragging=$true;$script:dragOffset=$_.Location}})
    $form.Add_MouseMove({if($script:dragging){$screen=$form.PointToScreen($_.Location);$form.Location=[Drawing.Point]::new($screen.X-$script:dragOffset.X,$screen.Y-$script:dragOffset.Y)}})
    $form.Add_MouseUp({$script:dragging=$false})

    # Right-side monochrome gaming hero. Drawn locally so the remote script
    # stays self-contained and does not download untrusted image assets.
    $hero = [Windows.Forms.Panel]::new()
    $hero.Location = [Drawing.Point]::new(500,20)
    $hero.Size = [Drawing.Size]::new(535,540)
    $hero.BackColor = [Drawing.Color]::FromArgb(10,11,14)
    $hero.Visible = $false
    $hero.Add_Paint({
        param($sender,$e)
        $g=$e.Graphics
        $g.SmoothingMode=[Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $rect=[Drawing.Rectangle]::new(0,0,$sender.Width,$sender.Height)
        $brush=[Drawing.Drawing2D.LinearGradientBrush]::new($rect,[Drawing.Color]::FromArgb(48,50,57),[Drawing.Color]::FromArgb(4,5,7),45)
        $g.FillRectangle($brush,$rect); $brush.Dispose()
        $pen=[Drawing.Pen]::new([Drawing.Color]::FromArgb(55,220,220,230),1)
        for($i=0;$i -lt 14;$i++){
            $x=($i*83)%535; $y=($i*137)%540
            $g.DrawLine($pen,$x,$y,[Math]::Min(535,$x+150),[Math]::Max(0,$y-100))
            $g.DrawEllipse($pen,$x,$y,3,3)
        }
        $pen.Dispose()
    })
    $form.Controls.Add($hero)

    $heroTop = [Windows.Forms.Label]::new()
    $heroTop.Text = 'MAX PERFORMANCE'
    $heroTop.Font = [Drawing.Font]::new('Segoe UI Semibold',10)
    $heroTop.ForeColor = [Drawing.Color]::Silver
    $heroTop.Location = [Drawing.Point]::new(350,18)
    $heroTop.AutoSize = $true
    $hero.Controls.Add($heroTop)

    $heroTitle = [Windows.Forms.Label]::new()
    $heroTitle.Text = "PROJECT`r`nJUSTIN"
    $heroTitle.Font = [Drawing.Font]::new('Segoe UI Black',44)
    $heroTitle.ForeColor = [Drawing.Color]::WhiteSmoke
    $heroTitle.Location = [Drawing.Point]::new(42,70)
    $heroTitle.Size = [Drawing.Size]::new(450,125)
    $hero.Controls.Add($heroTitle)

    $heroSub = [Windows.Forms.Label]::new()
    $heroSub.Text = 'NETWORK  |  SYSTEM  |  FIVEM'
    $heroSub.Font = [Drawing.Font]::new('Segoe UI Semibold',12)
    $heroSub.ForeColor = [Drawing.Color]::FromArgb(185,190,202)
    $heroSub.Location = [Drawing.Point]::new(48,202)
    $heroSub.AutoSize = $true
    $hero.Controls.Add($heroSub)

    $statusCard = [Windows.Forms.Panel]::new()
    $statusCard.Location = [Drawing.Point]::new(48,278)
    $statusCard.Size = [Drawing.Size]::new(430,155)
    $statusCard.BackColor = [Drawing.Color]::FromArgb(185,12,13,16)
    $hero.Controls.Add($statusCard)

    $statusTitle = [Windows.Forms.Label]::new()
    $statusTitle.Text = 'JUSTIN NETWORK TWEAK'
    $statusTitle.Font = [Drawing.Font]::new('Segoe UI Semibold',12)
    $statusTitle.Location = [Drawing.Point]::new(22,15)
    $statusTitle.AutoSize = $true
    $statusCard.Controls.Add($statusTitle)

    $checks = [Windows.Forms.Label]::new()
    $checks.Text = "[X] LOW PING`r`n[X] STABLE CONNECTION`r`n[X] SMOOTH GAMEPLAY`r`n[X] INPUT RESPONSE"
    $checks.Font = [Drawing.Font]::new('Segoe UI Semibold',10)
    $checks.ForeColor = [Drawing.Color]::Gainsboro
    $checks.Location = [Drawing.Point]::new(24,48)
    $checks.Size = [Drawing.Size]::new(220,92)
    $statusCard.Controls.Add($checks)

    $gauge = [Windows.Forms.Label]::new()
    $gauge.Text = "100%`r`nREADY"
    $gauge.TextAlign = 'MiddleCenter'
    $gauge.Font = [Drawing.Font]::new('Segoe UI Black',18)
    $gauge.ForeColor = [Drawing.Color]::White
    $gauge.Location = [Drawing.Point]::new(285,52)
    $gauge.Size = [Drawing.Size]::new(120,65)
    $statusCard.Controls.Add($gauge)

    $heroFooter = [Windows.Forms.Label]::new()
    $heroFooter.Text = 'RESPONSIVE  |  STABLE  |  SAFE PROFILE'
    $heroFooter.Font = [Drawing.Font]::new('Segoe UI Semibold',9)
    $heroFooter.ForeColor = [Drawing.Color]::Silver
    $heroFooter.Location = [Drawing.Point]::new(80,480)
    $heroFooter.AutoSize = $true
    $hero.Controls.Add($heroFooter)

    $timer = [Windows.Forms.Timer]::new()
    $timer.Interval = 500
    $script:child = $null
    $timer.Add_Tick({
        if ($script:child -and $script:child.HasExited) {
            $timer.Stop()
            $progress.Style = 'Continuous'
            $button.Enabled = $true
            $key.Enabled = $true
            if ($script:child.ExitCode -eq 0) {
                $progress.Value = 100
                $status.Text = 'Complete - restart Windows before playing FiveM.'
                $status.ForeColor = [Drawing.Color]::FromArgb(90,220,145)
                [Windows.Forms.MessageBox]::Show('Justin Setting installed. Restart Windows once.', 'Justin Setting', 'OK', 'Information') | Out-Null
            } else {
                $progress.Value = 0
                $status.Text = "Installation stopped (code $($script:child.ExitCode))."
                $status.ForeColor = [Drawing.Color]::FromArgb(255,105,105)
            }
        }
    })

    $button.Add_Click({
        if ($key.Text -cne 'Project - Justin') {
            $status.Text = 'Invalid key.'
            $status.ForeColor = [Drawing.Color]::FromArgb(255,105,105)
            return
        }
        try {
            $button.Enabled = $false
            $key.Enabled = $false
            $progress.Style = 'Marquee'
            $status.Text = 'Approve Administrator access to apply the profile...'
            $status.ForeColor = [Drawing.Color]::FromArgb(175,185,255)
            if ($PSCommandPath) {
                $args = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Install -Silent"
            } else {
                $remoteCommand = "`$env:JUSTIN_INSTALL_MODE='1'; iex (irm '$RemoteSourceUrl')"
                $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($remoteCommand))
                $args = "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encoded"
            }
            $script:child = Start-Process powershell.exe -Verb RunAs -WindowStyle Hidden -ArgumentList $args -PassThru
            $timer.Start()
        } catch {
            $progress.Style = 'Continuous'
            $button.Enabled = $true
            $key.Enabled = $true
            $status.Text = 'Administrator approval was cancelled.'
        }
    })
    $form.AcceptButton = $button
    [void]$form.ShowDialog()
    exit
}

# Relaunch as Administrator when needed.
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList @(
        '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', ('"' + $PSCommandPath + '"'), '-Install', '-Silent'
    )
    exit
}

function Set-Dword([string]$Path, [string]$Name, [uint32]$Value) {
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    New-ItemProperty -Path $Path -Name $Name -PropertyType DWord -Value $Value -Force | Out-Null
}

Write-Host '[1/6] Creating Justin setting power plan...'
$existing = powercfg /list | Select-String 'Justin setting'
if ($existing) {
    $planGuid = [regex]::Match($existing.Line, '[0-9a-fA-F-]{36}').Value
} else {
    $created = powercfg /duplicatescheme SCHEME_MIN
    $planGuid = [regex]::Match(($created -join ' '), '[0-9a-fA-F-]{36}').Value
    if (-not $planGuid) { throw 'Unable to create the power plan.' }
    powercfg /changename $planGuid 'Justin setting'
}

$usbSubgroup = '2a737441-1930-4402-8d77-b2bebba308a3'
$usbSuspend = '48e6b7a6-50f5-4782-a5d4-53bb8f07e226'
$processor = '54533251-82be-4824-96c1-47b60b740d00'
powercfg /setacvalueindex $planGuid $usbSubgroup $usbSuspend 0
powercfg /setdcvalueindex $planGuid $usbSubgroup $usbSuspend 0
powercfg /setacvalueindex $planGuid $processor '893dee8e-2bef-41e0-89c6-b55d0929964c' 100
powercfg /setacvalueindex $planGuid $processor 'bc5038f7-23e0-4960-96da-33abaf5935ec' 100
powercfg /setacvalueindex $planGuid $processor '0cc5b647-c1df-4637-891a-dec35c318583' 100
powercfg /setacvalueindex $planGuid $processor 'ea062031-0e34-4ff1-9b6d-eb1059334028' 100
powercfg /setacvalueindex $planGuid '501a4d13-42af-4429-9fd1-a8218c268e20' 'ee12f906-d277-404b-b6da-e5fa1a576df5' 0
powercfg /setactive $planGuid
powercfg -h off

Write-Host '[2/6] Applying TCP and network adapter settings...'
netsh int tcp set heuristics disabled | Out-Null
netsh int tcp set global autotuninglevel=normal rss=enabled timestamps=disabled ecncapability=disabled | Out-Null
$systemProfile = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile'
Set-Dword $systemProfile 'NetworkThrottlingIndex' ([uint32]::MaxValue)

$adapter = Get-NetAdapter | Where-Object Status -eq 'Up' | Sort-Object ifIndex | Select-Object -First 1
if ($adapter) {
    $disableKeywords = @(
        '*EEE','*FlowControl','*InterruptModeration','*LsoV2IPv4','*LsoV2IPv6',
        '*RscIPv4','*RscIPv6','EnableGreenEthernet','GigaLite','PowerSavingMode'
    )
    $properties = Get-NetAdapterAdvancedProperty -Name $adapter.Name -AllProperties -ErrorAction SilentlyContinue
    foreach ($keyword in $disableKeywords) {
        if ($properties.RegistryKeyword -contains $keyword) {
            Set-NetAdapterAdvancedProperty -Name $adapter.Name -RegistryKeyword $keyword -RegistryValue 0 -NoRestart -ErrorAction SilentlyContinue
        }
    }
    Set-NetAdapterRss -Name $adapter.Name -Enabled $true -NoRestart -ErrorAction SilentlyContinue
    Set-NetIPInterface -InterfaceIndex $adapter.ifIndex -AddressFamily IPv4 -InterfaceMetric 5
}
Set-NetTCPSetting -SettingName InternetCustom -AutoTuningLevelLocal Normal -ErrorAction SilentlyContinue

Write-Host '[3/6] Applying foreground and game scheduling...'
Set-Dword 'HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl' 'Win32PrioritySeparation' 0x26
Set-Dword $systemProfile 'SystemResponsiveness' 0
$games = Join-Path $systemProfile 'Tasks\Games'
Set-Dword $games 'GPU Priority' 8
Set-Dword $games 'Priority' 6

Write-Host '[4/6] Applying Windows gaming features...'
Set-Dword 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' 'AllowGameDVR' 0
Set-Dword 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled' 0
Set-Dword 'HKCU:\Software\Microsoft\GameBar' 'AutoGameModeEnabled' 1
Set-Dword 'HKCU:\Software\Microsoft\GameBar' 'AllowAutoGameMode' 1
Set-Dword 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' 'HwSchMode' 2

Write-Host '[5/6] Disabling requested background services...'
foreach ($serviceName in 'DiagTrack','WSearch','MapsBroker','RemoteRegistry','Fax') {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service) {
        Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
        Set-Service -Name $serviceName -StartupType Disabled
    }
}

Write-Host '[6/6] Installing the per-game 0.5 ms timer watcher...'
$installDirectory = Join-Path $env:ProgramData 'JustinSetting'
New-Item -ItemType Directory -Path $installDirectory -Force | Out-Null
$watcherPath = Join-Path $installDirectory 'JustinTimerWatcher.ps1'
$watcher = @'
$ErrorActionPreference = 'SilentlyContinue'
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class JustinTimerResolution {
    [DllImport("ntdll.dll")]
    public static extern uint NtSetTimerResolution(uint desired, bool set, out uint current);
}
"@
$desired = [uint32]5000
$locked = $false
$pattern = '^(FiveM($|_)|FiveM.*GameProcess|CitizenFX|GTA5)'
try {
    while ($true) {
        $running = @(Get-Process | Where-Object ProcessName -match $pattern).Count -gt 0
        if ($running -and -not $locked) {
            $current = [uint32]0
            [void][JustinTimerResolution]::NtSetTimerResolution($desired, $true, [ref]$current)
            $locked = $true
        } elseif (-not $running -and $locked) {
            $current = [uint32]0
            [void][JustinTimerResolution]::NtSetTimerResolution($desired, $false, [ref]$current)
            $locked = $false
        }
        Start-Sleep -Milliseconds 750
    }
} finally {
    if ($locked) {
        $current = [uint32]0
        [void][JustinTimerResolution]::NtSetTimerResolution($desired, $false, [ref]$current)
    }
}
'@
Set-Content -LiteralPath $watcherPath -Value $watcher -Encoding UTF8
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoLogo -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$watcherPath`""
$trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) -MultipleInstances IgnoreNew
Register-ScheduledTask -TaskName 'Justin Timer Resolution Watcher' -Action $action -Trigger $trigger -Settings $settings -Description 'Uses 0.5 ms timer resolution only while FiveM or GTA5 is running.' -Force | Out-Null
Start-ScheduledTask -TaskName 'Justin Timer Resolution Watcher'

if ($adapter) { Restart-NetAdapter -Name $adapter.Name -Confirm:$false }
Write-Host ''
Write-Host 'Justin setting installed successfully.' -ForegroundColor Green
Write-Host 'Restart Windows once before testing FiveM.' -ForegroundColor Yellow
if (-not $Silent) { Read-Host 'Press Enter to close' }
