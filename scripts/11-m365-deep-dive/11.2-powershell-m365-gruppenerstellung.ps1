# Quelle: docs/11-m365-deep-dive/11.2-microsoft-teams-governance-erstellung-gaeste.md
# Nur in der eigenen Lab-Umgebung verwenden. Platzhalter vor dem Einsatz anpassen.

# Module installieren (falls noch nicht vorhanden)
Install-Module AzureADPreview -Force

# Mit dem Tenant als Global Admin verbinden
Connect-AzureAD

# Die ObjectID der zuvor synchronisierten Gruppe abrufen
$GroupName = "GRP_Teams_Creator"
$TargetGroup = Get-AzureADGroup -SearchString $GroupName

# Die globalen Verzeichniseinstellungen laden und anpassen
$Template = Get-AzureADDirectorySettingTemplate | Where-Object {$_.DisplayName -eq "Group.Unified"}
$Setting = $Template.CreateDirectorySetting()
$Setting["EnableGroupCreation"] = $false
$Setting["GroupCreationAllowedGroupId"] = $TargetGroup.ObjectId

# Einstellungen in den Tenant schreiben
New-AzureADDirectorySetting -DirectorySetting $Setting
