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
	-Force `
;

