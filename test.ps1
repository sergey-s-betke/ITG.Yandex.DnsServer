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
| Get-Readme -OutDefaultFile `
;

# Add-DnsServerResourceRecordSRV -ZoneName 'csm.nov.ru' -Name '_xmpp-server2._tcp' -Server 'xmpp' -Port 5269 -Weight 2;

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' `
#| ? { $_.id -ne 0 } `
#| ? { $_.HostName -like '*xmpp*' } `
#| Add-DnsServerResourceRecord -ZoneName 'nice-tour.nov.ru' -PassThru `
#| Out-GridView;

#Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -RRType 'A','CNAME','NS' `
#| Out-GridView;

#Add-DnsServerResourceRecordA `
#	-ZoneName 'csm.nov.ru' `
#	-Name 'www2' `
#	-IPv4Address '172.31.0.9' `
#;
#
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

# примеры использования DnsServer http://gallery.technet.microsoft.com/scriptcenter/DNS-Server-PowerShell-afc2142b