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
		-Path ( Split-Path -Path ( $myinvocation.mycommand.path ) -Parent ) `
		-ChildPath 'ITG.Yandex.DnsServer' `
	) `
    -Prefix Yandex `
	-Force `
;

Add-YandexDnsServerResourceRecordA `
    -ZoneName 'csm.nov.ru' `
    -Name 'www2' `
    -IPv4Address '172.31.0.8', '172.31.0.7' `
;
