[CmdletBinding(
	SupportsShouldProcess=$true,
	ConfirmImpact="Medium"
)]
param (
	# имя домена - любой из доменов, зарегистрированных под Вашей учётной записью на сервисах Яндекса
	[Parameter()]
	[string]
	[ValidateScript( { $_ -match "^$($reDomain)$" } )]
	[Alias("domain_name")]
	[Alias("Domain")]
	$DomainName = 'csm.nov.ru'
)

Import-Module `
	(Join-Path `
		-Path ( Split-Path -Path ( $MyInvocation.MyCommand.Path ) -Parent ) `
		-ChildPath 'ITG.Yandex.DnsServer' `
	) `
	-Force `
	-PassThru `
| Get-Readme `
	-OutDefaultFile `
	-ReferencedModules @(
		'ITG.Yandex', 'ITG.Utils', 'ITG.WinAPI.UrlMon', 'ITG.WinAPI.User32' | Get-Module
	) `
;

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -RRType 'SOA' `
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

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' `
#| ? { $_.HostName -like '*master' } `
#| Add-DnsServerResourceRecord -ZoneName 'nice-tour.nov.ru' -PassThru `
#| Out-GridView;

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -RRType 'A','CNAME','NS' `
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
