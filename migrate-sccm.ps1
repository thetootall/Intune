#####################################################################
# Developed by Chris Blackburn & Katie Boss
# Info @ https://github.com/thetootall/EndpointManager
#####################################################################

#Update SCCM Site Code
$newsite = "<enter site code here>"
$sms = new-object –comobject "Microsoft.SMS.Client"
if ($sms.GetAssignedSite() –ne $newsite) { $sms.SetAssignedSite($newsite) }

#Clear SCCM Cache
$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
$CacheElements = $Cache.GetCacheElements()
foreach ($Element in $CacheElements) {
$Cache.DeleteCacheElement($Element.CacheElementID)
}
