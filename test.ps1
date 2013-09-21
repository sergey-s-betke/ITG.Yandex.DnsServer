[CmdletBinding(
	SupportsShouldProcess=$true,
	ConfirmImpact="Medium"
)]
param (
)

Import-Module `
	(Join-Path `
		-Path ( Split-Path -Path ( $MyInvocation.MyCommand.Path ) -Parent ) `
		-ChildPath 'ITG.Yandex.DnsServer.psd1' `
	) `
	-Force `
;
Set-Readme `
	-ModuleInfo ( Get-Module 'ITG.Yandex.DnsServer' ) `
	-ReferencedModules @(
		'ITG.Yandex', 'ITG.Utils', 'ITG.WinAPI.UrlMon', 'ITG.WinAPI.User32' | Get-Module
	) `
;

Set-Token `
    -DomainName 'csm.nov.ru' `
    -Token ( ConvertTo-SecureString -String (`
        '01000000d08c9ddf0115d1118c7a00c04fc297eb010000003c7609fd8f4ca94f'+
        '9aa41d9e6632179a0000000002000000000003660000c0000000100000000703'+
        '27065085138f1f6b98a9ab0a64dd0000000004800000a00000001000000002c2'+
        '302fc1c2e3332e887342b977db7f78000000664392f87f6424cb6ae82fcf4c66'+
        'becd1a737f986c92e092a4a9055413550a9dfd3b760089811c1efcaa8da17ea6'+
        'd03c9addbdca3f608787a4487701b5e117c657bc7334c7be36c6fcb7623d915c'+
        'dfe8ae30bad6b950af7d3437062d051f2bcac5fb118472b1701d43adbf0e0281'+
        'e5904256d5f7f305212714000000aa50cbd989d1423053c51a2062c07cbdb3720c2a'
    )) `
;
$PSDefaultParameterValues['*:DomainName'] = 'csm.nov.ru';
$PSDefaultParameterValues['*:ZoneName'] = 'csm.nov.ru';

Remove-DnsServerResourceRecord -Name 'autodiscover' -RRType CNAME;
Add-DnsServerResourceRecordCName -Name 'autodiscover' -HostAliasName 'gate';
Remove-DnsServerResourceRecord -Name '_autodiscover._tcp' -RRType SRV;
Add-DnsServerResourceRecordSRV -Name '_autodiscover._tcp' -Server 'autodiscover' -Port 443;

Remove-DnsServerResourceRecord -Name 'imap' -RRType CNAME;
Add-DnsServerResourceRecordCName -Name 'imap' -HostAliasName 'imap.yandex.ru.';
Remove-DnsServerResourceRecord -Name '_imap._tcp' -RRType SRV;
Add-DnsServerResourceRecordSRV -Name '_imap._tcp' -Server 'imap' -Port 993;

Remove-DnsServerResourceRecord -Name 'pop3' -RRType CNAME;
Add-DnsServerResourceRecordCName -Name 'pop3' -HostAliasName 'pop.yandex.ru.';
Remove-DnsServerResourceRecord -Name '_pop3._tcp' -RRType SRV;
Add-DnsServerResourceRecordSRV -Name '_pop3._tcp' -Server 'pop3' -Port 995;

Remove-DnsServerResourceRecord -Name 'smtp' -RRType CNAME;
Add-DnsServerResourceRecordCName -Name 'smtp' -HostAliasName 'smtp.yandex.ru.';
Remove-DnsServerResourceRecord -Name '_smtp._tcp' -RRType SRV;
Add-DnsServerResourceRecordSRV -Name '_smtp._tcp' -Server 'smtp' -Port 465;

Get-DnsServerResourceRecord -RRType 'SRV','CNAME','A','MX' `
| Out-GridView;

#Get-DnsServerResourceRecord -RRType 'SOA' `
#| Out-GridView;

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -Name 'test' `
#| Remove-DnsServerResourceRecord -ZoneName 'csm.nov.ru';
#Add-DnsServerResourceRecordTxt -ZoneName 'csm.nov.ru' -Name 'hostmaster' -Text 'IT department of CSM of Velikiy Novgorod. tel: +7 911 6499080.';

#Add-DnsServerResourceRecordTxt -ZoneName 'csm.nov.ru' -Name 'test' -Text 'IT department', 'CSM of Velikiy Novgorod', 'tel: +7 911 6499080.';
#Remove-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -Name 'test';

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -Name '_xmpp-server3._tcp' `
#| Remove-DnsServerResourceRecord -ZoneName 'csm.nov.ru';

#Get-DnsServerResourceRecord -ZoneName 'nice-tour.nov.ru' -Name '_xmpp-server3._tcp' `
#| Remove-DnsServerResourceRecord -ZoneName 'nice-tour.nov.ru' -PassThru `
#| Out-GridView;

#Add-DnsServerResourceRecordSRV `
#	-ZoneName 'csm.nov.ru' `
#	-Name '_test5-client._tcp.conference' `
#	-Server 'mail' `
#	-Port 20000 `
#	-Preference 10 `
#	-Weight 0 `
#	-Debug `
#;

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' `
#| ? { $_.HostName -like '*master' } `
#| Add-DnsServerResourceRecord -ZoneName 'nice-tour.nov.ru' -PassThru `
#| Out-GridView;

#Add-DnsServerResourceRecordA -ZoneName 'csm.nov.ru' -Name 'www4' -IPv4Address '172.31.0.9';
#Add-DnsServerResourceRecordA -ZoneName 'csm.nov.ru' -Name 'www5' -IPv4Address '172.31.0.9', '172.31.0.10';

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' `
#| ? { $_.HostName -like 'www*' } `
#| Remove-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -PassThru `
#| Out-GridView;

#Add-DnsServerResourceRecordAAAA `
#	-ZoneName 'csm.nov.ru' `
#	-Name 'www3' `
#	-IPv6Address '::1' `
#;
<#
ещё возможен и такой ответ Яндекса, его так же неплохобы корректно обрабатывать.
VERBOSE: Ответ API  <?xml version="1.0" encoding="utf-8"?>
<page>
    
    <xscript_invoke_failed error="block is timed out" block="block" method="ApiNsGetRecords" object="Yandex/PDDImport.id" timeout="5000"/>
</page>
#>

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -Name 'www2','www3' `
#| Remove-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -PassThru `
#| Out-GridView;

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' `
#| ? { $_.RecordType -ne 'SOA' } `
#| Select-Object -Property '*' -ExcludeProperty id `
#| Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' `
#| Out-GridView ;

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -RRType 'CNAME' `
#| Add-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -RecordData 'gate.novgaro.ru.' -PassThru -WhatIf `
#| Out-GridView;

#Add-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -Name 'test' -RRType 'CNAME' -RecordData 'gate.novgaro.ru.' -WhatIf;

#Add-DnsServerResourceRecordMX -ZoneName 'csm.nov.ru' -MailExchange 'gate.novgaro.ru.' -Preference 40;

#Add-DnsServerResourceRecordNS -ZoneName 'csm.nov.ru' -Name 'support' -NameServer 'ns1.csm.nov.ru.', 'ns2';

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -RRType 'NS' -Name 'support' `
#| Remove-DnsServerResourceRecord -ZoneName 'csm.nov.ru';

#| Remove-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -Name 'www2';

#Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'www3' -HostAliasName 'mail.csm.nov.ru.';
#Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'www4' -HostAliasName 'www3';

#Remove-DnsServerResourceRecord `
#	-ZoneName 'csm.nov.ru' `
#    -Name 'www2' `
#;



#Add-DnsServerResourceRecordSRV -ZoneName 'csm.nov.ru' -Name 'test' -Server 'xmpp' -Port 5269;
#Add-DnsServerResourceRecordA -ZoneName 'csm.nov.ru' -Name 'test5' -IPv4Address '172.31.0.9', '172.31.0.10';
#Add-DnsServerResourceRecordAAAA `
#	-ZoneName 'csm.nov.ru' `
#	-Name 'test3' `
#	-IPv6Address '::1' `
#;
#Add-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -Name 'test' -RRType 'CNAME' -RecordData 'gate';
#Add-DnsServerResourceRecordMX -ZoneName 'csm.nov.ru' -MailExchange 'mailserver' -Preference 40 -WhatIf;
#Add-DnsServerResourceRecordNS -ZoneName 'csm.nov.ru' -Name 'test' -NameServer 'ns1.csm.nov.ru.', 'ns2';
#Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'test2' -HostAliasName 'www3';
#
#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' `
#| ? { $_.HostName -like 'test*' } `
#| Remove-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -PassThru `
#| Out-GridView ;

# примеры использования DnsServer http://gallery.technet.microsoft.com/scriptcenter/DNS-Server-PowerShell-afc2142b

#Add-DnsServerResourceRecordTxt -ZoneName 'csm.nov.ru' -Text 'v=msv1 t=ddd2e2fe378a4a98d766ea3a278fe8';
#Add-DnsServerResourceRecordSRV -ZoneName 'csm.nov.ru' -Name '_sipfederationtls._tcp' -Server 'federation.messenger.msn.com.' -Port 5061 -Weight 2 -Preference 10;
##Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'mail' -HostAliasName 'go.domains.live.com.';
#Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'map' -HostAliasName 'go.domains.live.com.';
#Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'drive' -HostAliasName 'go.domains.live.com.';
#Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'cal' -HostAliasName 'go.domains.live.com.';
#Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'photos' -HostAliasName 'go.domains.live.com.';
#Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'profile' -HostAliasName 'go.domains.live.com.';
