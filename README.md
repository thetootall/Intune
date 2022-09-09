# EndpointManager
Script to aid management of endpoints
<html>
<h2>Reset OneDrive</h2>
<p>The first one was a <b>bear</b> of a script to get working for an AD domain to domain profile migration.</p>
<p>Microsoft official stance when doing a domain migration is the "wipe and reload" approach however in the effort to "do no harm" in causing the user to have to reinstall applications, configure their profile, etc, this is typically a non-starter in a number of migrations.</p>
<p>When you have Known Folder Redirection enabled in a source domain, and then move that machine over to a target domain with a profile ReACL (which a number of tools can do but in this case we are using BinaryTree's Migration Pro / AD Pro toolset), this is one of the remnants left behind. These tools do a great job keeping the users "experience" the same however when moving between domains we don't want to keep the dependency on the source OneDrive and its "cloud" folder locations that were in another tenant.</p>
<p>To make things worse, running SYSTEM-level scripts typically cannot quiesce USER-level registry hives, so needing a means at the system level to load every registry hive and perform tasks was nearly impossible before this. Now, we have a working way to not only load the hives but process the registry changes within each.</p>
<p>In the end, the user is left with a “first run” experience not only reinitializing their OneDrive, but adding in a MISSING registry key for EnableADAL to make Single Sign-on that much easer.</p>
<h3> Known Issues </h3>
<p> When running the script it does not error check to see if the OneDrive keys already exist; it will process against ALL user hives (including ones that have never logged in). Potentially in some future version a try/catch might be added for processing.</p>
<p>Another future item would be logging (which could be easily done with a start-transcript), but since this is headless and ran against a large batch of machines at once, keeping it light weight is the goal with this version.</p>
</html>
