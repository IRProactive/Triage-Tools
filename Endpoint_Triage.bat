@rem Batch Script for capturing volatile data from a potentially compromised system
@rem Directions: Navigate to the drive letter and run as administrator in the Command Prompt
@rem Directories will be created for files
@rem Directory Creation
mkdir \%COMPUTERNAME%
@rem Start Date and Time for reporting purposes
echo %date% %time% %COMPUTERNAME% > .\%COMPUTERNAME%\start.txt
@rem Directory Creation
mkdir \%COMPUTERNAME%\SystemInfo
mkdir \%COMPUTERNAME%\netstat
mkdir \%COMPUTERNAME%\tasklist
mkdir \%COMPUTERNAME%\RegistryFiles
mkdir \%COMPUTERNAME%\Accounts
mkdir \%COMPUTERNAME%\Logs
@rem System Information for reporting purposes and patch level
systeminfo > \%COMPUTERNAME%\SystemInfo\%COMPUTERNAME%_systeminfo.txt
@rem Disk Size information for reporting and subsequent forensic imaging if necessary
wmic diskdrive list >  \%COMPUTERNAME%\SystemInfo\%COMPUTERNAME%_diskinfo.txt
@rem Network Information
ipconfig -all > .\%COMPUTERNAME%\netstat\%COMPUTERNAME%_ipconfig.txt
ipconfig /displaydns > .\%COMPUTERNAME%\netstat\%COMPUTERNAME%_displaydns.txt
netstat -aon > .\%COMPUTERNAME%\netstat\%COMPUTERNAME%_netstat.txt
netstat -ab -proto > .\%COMPUTERNAME%\netstat\%COMPUTERNAME%_netstatproto.txt
@rem Processes and Tasks 
schtasks > .\%COMPUTERNAME%\tasklist\%COMPUTERNAME%_schtasks.csv
tasklist /m /FO csv > .\%COMPUTERNAME%\tasklist\%COMPUTERNAME%_tasklist_module.csv
tasklist /svc /FO csv > .\%COMPUTERNAME%\tasklist\%COMPUTERNAME%_tasklist_services.csv
tasklist /v /FO csv > .\%COMPUTERNAME%\tasklist\%COMPUTERNAME%_tasklist_verbose.csv 
wmic process list full > .\%COMPUTERNAME%\tasklist\%COMPUTERNAME%_process_list_full.txt
wmic startup list full > .\%COMPUTERNAME%\tasklist\%COMPUTERNAME%_startup_list_full.txt
@rem User and Administrator Accounts
net user > .\%COMPUTERNAME%\Accounts\%COMPUTERNAME%_user_accounts.txt
net localgroup administrator > .\%COMPUTERNAME%\Accounts\%COMPUTERNAME%_localgroup_administrators.txt
@rem Event and Security Logs
wevtutil epl Setup .\%COMPUTERNAME%\Logs\%COMPUTERNAME%_Setup.evtx
wevtutil epl System .\%COMPUTERNAME%\Logs\%COMPUTERNAME%_System.evtx
wevtutil epl Security .\%COMPUTERNAME%\Logs\%COMPUTERNAME%_Security.evtx
wevtutil epl Application .\%COMPUTERNAME%\Logs\%COMPUTERNAME%_Application.evtx
@rem Registry Files
cd \%COMPUTERNAME%\RegistryFiles
reg SAVE HKEY_CURRENT_USER ntuser_current_user
reg SAVE HKEY_CURRENT_CONFIG\SYSTEM current_config_system
reg SAVE HKEY_LOCAL_MACHINE\SECURITY security
reg SAVE HKEY_LOCAL_MACHINE\SAM sam
reg SAVE HKEY_LOCAL_MACHINE\System system
reg SAVE HKLM\SOFTWARE software
reg SAVE HKEY_USERS\.DEFAULT default
cd ../..
echo %date% %time% %COMPUTERNAME% > .\%COMPUTERNAME%\end.txt