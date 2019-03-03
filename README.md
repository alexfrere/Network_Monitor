# Network_Monitor
Utility script to monitor home network uptime on Windows OS. 

This script runs continuously, regularly hitting `google.com` - to determine when your internet connection is down. 

Downtime is written to a daily log file in `/network_logs/*.txt`.

# Usage
* NOTE - only supported on Windows OS
* Clone the repo
* Ensure the computer where this is running [is configured to stay on](https://answers.microsoft.com/en-us/windows/forum/windows_10-power/how-to-make-my-computer-stay-on-longer-before-it/c9924588-4600-4cf9-ae9f-3967b42ad92f).
* Create a shortcut to invoke the `Network_Monitor.ps1` and leave this on the Desktop. See [how to invoke PS script by double-clicking](https://stackoverflow.com/questions/10137146/is-there-any-way-to-make-powershell-script-work-by-double-clicking-ps1-file#answer-10137272).
* [Add this shortcut to the Startup programs](https://www.howtogeek.com/208224/how-to-add-programs-files-and-folders-to-system-startup-in-windows-8.1/) to ensure the monitoring continues during system restarts.