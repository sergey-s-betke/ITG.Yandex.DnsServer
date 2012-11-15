'ITG.Yandex' `
, 'ITG.RegExps' `
, 'ITG.Utils' `
| Import-Module;

function Get-DnsServerResourceRecord {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Метод (обёртка над Яндекс.API get_domain_records) предназначен для 
			получения записей из зоны "припаркованного" на Яндексе домене.
		.Description
			Метод (обёртка над Яндекс.API get_domain_records) предназначен для 
			получения записей из зоны "припаркованного" на Яндексе домене. 
			Интерфейс командлета максимально приближен к аналогичному командлету 
			модуля DnsServer Windows Server 2012. 
		.Link
			[API Яндекс.DNS - get_domain_records](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_get_domain_records.xml)
		.Link
			[MS PowerShell DnsServer - Get-DnsServerResourceRecord](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832924.aspx)
		.Example
			Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru';
	#>

	[CmdletBinding(
	)]
	
	param (
		# имя домена, зарегистрированного на сервисах Яндекса
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		[ValidateScript( { $_ -match "^$($reDomain)$" } )]
		[Alias('domain_name')]
		[Alias('DomainName')]
		[Alias('Domain')]
		$ZoneName
	,
		# имя записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[String[]]
		[ValidateNotNullOrEmpty()]
		[Alias('SubDomain')]
		[Alias('HostName')]
		$Name
	,
		# тип записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[String[]]
		[ValidateSet('MX', 'A', 'AAAA', 'CNAME', 'SRV', 'TXT', 'NS')]
		[Alias('RecordType')]
		$RRType
	,
		# содержимое удаляемой записи для точного определения удаляемой записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[string[]]
		$RecordData
	)

	process {
		Invoke-API `
			-method 'nsapi/get_domain_records' `
			-DomainName $ZoneName `
			-IsSuccessPredicate { $_.page.domains.error -eq 'ok' } `
			-IsFailurePredicate { $_.page.domains.error -ne 'ok' } `
			-FailureMsgFilter { $_.page.domains.error } `
			-ResultFilter { $_.page.domains.domain.response.record } `
		| Select-Object -Property `
			@{ Name='HostName'; Expression={ [String]$_.subdomain } } `
			, @{ Name='RecordType'; Expression={ [String]$_.type } } `
			, @{ Name='RecordClass'; Expression={ 'IN' } } `
			, @{ Name='RecordData'; Expression={ [String]$_.'#text' } } `
			, @{ Name='TimeToLive'; Expression={ [System.TimeSpan]::FromSeconds( $_.ttl ) } } `
			, @{ Name='Timestamp'; Expression={ $null } } `
			, 'priority' `
			, 'id' `
		| ? { ( -not $Name.Count ) -or ( $Name -contains $_.HostName ) } `
		| ? { ( -not $RRType.Count ) -or ( $RRType -contains $_.RecordType ) } `
		| ? { ( -not $RecordData.Count ) -or ( $RecordData -contains $_.RecordData ) } `
		;
	}
}

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
			[API Яндекс.DNS - add_a_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_a_record.xml)
		.Link
			[MS PowerShell DnsServer - Add-DnsServerResourceRecordA](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832244.aspx)
		.Example
			Add-DnsServerResourceRecordA -ZoneName 'csm.nov.ru' -Name 'www2' -IPv4Address '172.31.0.8', '172.31.0.7' -TimeToLive 55 ;
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
		[Alias('HostName')]
		$Name
	,
		# IP адреса для создаваемой записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[System.Net.IPAddress[]]
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

function Add-DnsServerResourceRecordAAAA {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Метод (обёртка над Яндекс.API add_aaaa_record) предназначен для 
			создания новой записи типа AAAA на "припаркованном" на Яндексе домене.
		.Description
			Метод (обёртка над Яндекс.API add_aaaa_record) предназначен для 
			создания новой записи типа AAAA на "припаркованном" на Яндексе домене. 
			Интерфейс командлета максимально приближен к аналогичному командлету 
			модуля DnsServer Windows Server 2012. 
			Синтаксис запроса: 
				https://pddimp.yandex.ru/nsapi/add_aaaa_record.xml ? token =<токен>
					& domain =<имя домена>
					& [subdomain =<имя субдомена>]
					& [ttl =<время жизни записи>]
					& content =<содержимое записи>
		.Link
			[API Яндекс.DNS - add_aaaa_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_aaaa_record.xml)
		.Link
			[MS PowerShell DnsServer - Add-DnsServerResourceRecordAAAA](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832245.aspx)
		.Example
			Add-DnsServerResourceRecordAAAA -ZoneName 'csm.nov.ru' -Name 'www2' -IPv6Address '::1';
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
		[Alias('HostName')]
		$Name
	,
		# IP адреса для создаваемой записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[System.Net.IPAddress[]]
		[ValidateNotNullOrEmpty()]
		[Alias("Content")]
		$IPv6Address
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
		Write-Verbose "Создаём AAAA запись $Name в зоне $ZoneName.";
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
		$IPv6Address `
		| % {
			$APIParams.content = $_;
			Invoke-API `
				-method 'nsapi/add_aaaa_record' `
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

function Add-DnsServerResourceRecordCName {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Метод (обёртка над Яндекс.API add_cname_record) предназначен для 
			создания новой записи типа CNAME на "припаркованном" на Яндексе домене.
		.Description
			Метод (обёртка над Яндекс.API add_cname_record) предназначен для 
			создания новой записи типа A на "припаркованном" на Яндексе домене. 
			Интерфейс командлета максимально приближен к аналогичному командлету 
			модуля DnsServer Windows Server 2012. 
			Есть некоторая особенность в API Яндекса - он позволяет создавать CName только 
			для FQDN. Другими словами, создать "короткий" CName со ссылкой на запись того же 
			домена нельзя, только через FQDN. Данная функция проверяет значение параметра Name 
			и в том случае, если в конце не '.' (то есть - не FQDN), к значению предварительно 
			дописывает ZoneName + '.'. Введён данный функционал для обеспечения совместимости с 
			командлетами DnsServer. 
			Синтаксис запроса: 
				https://pddimp.yandex.ru/nsapi/add_cname_record.xml ?
					token =<токен>
					& domain =<имя домена>
					& [subdomain =<имя субдомена>]
					& [ttl =<время жизни записи>]
					& content =<содержимое записи>
		.Link
			[API Яндекс.DNS - add_cname_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_cname_record.xml)
		.Link
			[MS PowerShell DnsServer - Add-DnsServerResourceRecordCName](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832246.aspx)
		.Example
			Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'www2' -HostAliasName 'www';
			Создаём CName www2 как псевдоним к www.csm.nov.ru.
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
		[Alias("Content")]
		[Alias('HostName')]
		$Name
	,
		# FQDN записей, на которые будет ссылаться CName
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		[ValidateNotNullOrEmpty()]
		[Alias("SubDomain")]
		$HostAliasName
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
		if ( -not $HostAliasName.EndsWith( '.' ) ) { $HostAliasName = "$HostAliasName.$ZoneName."; };
		Write-Verbose "Создаём CNAME запись $Name в зоне $ZoneName ($HostAliasName).";
		$APIParams = @{
			subdomain = $Name;
			content = $HostAliasName;
		};
		if ( $TimeToLive -ne $null ) {
			if ( $TimeToLive -isnot [System.TimeSpan] ) {
				$TimeToLive = [System.TimeSpan]::FromSeconds( $TimeToLive );
			};
			$APIParams.Add( 'ttl', $TimeToLive.TotalSeconds );
		}
		Invoke-API `
			-method 'nsapi/add_cname_record' `
			-DomainName $ZoneName `
			-Params $APIParams `
			-IsSuccessPredicate { $_.page.domains.error -eq 'ok' } `
			-IsFailurePredicate { $_.page.domains.error -ne 'ok' } `
			-FailureMsgFilter { $_.page.domains.error } `
		;
#		if ( $PassThru ) { $input };
	}
}

function Remove-DnsServerResourceRecord {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Метод (обёртка над Яндекс.API delete_record) предназначен для 
			удаления записи из зоны "припаркованного" на Яндексе домене.
		.Description
			Метод (обёртка над Яндекс.API delete_record) предназначен для 
			удаления записи из зоны "припаркованного" на Яндексе домене. 
			Интерфейс командлета максимально приближен к аналогичному командлету 
			модуля DnsServer Windows Server 2012. 
			Синтаксис запроса: 
				https://pddimp.yandex.ru/nsapi/delete_record.xml ?
					token =<токен пользователя> 
					& domain =<имя домена>
					& record_id =<id записи>
		.Link
			[API Яндекс.DNS - delete_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_delete_record.xml)
		.Link
			[MS PowerShell DnsServer - Remove-DnsServerResourceRecord](http://msdn.microsoft.com/en-us/library/windows/desktop/hh833144.aspx)
		.Example
			Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -Name 'www2','www3' | Remove-DnsServerResourceRecord -ZoneName 'csm.nov.ru';
	#>

	[CmdletBinding(
		SupportsShouldProcess=$true
		, ConfirmImpact='Medium'
	)]
	
	param (
		# имя домена, зарегистрированного на сервисах Яндекса
		[Parameter(
			Mandatory=$true
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
		[Alias("HostName")]
		$Name
	,
		# тип записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		[ValidateSet('MX', 'A', 'AAAA', 'CNAME', 'SRV', 'TXT', 'NS')]
		[Alias("RecordType")]
		$RRType
	,
		# содержимое удаляемой записи для точного определения удаляемой записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[string[]]
		$RecordData
	,
		# id записи. Параметр специфичен только для реализации Яндекс.API. 
		# Получен должен быть через Get-DnsServerResourceRecord.
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		$id
	,
		# передавать ли наименование записи дальше по конвейеру
		[switch]
		$PassThru
	,
		# На данный момент параметр не используется. В дальнейшем - удаление созданных Яндексом записей
		# при подключении домена возможно будет только с данным флагом
		[switch]
		$Force
	)

	process {
		if ( -not $id ) {
			Get-DnsServerResourceRecord `
				-ZoneName $ZoneName `
				-Name $Name `
				-RRType $RRType `
			| Remove-DnsServerResourceRecord `
				-ZoneName 'csm.nov.ru' `
				-RecordData $RecordData `
			;
		} else {
			if (
				( $Name -eq $_.HostName ) `
				-and ( ( -not $RRType ) -or ( $RRType -eq $_.RecordType ) ) `
				-and ( ( -not $RecordData ) -or ( $RecordData -contains $_.RecordData ) ) `
			) { `
				if ( $PSCmdlet.ShouldProcess( "$Name (в зоне $ZoneName)", 'Удалить' ) ) {
					Write-Verbose "Удаляем запись $Name в зоне $ZoneName.";
					Invoke-API `
						-method 'nsapi/delete_record' `
						-DomainName $ZoneName `
						-Params @{
							record_id = $id;
						} `
						-IsSuccessPredicate { $_.page.domains.error -eq 'ok' } `
						-IsFailurePredicate { $_.page.domains.error -ne 'ok' } `
						-FailureMsgFilter { $_.page.domains.error } `
					;
				};
			};
		};
		if ( $PassThru ) { $input };
	}
}

Export-ModuleMember `
	Get-DnsServerResourceRecord `
	, Add-DnsServerResourceRecordA `
	, Add-DnsServerResourceRecordAAAA `
	, Add-DnsServerResourceRecordCName `
	, Remove-DnsServerResourceRecord `
;