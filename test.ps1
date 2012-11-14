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
#| Get-Readme -OutDefaultFile `
;

#Add-DnsServerResourceRecordA `
#	-ZoneName 'csm.nov.ru' `
#	-Name 'www2' `
#	-IPv4Address '172.31.0.9' `
#;

#Add-DnsServerResourceRecordAAAA `
#	-ZoneName 'csm.nov.ru' `
#	-Name 'www2' `
#	-IPv6Address '::1' `
#;

#'www2' `
#| Remove-DnsServerResourceRecord `
#	-ZoneName 'csm.nov.ru' `
#;

#Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -HostAliasName 'www3' -Name 'mail.csm.nov.ru.';
#Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -HostAliasName 'www4' -Name 'mail';

Remove-DnsServerResourceRecord `
	-ZoneName 'csm.nov.ru' `
    -Name 'www2', 'www3', 'www4' `
;
