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
		| % {
			$res = Select-Object -InputObject $_ -Property `
				@{ Name='HostName'; Expression={ [String]$_.subdomain } } `
				, @{ Name='RecordType'; Expression={ [String]$_.type } } `
				, @{ Name='RecordClass'; Expression={ 'IN' } } `
				, @{ Name='RecordData'; Expression={ [String]$_.'#text' } } `
				, @{ Name='TimeToLive'; Expression={ [System.TimeSpan]::FromSeconds( $_.ttl ) } } `
				, @{ Name='Timestamp'; Expression={ $null } } `
				, @{ Name='id'; Expression={ [String]$_.id } } `
			;
			if ( $_.Priority ) { 
				Add-Member `
					-InputObject $res `
					-MemberType NoteProperty `
					-Name Priority `
					-Value ( [uint16]$_.Priority ) `
				;
			};
			if ( $_.Weight ) {
				Add-Member `
					-InputObject $res `
					-MemberType NoteProperty `
					-Name Weight `
					-Value ( [uint16]$_.Weight ) `
				;
			};
			if ( $_.Port ) {
				Add-Member `
					-InputObject $res `
					-MemberType NoteProperty `
					-Name Port `
					-Value ( [uint16]$_.Port ) `
				;
			};
			$res;
		} `
		| ? { ( -not $Name.Count ) -or ( $Name -contains $_.HostName ) } `
		| ? { ( -not $RRType.Count ) -or ( $RRType -contains $_.RecordType ) } `
		| ? { ( -not $RecordData.Count ) -or ( $RecordData -contains $_.RecordData ) } `
		;
	}
}

function Add-DnsServerResourceRecord {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Метод (обёртка над Яндекс.API add_a_record) предназначен для 
			создания новой записи на "припаркованном" на Яндексе домене 
			на основе данных о записи из конвейера.
		.Description
			Метод (обёртка над Яндекс.API add_a_record) предназначен для 
			создания новой записи на "припаркованном" на Яндексе домене 
			на основе данных о записи из конвейера. 
			Параметры в этом командлете не привязаны к конвейеру сознательно: привязка 
			будет осуществлена в вызываемом в зависимости от типа записи командлете. 
			Здесь же в параметрах следует видеть только явно заданные параметры. 
			Интерфейс командлета максимально приближен к аналогичному командлету 
			модуля DnsServer Windows Server 2012. 
		.Link
			[API Яндекс.DNS - add_a_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_a_record.xml)
		.Example
			Get-DnsServerResourceRecord -ZoneName 'csm.nov.local' -RRType 'A','CNAME','AAAA' | Add-YandexDnsServerResourceRecord -ZoneName 'csm.nov.ru';
			"Копирование" всех записей типа A, AAAA, CNAME из локальной зоны DNS в публичную зону DNS, размещённую на серверах Яндекса.
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
		[Alias('domain_name')]
		[Alias('DomainName')]
		[Alias('Domain')]
		$ZoneName
	,
		# имя записи
		[string]
		[ValidateNotNullOrEmpty()]
		[Alias('SubDomain')]
		[Alias('HostName')]
		$Name
	,
		# тип записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[String]
		[ValidateSet('MX', 'A', 'AAAA', 'CNAME', 'SRV', 'TXT', 'NS')]
		[Alias('RecordType')]
		$RRType
	,
		# содержание записи
		[string]
		[ValidateNotNullOrEmpty()]
		$RecordData
	,
		# TTL записи
#		[System.TimeSpan]
		[Alias('TTL')]
		$TimeToLive
	,
		# передавать ли описатель созданной записи в конвейер
		[switch]
		$PassThru
	)

	process {
		$null = $PSBoundParameters.Remove('RRType');
		if ( $_ ) {
			$_ | & "Add-DnsServerResourceRecord$RRType" @PSBoundParameters;
		} else {
			& "Add-DnsServerResourceRecord$RRType" @PSBoundParameters;
		};
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
		[string]
		[ValidateNotNullOrEmpty()]
		[Alias('SubDomain')]
		[Alias('HostName')]
		$Name = '@'
	,
		# IP адреса для создаваемой записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[System.Net.IPAddress[]]
		[ValidateNotNullOrEmpty()]
		[Alias('Content')]
		[Alias('RecordData')]
		$IPv4Address
	,
		# TTL записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
#		[System.TimeSpan]
		[Alias('TTL')]
		$TimeToLive
	,
		# передавать ли описатель созданной записи в конвейер
		[switch]
		$PassThru
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
			if ( $PSCmdlet.ShouldProcess( "$Name A $_ (в зоне $ZoneName)", 'Создать' ) ) {
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
		};
		if ( $PassThru ) { $input };
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
		[string]
		[ValidateNotNullOrEmpty()]
		[Alias('SubDomain')]
		[Alias('HostName')]
		$Name = '@'
	,
		# IP адреса для создаваемой записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[System.Net.IPAddress[]]
		[ValidateNotNullOrEmpty()]
		[Alias('Content')]
		[Alias('RecordData')]
		$IPv6Address
	,
		# TTL записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
#		[System.TimeSpan]
		[Alias('TTL')]
		$TimeToLive
	,
		# передавать ли описатель созданной записи в конвейер
		[switch]
		$PassThru
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
			if ( $PSCmdlet.ShouldProcess( "$Name AAAA $_ (в зоне $ZoneName)", 'Создать' ) ) {
				Invoke-API `
					-method 'nsapi/add_aaaa_record' `
					-DomainName $ZoneName `
					-Params ( $APIParams.Clone() ) `
					-IsSuccessPredicate { $_.page.domains.error -eq 'ok' } `
					-IsFailurePredicate { $_.page.domains.error -ne 'ok' } `
					-FailureMsgFilter { $_.page.domains.error } `
				;
			};
		};
		if ( $PassThru ) { $input };
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
		[Alias('domain_name')]
		[Alias('DomainName')]
		[Alias('Domain')]
		$ZoneName
	,
		# имя записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		[ValidateNotNullOrEmpty()]
		[Alias('SubDomain')]
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
		[Alias('Content')]
		[Alias('RecordData')]
		$HostAliasName
	,
		# TTL записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
#		[System.TimeSpan]
		[Alias('TTL')]
		$TimeToLive
	,
		# передавать ли описатель созданной записи в конвейер
		[switch]
		$PassThru
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
		if ( $PSCmdlet.ShouldProcess( "$Name CNAME $HostAliasName (в зоне $ZoneName)", 'Создать' ) ) {
			Invoke-API `
				-method 'nsapi/add_cname_record' `
				-DomainName $ZoneName `
				-Params $APIParams `
				-IsSuccessPredicate { $_.page.domains.error -eq 'ok' } `
				-IsFailurePredicate { $_.page.domains.error -ne 'ok' } `
				-FailureMsgFilter { $_.page.domains.error } `
			;
		};
		if ( $PassThru ) { $input };
	}
}

function Add-DnsServerResourceRecordMX {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Метод (обёртка над Яндекс.API add_mx_record) предназначен для 
			создания новой записи типа MX на "припаркованном" на Яндексе домене.
		.Description
			Метод (обёртка над Яндекс.API add_mx_record) предназначен для 
			создания новой записи типа MX на "припаркованном" на Яндексе домене.
			Интерфейс командлета максимально приближен к аналогичному командлету 
			модуля DnsServer Windows Server 2012. 
			В описании API на Яндексе закралась ошибка. API принимает и параметр priority. 
			Синтаксис запроса: 
				https://pddimp.yandex.ru/nsapi/add_mx_record.xml ? 
					token =<токен пользователя>
					 & domain =<имя домена>
					 & [subdomain =<имя субдомена>]
					 & [ttl =<время жизни записи>]
					 & [priority =<приоритет>]
					 & content =<содержимое записи>
		.Link
			[API Яндекс.DNS - add_mx_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_mx_record.xml)
		.Link
			[MS PowerShell DnsServer - Add-DnsServerResourceRecordMX](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832249.aspx)
		.Example
			Add-DnsServerResourceRecordMX -ZoneName 'csm.nov.ru' -MailExchange 'mx.yandex.ru.';
			Создаём MX запись в домене csm.nov.ru.
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
		[string]
		[ValidateNotNullOrEmpty()]
		[Alias('SubDomain')]
		[Alias('HostName')]
		$Name = '@'
	,
		# FQDN сервера, который будет принимать SMTP почту
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		[ValidateNotNullOrEmpty()]
		[Alias('Content')]
		[Alias('RecordData')]
		$MailExchange
	,
		# Приоритет сервера
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[uint16]
		[ValidateNotNullOrEmpty()]
		[Alias('Priority')]
		$Preference
	,
		# TTL записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
#		[System.TimeSpan]
		[Alias('TTL')]
		$TimeToLive
	,
		# передавать ли описатель созданной записи в конвейер
		[switch]
		$PassThru
	)

	process {
		if ( -not $MailExchange.EndsWith( '.' ) ) { $MailExchange = "$MailExchange.$ZoneName."; };
		if ( $Name -eq '@' ) {
			$MailDomain = $ZoneName;
		} else {
			$MailDomain = "$Name.$ZoneName";
		};
		Write-Verbose "Создаём MX запись для домена $MailDomain ($MailExchange).";
		$APIParams = @{
			subdomain = $Name;
			content = $MailExchange;
		};
		if ( $TimeToLive -ne $null ) {
			if ( $TimeToLive -isnot [System.TimeSpan] ) {
				$TimeToLive = [System.TimeSpan]::FromSeconds( $TimeToLive );
			};
			$APIParams.Add( 'ttl', $TimeToLive.TotalSeconds );
		}
		if ( $Preference -ne $null ) {
			$APIParams.Add( 'priority', $Preference );
		}
		if ( $PSCmdlet.ShouldProcess( "MX запись для домена $MailDomain ($MailExchange)", 'Создать' ) ) {
			Invoke-API `
				-method 'nsapi/add_mx_record' `
				-DomainName $ZoneName `
				-Params $APIParams `
				-IsSuccessPredicate { $_.page.domains.error -eq 'ok' } `
				-IsFailurePredicate { $_.page.domains.error -ne 'ok' } `
				-FailureMsgFilter { $_.page.domains.error } `
			;
		};
		if ( $PassThru ) { $input };
	}
}

function Add-DnsServerResourceRecordNS {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Метод (обёртка над Яндекс.API add_ns_record) предназначен для 
			создания новой записи типа NS на "припаркованном" на Яндексе домене.
		.Description
			Метод (обёртка над Яндекс.API add_ns_record) предназначен для 
			создания новой записи типа NS на "припаркованном" на Яндексе домене.
			Интерфейс командлета максимально приближен к аналогичному командлету 
			модуля DnsServer Windows Server 2012. 
			Синтаксис запроса: 
				https://pddimp.yandex.ru/nsapi/add_mx_record.xml ? 
					token =<токен пользователя>
					 & domain =<имя домена>
					 & [subdomain =<имя субдомена>]
					 & [ttl =<время жизни записи>]
					 & content =<содержимое записи>
		.Link
			[API Яндекс.DNS - add_ns_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_ns_record.xml)
		.Link
			[MS PowerShell DnsServer - Add-DnsServerResourceRecordNS](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832790.aspx)
		.Example
			Add-DnsServerResourceRecordNS -ZoneName 'csm.nov.ru' -Name 'support' -NameServer 'ns.csm.nov.ru.';
			Создаём поддомен support в домене csm.nov.ru и указываем, что зона для этого поддомена поддерживается сервером ns.csm.nov.ru.
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
		[Alias('domain_name')]
		[Alias('DomainName')]
		[Alias('Domain')]
		$ZoneName
	,
		# Поддомен. Если значение параметра не указано, будет создана дополнительная NS запись для основного домена (ZoneName).
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		[ValidateNotNullOrEmpty()]
		[Alias('SubDomain')]
		[Alias('HostName')]
		$Name = '@'
	,
		# FQDN адрес DNS сервера, на котором размещена зона для создаваемого поддомена. 
		# To-Do: Сейчас проверка значения данного параметра не выполняется, в дальнейшем
		# необходимо ввести проверку параметра
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string[]]
		[ValidateNotNullOrEmpty()]
		[Alias('Content')]
		[Alias('RecordData')]
		$NameServer
	,
		# TTL записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
#		[System.TimeSpan]
		[Alias('TTL')]
		$TimeToLive
	,
		# передавать ли описатель созданной записи в конвейер
		[switch]
		$PassThru
	)

	process {
		if ( $Name -eq '@' ) {
			$SubDomain = $ZoneName;
		} else {
			$SubDomain = "$Name.$ZoneName";
		};
		$NameServer `
		| % {
			$NS = $_;
			if ( -not $NS.EndsWith( '.' ) ) { $NS = "$NS.$ZoneName."; };
			Write-Verbose "Создаём NS запись для домена $SubDomain ($NS).";
			$APIParams = @{
				subdomain = $Name;
				content = $NS;
			};
			if ( $TimeToLive -ne $null ) {
				if ( $TimeToLive -isnot [System.TimeSpan] ) {
					$TimeToLive = [System.TimeSpan]::FromSeconds( $TimeToLive );
				};
				$APIParams.Add( 'ttl', $TimeToLive.TotalSeconds );
			}
			if ( $PSCmdlet.ShouldProcess( "NS запись для домена $SubDomain ($NS)", 'Создать' ) ) {
				Invoke-API `
					-method 'nsapi/add_ns_record' `
					-DomainName $ZoneName `
					-Params $APIParams `
					-IsSuccessPredicate { $_.page.domains.error -eq 'ok' } `
					-IsFailurePredicate { $_.page.domains.error -ne 'ok' } `
					-FailureMsgFilter { $_.page.domains.error } `
				;
			};
		};
		if ( $PassThru ) { $input };
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
		[Alias('domain_name')]
		[Alias('DomainName')]
		[Alias('Domain')]
		$ZoneName
	,
		# имя записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
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
		[string]
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
	, Add-DnsServerResourceRecord `
	, Remove-DnsServerResourceRecord `
	, Add-DnsServerResourceRecordA `
	, Add-DnsServerResourceRecordAAAA `
	, Add-DnsServerResourceRecordCName `
	, Add-DnsServerResourceRecordMX `
	, Add-DnsServerResourceRecordNS `
;