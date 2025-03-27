# PowerShell script to create and manage scheduled builds

param (
    [Parameter(Position=0)]
    [ValidateSet("create", "remove", "list", "run-now")]
    [string]$Action = "list",
    
    [ValidateSet("daily", "weekly", "monthly")]
    [string]$Schedule = "daily",
    
    [string]$Time = "03:00",
    
    [ValidateSet("release", "debug", "cuda", "all")]
    [string]$BuildType = "all",
    
    [switch]$Clean
)

function Write-ColoredText {
    param (
        [string]$Text,
        [string]$Color = "White"
    )
    Write-Host $Text -ForegroundColor $Color
}

function Create-ScheduledBuild {
    param (
        [string]$Schedule,
        [string]$Time,
        [string]$BuildType,
        [bool]$Clean
    )
    
    $taskName = "TabbyAutoBuild_$BuildType"
    $scriptPath = Join-Path $PSScriptRoot "start-all-builds.bat"
    $workingDir = $PSScriptRoot
    
    # Build command arguments
    $arguments = "--unattended --notify"
    if ($Clean) { $arguments += " --clean" }
    
    if ($BuildType -ne "all") {
        $arguments += " --$($BuildType.ToLower())-only"
    }
    
    # Create trigger based on schedule
    switch ($Schedule) {
        "daily" {
            $trigger = New-ScheduledTaskTrigger -Daily -At $Time
            $schedule_desc = "daily at $Time"
        }
        "weekly" {
            $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At $Time
            $schedule_desc = "weekly on Monday at $Time"
        }
        "monthly" {
            $trigger = New-ScheduledTaskTrigger -Monthly -DaysOfMonth 1 -At $Time
            $schedule_desc = "monthly on day 1 at $Time"
        }
    }
    
    # Create the action to execute
    $action = New-ScheduledTaskAction -Execute $scriptPath -Argument $arguments -WorkingDirectory $workingDir
    
    # Task settings
    $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -WakeToRun -RunOnlyIfIdle -IdleDuration 00:10:00 -IdleWaitTimeout 02:00:00
    
    # Delete existing task if it exists
    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    } 
    catch {}
    
    # Create the scheduled task
    try {
        $task = Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Settings $settings -Description "Automated build for Tabby ($BuildType)"
        Write-ColoredText "Successfully created scheduled task: $taskName to run $schedule_desc" "Green"
        return $true
    }
    catch {
        Write-ColoredText "Failed to create scheduled task: $_" "Red"
        return $false
    }
}

function Remove-ScheduledBuild {
    param(
        [string]$BuildType
    )
    
    $taskName = "TabbyAutoBuild_$BuildType"
    
    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        Write-ColoredText "Successfully removed scheduled task: $taskName" "Green"
        return $true
    }
    catch {
        Write-ColoredText "Failed to remove scheduled task: $_" "Red"
        return $false
    }
}

function List-ScheduledBuilds {
    $tasks = Get-ScheduledTask -TaskName "TabbyAutoBuild_*" -ErrorAction SilentlyContinue
    
    if ($tasks -and $tasks.Count -gt 0) {
        Write-ColoredText "Current scheduled builds:" "Cyan"
        foreach ($task in $tasks) {
            $trigger = $task.Triggers[0]
            $nextRun = $task.NextRunTime
            $buildType = $task.TaskName -replace "TabbyAutoBuild_", ""
            
            Write-Host "- $($task.TaskName): " -NoNewline
            Write-Host "$buildType build" -ForegroundColor Green -NoNewline
            Write-Host ", Next run: $nextRun"
        }
    } 
    else {
        Write-ColoredText "No scheduled builds found." "Yellow"
    }
}

function Run-BuildNow {
    param(
        [string]$BuildType
    )
    
    $taskName = "TabbyAutoBuild_$BuildType"
    
    try {
        Start-ScheduledTask -TaskName $taskName
        Write-ColoredText "Successfully started task: $taskName" "Green"
        return $true
    }
    catch {
        Write-ColoredText "Failed to start task: $_" "Red"
        return $false
    }
}

# Main execution
Write-ColoredText "===== Tabby Scheduled Builds =====" "Cyan"

switch ($Action) {
    "create" {
        Create-ScheduledBuild -Schedule $Schedule -Time $Time -BuildType $BuildType -Clean $Clean.IsPresent
    }
    "remove" {
        Remove-ScheduledBuild -BuildType $BuildType
    }
    "list" {
        List-ScheduledBuilds
    }
    "run-now" {
        Run-BuildNow -BuildType $BuildType
    }
}
