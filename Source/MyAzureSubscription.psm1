
Function Enable-RDPandSSHForMyIP {
<#
.SYNOPSIS
    Allows my public ip on all Network Security group on which RDP is enabled.
.DESCRIPTION
    Allows my public ip on all Network Security group on which RDP is enabled. This is a security best practice in Advisor as well.
.EXAMPLE
    PS C:\> Enable-RDPandSSHForMyIP -ResourceGroupName 'ContosoAll' -Verbose
    VERBOSE: Script started.
    WARNING: TenantId '72f988bf-86f1-41af-91ab-2d7cd011db47' contains more than one active subscription. First one will be selected for further use. To select another subscription, use Set-AzContext.
    WARNING: Unable to acquire token for tenant '11da1590-20b4-4904-9318-a727a2a59a24'
    VERBOSE: Current Public Ip: 176.40.36.98
    VERBOSE: Script ended. Duration: 61 seconds.
    
    Allows my public ip on all Network Security group on which RDP is enabled.
#>

[CmdletBinding()]
Param(

 
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName

 

)
$ScriptStart = Get-Date
Write-Verbose "Script started."
if(-not (Get-AzContext)) {
try {

Connect-AzAccount -Verbose:$False | Out-Null -ErrorAction Stop
}
Catch {

throw "Could not connect to subscription. Error:  $($_.Exception.Message)"

}
}
try {
$Ipinfo  = Invoke-RestMethod http://ipinfo.io/json -Verbose:$False -ErrorAction Stop
Write-Verbose "Current Public Ip: $($Ipinfo.Ip)"
}
Catch {
    throw "Could not get public IP adress. Error:  $($_.Exception.Message)"
}

$NetworkSecurityGroups = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName
Foreach ($NetworkSecurityGroup in $NetworkSecurityGroups) {
    
    $RDPRules = Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $NetworkSecurityGroup | Where-Object {test-array $_.DestinationPortRange  @(3389,22)} 
    Write-Verbose "Found $($RDPRules.Count) number of rules for '$($NetworkSecurityGroup.Name)' in '$($NetworkSecurityGroup.ResourceGroupName)' resource to modify."
 

    foreach ($RDPRule in $RDPRules) {

    Set-AzNetworkSecurityRuleConfig -Direction Inbound -Priority $RDPRule.Priority -SourceAddressPrefix $Ipinfo.ip -NetworkSecurityGroup $NetworkSecurityGroup -Name $RDPRule.Name -Protocol $RDPRule.Protocol -Access $RDPRule.Access -SourcePortRange $RDPRule.SourcePortRange -DestinationPortRange $RDPRule.DestinationPortRange  -DestinationAddressPrefix $rdprule.DestinationAddressPrefix| out-null
    Write-Verbose "Setting SourceAddressPrefix of '$($RDPRule.Name)' to IP: $($Ipinfo.ip ) " 
    }

Set-AzNetworkSecurityGroup -NetworkSecurityGroup $NetworkSecurityGroup | Out-Null

}
$ScriptDuration =[Math]::Round(((Get-Date) - $ScriptStart).TotalSeconds)
Write-Verbose "Script ended. Duration: $ScriptDuration seconds."
}
Function Start-MyVm {
        <#
    .SYNOPSIS
        Starts VMS Asynrchonosly but waits for WaitforVM first to be started.
    .DESCRIPTION
        Starts VMS Asynrchonosly but waits for WaitforVM first to be started.
    .EXAMPLE
        .\Start-vms.ps1 -WaitForVM 'emreg-dc01' -VM 'emreg-hyperv','emreg-dsc','emreg-pull','emreg-web01' -ResourceGroupName 'ContosoAll' -Verbose

        WARNING: TenantId 'xxxxx-xxxxx-xxxxx-xxxxx-xxxxxxxx' contains more than one active subscription. First one will be selected for further use. To select another subscription, use Set-AzContext.
        WARNING: Unable to acquire token for tenant  'xxxxx-xxxxx-xxxxx-xxxxx-xxxxxxxx' 
        VERBOSE: emreg-dc01 already started. Skipping.
        VERBOSE: The following vms will be started asynchronous. emreg-hyperv,emreg-dsc,emreg-pull,emreg-web01
        VERBOSE: emreg-hyperv already started. Skipping.
        VERBOSE: emreg-dsc already started. Skipping.
        VERBOSE: emreg-pull already started. Skipping.
        VERBOSE: Starting emreg-web01
        VERBOSE: Script ended. Duration: 16.8350507 Seconds.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$VM,
        [string[]]$WaitForVM,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$ResourceGroupName,
        [int32]$WaitForVMSeconds
    )
    Begin {
        $Scriptstart = Get-Date
        
        if(-not (Get-AzContext)) {
            try {
            
            Connect-AzAccount -Verbose:$False | Out-Null -ErrorAction Stop
            }
            Catch {
            
            throw "Could not connect to subscription. Error:  $($_.Exception.Message)"
            
            }
            }
        if ($WaitForVM)
        {
            Foreach ($VMName in $WaitForVM) {
                try {
                    $VMstart = Get-Date
                    $VMtostart = Get-AzVM -Name $VMName -Status -ResourceGroupName $ResourceGroupName -ErrorAction Stop
                    if ($VMtostart.Statuses.DisplayStatus -notcontains 'VM running')  {
                    Write-Verbose "Starting $VMName before other vms."
                    Start-AzVM -Name $VMName -ResourceGroupName $ResourceGroupName -ErrorAction Stop | Out-Null
                    Write-Verbose "$VMName Started. Start duration: $([Math]::Round((Get-TimeSpan -Time $VMstart -Span TotalSeconds))) Seconds."
                    } else {
                        Write-Verbose "$VMName already started. Skipping."
                    }
                }
                catch {
                    throw $_
                }
            }
        }
        if ($WaitForVMSeconds) {

            Start-Sleep -Seconds $WaitForVMSeconds
        }

    }
    Process {
        Write-Verbose "The following vms will be started asynchronous. $($VM -join ',')"
        Foreach ($VMName in $VM) {
        try {
                       
            $VMtostart = Get-AzVM -Name $VMName -ResourceGroupName $ResourceGroupName -Status -ErrorAction Stop
            if ($VMtostart.Statuses.DisplayStatus -notcontains 'VM running') {
            Write-Verbose "Starting $VMName"
            Start-AzVM -Name $VMName -ResourceGroupName $ResourceGroupName -ErrorAction Stop -NoWait | Out-Null
            } 
            else {
                Write-Verbose "$VMName already started. Skipping."
            }
        }
        catch {
             
            throw "Operation failed on $VMName. Error:  $($_.Exception.Message)"
        
        }
    }
    }
    end {

        Write-Verbose "Script ended. Duration: $([Math]::Round((Get-TimeSpan -Time $Scriptstart -Span TotalSeconds))) Seconds."
}
}
Function Get-TimeSpan {
<#
    .SYNOPSIS
    Gets time difference of given datetime from now.
    .DESCRIPTION
    Gets time difference of given datetime from now.
    .EXAMPLE
    $StartTime = Getdate # wait for sometime
    Get-TimeSpan -Time $StartTime -Span TotalSeconds
    34.1737671
#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [DateTime]$Time,
        [ValidateSet('Days','Hours','MilliSeconds','Minutes','Seconds','TotalDays','TotalHours','TotalMilliSeconds','TotalMinutes','TotalSeconds')]
        [string]$Span='TotalHours'
    )
    
    ((Get-Date) - $Time).$Span
}
Function Test-Array{

    [CmdletBinding()]
    Param(
    
    $ArrayToCheck,
    $ItemsToCheck
    
    )
    
    
    $Result = Foreach ($Item in $ArrayToCheck) {
    
    
    if ($item -in $ItemsToCheck) {$true}
    
    }
    
    if ($result -contains $true) {$true} else {$false}
    
}    