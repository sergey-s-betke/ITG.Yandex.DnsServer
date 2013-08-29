
filter ConvertFrom-YandexDnsServerResourceRecord {
	param (
		# имя записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[String]
		[ValidateNotNullOrEmpty()]
		[Alias('subdomain')]
		$HostName
	,
		# тип записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[String]
		[ValidateSet('MX', 'A', 'AAAA', 'CNAME', 'SRV', 'TXT', 'NS', 'SOA')]
		[Alias('type')]
		$RecordType
	,
		# класс записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[String]
		$RecordClass = 'IN'
	,
		# содержание записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[String]
		[Alias('#text')]
		$RecordData
	,
		# содержание записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateScript( {
			if ( $_ -isnot [System.TimeSpan] ) {
				$_ = [System.TimeSpan]::FromSeconds( $_ );
			};
			$true;
		} )]
		[Alias('ttl')]
		$TimeToLive
	,
		# время создания записи (в нашем случае мы его не узнаем)
		[Parameter(
			Mandatory=$false
		)]
		[System.DateTime]
		$Timestamp
	,
		# id записи (только для Яндекса)
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[String]
		[ValidateNotNullOrEmpty()]
		$id
	,
		# приоритет записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateScript( {
			if ( $_ -ne '' ) {
				$_ = [uint16]$_;
			};
			$true;
		} )]
		$Priority
	,
		# вес записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[uint16]
		$Weight
	,
		# порт (для SVR записей)
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[uint16]
		$Port
	,
		# время между повторными попытками slave DNS-серверов получить записи зоны (в случае, если master сервер ничего не вернул)
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateScript( {
			if ( $_ -isnot [System.TimeSpan] ) {
				$_ = [System.TimeSpan]::FromSeconds( $_ );
			};
			$true;
		} )]
		[Alias('retry')]
		$RetryDelay
	,
		# время, по истечении которого slave DNS-сервера считают записи зоны несуществующими (в случае если master сервер продолжает ничего не возвращать)
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateScript( {
			if ( $_ -isnot [System.TimeSpan] ) {
				$_ = [System.TimeSpan]::FromSeconds( $_ );
			};
			$true;
		} )]
		[Alias('expire')]
		$ExpireLimit
	,
		# TTL для записей зоны, если для них явно не указано другое время жизни в кеше
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateScript( {
			if ( $_ -isnot [System.TimeSpan] ) {
				$_ = [System.TimeSpan]::FromSeconds( $_ );
			};
			$true;
		} )]
		[Alias('minttl')]
		$MinimumTimeToLive
	,
		# e-mail адрес администратора домена, точнее - ссылка на RP запись, если таковая присутствует. Отображается в SOA-записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[String]
		[Alias('adminmail')]
		$ResponsiblePerson
	,
		# TTL для SOA записи зоны
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[ValidateScript( {
			if ( $_ -isnot [System.TimeSpan] ) {
				$_ = [System.TimeSpan]::FromSeconds( $_ );
			};
			$true;
		} )]
		[Alias('refresh')]
		$DnsServerResourceRecordSoa
	)
	
	if ( -not $Priority ) {
		$null = $PSBoundParameters.Remove( 'Priority' );
	};
	New-Object PSObject -Property $PSBoundParameters;
}

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
			Все функции данного модуля используют ITG.Yandex, в частности - Get-Token.
		.Link
			[get_domain_records]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_get_domain_records.xml
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
		)]
		[string]
		[ValidateScript( { $_ -match "^$($reDomain)$" } )]
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
		[ValidateSet('MX', 'A', 'AAAA', 'CNAME', 'SRV', 'TXT', 'NS', 'SOA')]
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

	begin {
		$AllRecords = (
			Invoke-API `
				-method 'nsapi/get_domain_records' `
				-DomainName $ZoneName `
				-IsSuccessPredicate { $_.page.domains.error -eq 'ok' } `
				-IsFailurePredicate { $_.page.domains.error -ne 'ok' } `
				-FailureMsgFilter { $_.page.domains.error } `
				-ResultFilter { $_.page.domains.domain.response.record } `
				-Debug:$DebugPreference `
				-Verbose:$VerbosePreference `
			| ConvertFrom-YandexDnsServerResourceRecord `
			| ? { $_.id -ne 0 } `
		);
	}
	process {
		$AllRecords `
		| ? {
			( ( -not $PSBoundParameters.ContainsKey('Name') ) -or ( $Name -contains $_.HostName ) ) `
			-and ( ( -not $PSBoundParameters.ContainsKey('RRType') ) -or ( $RRType -contains $_.RecordType ) ) `
			-and ( ( -not $PSBoundParameters.ContainsKey('RecordData') ) -or ( $RecordData -contains $_.RecordData ) ) `
		};
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
function Invoke-APIDnsServerResourceRecord {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Вспомогательная функция для вызова API Add-DnsServerResourceRecordXXXX, не экспортируется.
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
		[String]
		[Alias('ZoneName')]
		$domain
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
	
		# имя записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[String]
		[Alias('Name')]
		$subdomain = '@'
	,
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
			, ParameterSetName='content'
		)]
		[String[]]
		[Alias('IPv4Address')]
		[Alias('IPv6Address')]
		[Alias('HostAliasName')]
		[Alias('MailExchange')]
		[Alias('NameServer')]
		[Alias('DescriptiveText')]
		$content
	,
		# TTL записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
#		[System.TimeSpan]
		[ValidateScript( {
			if ( $_ -is [System.TimeSpan] ) {
				$_ = $_.TotalSeconds;
			};
			$true;
		} )]
		[Alias('TimeToLive')]
		$ttl
	,
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
			, ParameterSetName='target'
		)]
		[String]
		[Alias('Server')]
		$target
	,
		# Приоритет записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[String]
		[ValidateNotNullOrEmpty()]
		[Alias('Preference')]
		$priority
	,
		# Порт сервера
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		[ValidateNotNullOrEmpty()]
		$port
	,
		# Вес записи
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		$weight
	,
		# параметр будет игнорирован. Введён исключительно для облегчения использования данной вспомогательной функции
		[switch]
		$PassThru
	,
		# параметр Content содержит FQDN, и в том случае, если заканчивается не на `.`, необходимо "дописать" domain.
		[switch]
		$ContentIsFQDN
	)

	process {
		$null = $PSBoundParameters.Remove( 'RRType' );
		$null = $PSBoundParameters.Remove( 'ContentIsFQDN' );
		Write-Verbose "Создаём $RRType запись $subdomain в зоне $domain ($content).";
		$ContentParam = $PsCmdlet.ParameterSetName;
		$PSBoundParameters.$ContentParam `
		| % {
			$PSBoundParameters.$ContentParam = & {
				if ( $ContentIsFQDN -and -not $_.EndsWith( '.' ) ) {
					"$_.$domain.";
				} else {
					$_;
				}
			};
			if ( $PSCmdlet.ShouldProcess( "$RRType запись $subdomain (в зоне $domain, $_)", 'Создать' ) ) {
				$Params = @{};
				foreach ( $Param in 'domain', 'subdomain', 'content', 'ttl', 'target', 'priority', 'port', 'weight' ) {
					if ( $PSBoundParameters.ContainsKey( $Param ) ) {
						$Params.Add( $Param, $PSBoundParameters.$Param );
					};
				};
				Invoke-API `
					-method "nsapi/add_$( $RRType.ToLower() )_record" `
					-DomainName $domain `
					-Params $Params `
					-IsSuccessPredicate { $_.page.domains.error -eq 'ok' } `
					-IsFailurePredicate { $_.page.domains.error -ne 'ok' } `
					-FailureMsgFilter { $_.page.domains.error } `
					-Debug:$DebugPreference `
					-Verbose:$VerbosePreference `
				;
			};
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
		.Link
			[add_a_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_a_record.xml
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
		Invoke-APIDnsServerResourceRecord @PSBoundParameters -RRType 'A';
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
		.Link
			[add_aaaa_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_aaaa_record.xml
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
		Invoke-APIDnsServerResourceRecord @PSBoundParameters -RRType 'AAAA';
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
			и в том случае, если в конце не `.` (то есть - не FQDN), к значению предварительно 
			дописывает ZoneName + `.`. Введён данный функционал для обеспечения совместимости с 
			командлетами DnsServer. 
		.Link
			[add_cname_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_cname_record.xml
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
		Invoke-APIDnsServerResourceRecord @PSBoundParameters -RRType 'CNAME' -ContentIsFQDN;
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
		.Link
			[add_mx_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_mx_record.xml
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
		Invoke-APIDnsServerResourceRecord @PSBoundParameters -RRType 'MX' -ContentIsFQDN;
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
		.Link
			[add_ns_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_ns_record.xml
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
		Invoke-APIDnsServerResourceRecord @PSBoundParameters -RRType 'NS' -ContentIsFQDN;
		if ( $PassThru ) { $input };
	}
}

function Add-DnsServerResourceRecordSRV {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Метод (обёртка над Яндекс.API add_srv_record) предназначен для 
			создания новой SRV записи на "припаркованном" на Яндексе домене.
		.Description
			Метод (обёртка над Яндекс.API add_srv_record) предназначен для 
			создания новой SRV записи на "припаркованном" на Яндексе домене. 
			Интерфейс командлета максимально приближен к аналогичному командлету 
			модуля DnsServer Windows Server 2012. 
			
			To-Do: обнаружил ошибку в API: при создании SRV записи через API Яндекса 
			возникает ещё одна "фантомная" запись с тем же содержанием, но в состоянии 
			"добавляется". И так и висит. Удалить её нет возможности...
		.Link
			[add_srv_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_srv_record.xml
		.Link
			[MS PowerShell DnsServer - Add-DnsServerResourceRecordSRV](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832799.aspx)
		.Example
			Add-DnsServerResourceRecordSRV -ZoneName 'csm.nov.ru' -Name '_xmpp-server._tcp' -Server 'xmpp' -Port 5269 -Weight 0 -Priority 40;
			Создаём SRV запись в домене csm.nov.ru.
		.Example
			Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -RRType 'SRV' | ? { $_.HostName -like '*xmpp*' } | Add-DnsServerResourceRecord -ZoneName 'nice-tour.nov.ru';
			Копируем SRV записи, описывающие XMPP (Jabber) сервис, с одного домена в другой.
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
		# FQDN сервера, на котором расположен сервис, описываемый SRV записью
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string]
		[ValidateNotNullOrEmpty()]
		[Alias('target')]
		[Alias('RecordData')]
		$Server
	,
		# Порт сервера
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[uint16]
		$Port
	,
		# Приоритет сервера
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[uint16]
		[Alias('Priority')]
		$Preference
	,
		# Вес сервера
		[Parameter(
			Mandatory=$false
			, ValueFromPipelineByPropertyName=$true
		)]
		[uint16]
		$Weight
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
		Invoke-APIDnsServerResourceRecord @PSBoundParameters -RRType 'SRV' -ContentIsFQDN;
		if ( $PassThru ) { $input };
	}
}

function Add-DnsServerResourceRecordTxt {
	<#
		.Component
			API Яндекс.DNS для доменов
		.Synopsis
			Метод (обёртка над Яндекс.API add_txt_record) предназначен для 
			создания новой записи типа TXT на "припаркованном" на Яндексе домене.
		.Description
			Метод (обёртка над Яндекс.API add_txt_record) предназначен для 
			создания новой записи типа TXT на "припаркованном" на Яндексе домене.
			Интерфейс командлета максимально приближен к аналогичному командлету 
			модуля DnsServer Windows Server 2012. 
		.Link
			[add_txt_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_txt_record.xml
		.Link
			[MS PowerShell DnsServer - Add-DnsServerResourceRecordTxt](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832800.aspx)
		.Example
			Add-DnsServerResourceRecordTxt -ZoneName 'csm.nov.ru' -Name 'hostmaster' -Text 'IT department of CSM of Velikiy Novgorod. Sergey S. Betke.';
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
		# Содержание TXT записи
		[Parameter(
			Mandatory=$true
			, ValueFromPipelineByPropertyName=$true
		)]
		[string[]]
		[ValidateNotNullOrEmpty()]
		[Alias('Content')]
		[Alias('RecordData')]
		[Alias('Text')]
		$DescriptiveText
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
		Invoke-APIDnsServerResourceRecord @PSBoundParameters -RRType 'TXT';
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
		.Link
			[delete_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_delete_record.xml
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
			$null = $PSBoundParameters.Remove( 'PassThru' );
			& {
				if ( $_ ) {
					$_ | Get-DnsServerResourceRecord -ZoneName $ZoneName ;
				} else {
					Get-DnsServerResourceRecord -ZoneName $ZoneName ;
				} 
			} `
			| ? { $_.RecordType -ne 'SOA' } `
			| Remove-DnsServerResourceRecord @PSBoundParameters `
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
						-Debug:$DebugPreference `
						-Verbose:$VerbosePreference `
					;
				};
			};
		};
		if ( $PassThru ) { $_ };
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
	, Add-DnsServerResourceRecordSRV `
	, Add-DnsServerResourceRecordTxt `
;