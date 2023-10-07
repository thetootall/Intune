#Created by Chris Blackburn @thetootall
#This script will deploy the Remote Help app to a group of devices 
#This script will install the MgGraph (group management) and IntuneWin32 (application management) powershell modules
#MgGraph requires Global Admin to access the Graph Command Line for Group Access
#IntuneWin32 requires Intune Administrator or higher to create the application
#This script will download the prepacked intunewin file from my website for Remote Help

#big thanks to the following articles for guidance
#https://shehanperera.com/2023/05/24/intune-remote-help-01/
#https://msendpointmgr.com/2020/03/17/manage-win32-applications-in-microsoft-intune-with-powershell/
#https://andrewstaylor.com/2021/11/13/automating-app-deployment-with-winget-and-powershell/

#We need to connect to the Graph in order to get the ID of the deployment group 
Install-module Microsoft.Graph
Connect-MgGraph -Scopes 'Group.Read.All'
$all = Get-MgGroup | select  Id, DisplayName, Description, GroupTypes
$allgroup = $all | ?{$_.displayname -like "*win*"}

#select a group from the list
Get-MgGroup | select  Id, DisplayName, Description, GroupTypes | Sort-Object -Property DisplayName | foreach -Begin {$i=0} -Process {
$i++
"{0}. {1}" -f $i,$_.DisplayName,$_.Id
} -outvariable menu
$r = Read-Host "Select a group"
$a = $menu[$r-1].Split()[1]
$groupID = (Get-MgGroup | where {$_.displayname -like "*$a"}).id

#We need to connect the Intune graph
Install-Module -Name IntuneWin32App
import-module -name IntuneWin32App
$TenantName = "connectuclab.onmicrosoft.com"
Connect-MSIntuneGraph -TenantID $TenantName

#lets download the intunewin from my website
$tempfile = "$env:TEMP\remotehelpinstaller.intunewin"
$filesource = Invoke-WebRequest "https://memphistech.net/tools/remotehelpinstaller.intunewin" -OutFile $tempfile

#define all of the application criteria
$Publisher = "Microsoft"
$SourceFolderRoot = "C:\IntuneWinAppUtil\Source\RemoteHelp"
$Filepath = "C:\Program Files\Remote help"
$FileorFolder ="RemoteHelp.exe"
$DisplayName = "Remote Help"
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture All -MinimumSupportedWindowsRelease W10_21H2
$DetectionRule  = New-IntuneWin32AppDetectionRuleFile -DetectionType exists -Existence -Path "$filepath" -FileOrFolder "$fileorfolder" -Check32BitOn64System $false
$InstallCommandLine = "remotehelpinstaller.exe /quiet acceptTerms=1"
$UninstallCommandLine = "remotehelpinstaller.exe /uninstall /quiet acceptTerms=1"

#create the application
Add-IntuneWin32App -FilePath $tempfile -DisplayName $DisplayName -Description $DisplayName -Publisher $Publisher -InstallExperience system -RestartBehavior suppress -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Verbose

#now to assign the app
$Win32App = Get-IntuneWin32App -DisplayName $DisplayName -Verbose
#take our group ID from the beginning of the script and assign it to the app as required
Add-IntuneWin32AppAssignmentGroup -Include -ID $Win32App.id -GroupID $groupID -Intent required -Notification hideAll -Verbose
