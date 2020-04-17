$app = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]

$Template = [Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText01

#Gets the Template XML so we can manipulate the values
[xml]$ToastTemplate = ([Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($Template).GetXml())

<#
This is the output of the notification and will be added to the On wake up events for windows.
#>
[xml]$ToastTemplate = @"
<toast launch="app-defined-string">
  <visual>
    <binding template="ToastGeneric">
      <text>Do Udemy Practice you fool...</text>
      <text>Kevin keep up the good work</text>
    </binding>
  </visual>
  <actions>
    <action activationType="background" content="Remind me later" arguments="later"/>
  </actions>
</toast>
"@

$ToastXml = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
$ToastXml.LoadXml($ToastTemplate.OuterXml)


$notify = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app)
$notify.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(5)
#$notify.SuppressPopup = $true

$notify.Show($ToastXml)