# EndpointManager
Making lives easier using Microsoft Intune, I mean, Endpoint Manager since 2022 😎
<html>
<h2>deploy-remotehelp.ps1</h2>
<p>This script fills in a gap for Microsoft not having Remote Help in the Microsoft store app and only deploying as a W32App.</p>  
<p>Leverages the Microsoft Graph to connect to the MgGraph and IntuneWin32 modules, and pulls down the prepackaged application from my website <b>NOTE: you can add in code to pull down the latest version but i wanted to save time and make the app available to anyone at <a href="https://memphistech.net/tools/remotehelpinstaller.intunewin">remotehelpinstaller.intunewin</a></b></p>
<h2>Reset OneDrive</h2>
<p>This was a <b>bear</b> of a script to get working for an AD domain to domain profile migration.</p>
<p>Microsoft official stance when doing a domain migration is the "wipe and reload" approach however in the effort to "do no harm" in causing the user to have to reinstall applications, configure their profile, etc, this is typically a non-starter in a number of migrations.</p>
<p>When you have Known Folder Redirection enabled in a source domain, and then move that machine over to a target domain with a profile ReACL (which a number of tools can do but in this case we are using BinaryTree's Migration Pro / AD Pro toolset), this is one of the remnants left behind. These tools do a great job keeping the users "experience" the same however when moving between domains we don't want to keep the dependency on the source OneDrive and its "cloud" folder locations that were in another tenant.</p>
<p>To make things worse, running SYSTEM-level scripts typically cannot quiesce USER-level registry hives, so needing a means at the system level to load every registry hive and perform tasks was nearly impossible before this. Now, we have a working way to not only load the hives but process the registry changes within each.</p>
<p>In the end, the user is left with a “first run” experience not only reinitializing their OneDrive, but adding in a MISSING registry key for EnableADAL to make Single Sign-on that much easer.</p>
<h3> Known Issues </h3>
<p> When running the script it does not error check to see if the OneDrive keys already exist; it will process against ALL user hives (including ones that have never logged in). Potentially in some future version a try/catch might be added for processing.</p>
<p>Another future item would be logging (which could be easily done with a start-transcript), but since this is headless and ran against a large batch of machines at once, keeping it light weight is the goal with this version.</p>

<h2>Migrate SCCM</h2>
<p>In a domain to domain migration without performing a reset of the machine, we needed a SYSTEM-level script to update the SCCM site code and reset the cache. This one usese the existing SCCM COM modules to execute.</p>

<h2>Reset Intune</h2>
<p>This is a big one. Microsoft does NOT make it easy for you to transition a PC from one domain or tenant easily. In talking with their PSS team, their offical stance is a rebuild is the support approach for PC migration. I've worked many M&A projects over the years and Ive only seen 20% adopt this methodology - all the rest prefer to use tools to orchestrate the transition from one environment to another. </p>
<p>Moving between AD to AD isnt difficult with a number of tools out there (I like the Quest BinaryTree Migration Pro Active Directory Pro toolset for its ability to execute and orchestrate tasks) that can make this possible, but one thing that you DONT hear is that if you migrate a PC, it might be in another Azure AD tenant, but the MDM registration is still tied to the old tenant. This was the reason and birth for this script.</p>
<h2>Global Protect Secure Client</h2>
Still waiting for Microsoft to add this to the app catalog (even if its the Enterprise version in the Intune suite)
Grab the <ahref="https://memphistech.net/tools/globalsecureaccessclient.intunewin">globalsecureaccessclient.intunewin"> file and use these for the Intune app
<h3>Install</h3>
GlobalSecureAccessClient.exe /install /quiet /norestart
<h3>Uninstall</h3>
GlobalSecureAccessClient.exe /uninstall /quiet /norestart
<h3>MSI detection code</h3>
{4DD54F7E-2C84-4A52-AB11-EAC4FABB2551} 
</html>
