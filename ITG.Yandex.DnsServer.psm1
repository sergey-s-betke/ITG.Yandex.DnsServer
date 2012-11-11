'ITG.Yandex' `
, 'ITG.RegExps' `
, 'ITG.Utils' `
| Import-Module;

function Add-DnsServerResourceRecordA {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Метод (обёртка над Яндекс.API add_a_record) предназначен для 
			создания новой записи типа A на "припаркованном" на Яндексе домене.
		.Description
			Метод (обёртка над Яндекс.API add_a_record) предназначен для 
			создания новой записи типа A на "припаркованном" на Яндексе домене.
            Интерфейс командлета максимально приближен к аналогичному командлету
            модуля DnsServer Windows Server 2012.
			Синтаксис запроса
				https://pddimp.yandex.ru/nsapi/add_a_record.xml ? token =<токен>
                    & domain =<имя домена>
                    & [subdomain =<имя субдомена>]
                    & [ttl =<время жизни записи>]
                    & content =<содержимое записи>
		.Link
			http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_a_record.xml
            http://msdn.microsoft.com/en-us/library/windows/desktop/hh832244(v=vs.85).aspx
		.Example
			Add-DnsServerResourceRecordA `
                -ZoneName 'csm.nov.ru' `
                -Name 'www2' `
                -IPv4Address '172.31.0.8', '172.31.0.7' `
                -TimeToLive 55 `
            ;
	#>

	[CmdletBinding(
		SupportsShouldProcess=$true
		, ConfirmImpact="Medium"
	)]
	
	param (
		# имя домена, зарегистрированного на сервисах Яндекса
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		[ValidateScript( { $_ -match "^$($reDomain)$" } )]
		[Alias("domain_name")]
		[Alias("DomainName")]
		[Alias("Domain")]
		$ZoneName
	,
		# имя записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
        [ValidateNotNullOrEmpty()]
		[Alias("SubDomain")]
		$Name
	,
		# IP адреса для создаваемой записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string[]]
        [ValidateNotNullOrEmpty()]
		[Alias("Content")]
		$IPv4Address
	,
		# TTL записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
#		[System.TimeSpan]
		[Alias("TTL")]
		$TimeToLive
#	,
#		# передавать ли описатель созданной записи в конвейер
#		[switch]
#		$PassThru
	)

	process {
		Write-Verbose "Создаём A запись $Name в зоне $ZoneName.";
		$APIParams = @{
			subdomain = $Name;
            content = '';
		};
        if ( $TimeToLive -ne $null ) {
            if ( $TimeToLive -isnot [System.TimeSpan] ) {
                $TimeToLive = [System.TimeSpan]::FromSeconds( $TimeToLive );
            };
            $APIParams.Add( 'ttl', $TimeToLive.TotalSeconds );
        }
        $IPv4Address `
        | % {
            $APIParams.content = $_;
    		Invoke-API `
    			-method 'nsapi/add_a_record' `
    			-DomainName $ZoneName `
    			-Params ( $APIParams.Clone() ) `
    			-IsSuccessPredicate { $_.page.domains.error -eq 'ok' } `
    			-IsFailurePredicate { $_.page.domains.error -ne 'ok' } `
    			-FailureMsgFilter { $_.page.domains.error } `
    		;
        };
#		if ( $PassThru ) { $input };
	}
}

Export-ModuleMember `
    Add-DnsServerResourceRecordA `
;