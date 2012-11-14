ITG.Yandex.DnsServer
====================

Обёртки для API Яндекс DNS для домена (pdd.yandex.ru) и командлеты на их основе.
Модуль предназначен для обеспечения той же функциональности, что и модуль DNSServer из комплекта
Windows Server 2012, но на базе DNS серверов Яндекса (естественно, с ограничениями),
интерфейс максимально приближен к интерфейсу командлет модуля DNSServer.

Версия модуля: **1.3.0**

Функции модуля
--------------
			
### DnsServerResourceRecord
			
#### Remove-DnsServerResourceRecord

Метод (обёртка над Яндекс.API delete_record) предназначен для 
удаления записи из зоны "припаркованного" на Яндексе домене.
	
	Remove-DnsServerResourceRecord [-ZoneName] <String> [-Name] <String[]> [[-RRType] <String>] [[-RecordData] <String[]>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>
			
### DnsServerResourceRecordA
			
#### Add-DnsServerResourceRecordA

Метод (обёртка над Яндекс.API add_a_record) предназначен для 
создания новой записи типа A на "припаркованном" на Яндексе домене.
	
	Add-DnsServerResourceRecordA [-ZoneName] <String> [-Name] <String> [-IPv4Address] <IPAddress[]> [[-TimeToLive] <Object>] [-WhatIf] [-Confirm] <CommonParameters>
			
### DnsServerResourceRecordAAAA
			
#### Add-DnsServerResourceRecordAAAA

Метод (обёртка над Яндекс.API add_aaaa_record) предназначен для 
создания новой записи типа AAAA на "припаркованном" на Яндексе домене.
	
	Add-DnsServerResourceRecordAAAA [-ZoneName] <String> [-Name] <String> [-IPv6Address] <IPAddress[]> [[-TimeToLive] <Object>] [-WhatIf] [-Confirm] <CommonParameters>
			
### DnsServerResourceRecordCName
			
#### Add-DnsServerResourceRecordCName

Метод (обёртка над Яндекс.API add_cname_record) предназначен для 
создания новой записи типа CNAME на "припаркованном" на Яндексе домене.
	
	Add-DnsServerResourceRecordCName [-ZoneName] <String> [-HostAliasName] <String> [-Name] <String> [[-TimeToLive] <Object>] [-WhatIf] [-Confirm] <CommonParameters>

Подробное описание функций модуля
---------------------------------
			
#### Remove-DnsServerResourceRecord

Метод (обёртка над Яндекс.API delete_record) предназначен для 
удаления записи из зоны "припаркованного" на Яндексе домене. 
Интерфейс командлета максимально приближен к аналогичному командлету 
модуля DnsServer Windows Server 2012. 
Синтаксис запроса: 
	https://pddimp.yandex.ru/nsapi/delete_record.xml ?
		token =<токен пользователя> 
		& domain =<имя домена>
		& record_id =<id записи>

##### Синтаксис
	
	Remove-DnsServerResourceRecord [-ZoneName] <String> [-Name] <String[]> [[-RRType] <String>] [[-RecordData] <String[]>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

##### Компонент

API Яндекс.DNS для доменов

##### Параметры	

- `ZoneName <String>`
        имя домена, зарегистрированного на сервисах Яндекса
        
        Требуется?                    true
        Позиция?                    1
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `Name <String[]>`
        имя записи
        
        Требуется?                    true
        Позиция?                    2
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByValue, ByPropertyName)
        Принимать подстановочные знаки?
        
- `RRType <String>`
        тип записи
        
        Требуется?                    false
        Позиция?                    3
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `RecordData <String[]>`
        содержимое удаляемой записи для точного определения удаляемой записи
        
        Требуется?                    false
        Позиция?                    4
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `PassThru [<SwitchParameter>]`
        передавать ли наименование записи дальше по конвейеру
        
        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию                
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
        
- `WhatIf [<SwitchParameter>]`
        
        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию                
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
        
- `Confirm [<SwitchParameter>]`
        
        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию                
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
        
- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        "get-help about_commonparameters".





##### Примеры использования	

1. Пример 1.

		'www2','www3' | Remove-YandexDnsServerResourceRecord -ZoneName 'csm.nov.ru' -RecordData '172.31.0.9','172.31.0.8' -RRType 'A';

##### Связанные ссылки

- [API Яндекс.DNS - delete_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_delete_record.xml)
- [MS PowerShell DnsServer - Remove-DnsServerResourceRecord](http://msdn.microsoft.com/en-us/library/windows/desktop/hh833144.aspx)
			
#### Add-DnsServerResourceRecordA

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

##### Синтаксис
	
	Add-DnsServerResourceRecordA [-ZoneName] <String> [-Name] <String> [-IPv4Address] <IPAddress[]> [[-TimeToLive] <Object>] [-WhatIf] [-Confirm] <CommonParameters>

##### Компонент

API Яндекс.DNS для доменов

##### Параметры	

- `ZoneName <String>`
        имя домена, зарегистрированного на сервисах Яндекса
        
        Требуется?                    true
        Позиция?                    1
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `Name <String>`
        имя записи
        
        Требуется?                    true
        Позиция?                    2
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `IPv4Address <IPAddress[]>`
        IP адреса для создаваемой записи
        
        Требуется?                    true
        Позиция?                    3
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `TimeToLive <Object>`
        TTL записи
        
        Требуется?                    false
        Позиция?                    4
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `WhatIf [<SwitchParameter>]`
        
        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию                
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
        
- `Confirm [<SwitchParameter>]`
        
        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию                
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
        
- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        "get-help about_commonparameters".





##### Примеры использования	

1. Пример 1.

		Add-DnsServerResourceRecordA -ZoneName 'csm.nov.ru' -Name 'www2' -IPv4Address '172.31.0.8', '172.31.0.7' -TimeToLive 55 ;

##### Связанные ссылки

- [API Яндекс.DNS - add_a_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_a_record.xml)
- [MS PowerShell DnsServer - Add-DnsServerResourceRecordA](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832244.aspx)
			
#### Add-DnsServerResourceRecordAAAA

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

##### Синтаксис
	
	Add-DnsServerResourceRecordAAAA [-ZoneName] <String> [-Name] <String> [-IPv6Address] <IPAddress[]> [[-TimeToLive] <Object>] [-WhatIf] [-Confirm] <CommonParameters>

##### Компонент

API Яндекс.DNS для доменов

##### Параметры	

- `ZoneName <String>`
        имя домена, зарегистрированного на сервисах Яндекса
        
        Требуется?                    true
        Позиция?                    1
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `Name <String>`
        имя записи
        
        Требуется?                    true
        Позиция?                    2
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `IPv6Address <IPAddress[]>`
        IP адреса для создаваемой записи
        
        Требуется?                    true
        Позиция?                    3
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `TimeToLive <Object>`
        TTL записи
        
        Требуется?                    false
        Позиция?                    4
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `WhatIf [<SwitchParameter>]`
        
        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию                
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
        
- `Confirm [<SwitchParameter>]`
        
        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию                
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
        
- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        "get-help about_commonparameters".





##### Примеры использования	

1. Пример 1.

		Add-DnsServerResourceRecordAAAA -ZoneName 'csm.nov.ru' -Name 'www2' -IPv6Address '::1';

##### Связанные ссылки

- [API Яндекс.DNS - add_aaaa_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_aaaa_record.xml)
- [MS PowerShell DnsServer - Add-DnsServerResourceRecordAAAA](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832245.aspx)
			
#### Add-DnsServerResourceRecordCName

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

##### Синтаксис
	
	Add-DnsServerResourceRecordCName [-ZoneName] <String> [-HostAliasName] <String> [-Name] <String> [[-TimeToLive] <Object>] [-WhatIf] [-Confirm] <CommonParameters>

##### Компонент

API Яндекс.DNS для доменов

##### Параметры	

- `ZoneName <String>`
        имя домена, зарегистрированного на сервисах Яндекса
        
        Требуется?                    true
        Позиция?                    1
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `HostAliasName <String>`
        имя записи
        
        Требуется?                    true
        Позиция?                    2
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `Name <String>`
        имя записи
        
        Требуется?                    true
        Позиция?                    3
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `TimeToLive <Object>`
        TTL записи
        
        Требуется?                    false
        Позиция?                    4
        Значение по умолчанию                
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
        
- `WhatIf [<SwitchParameter>]`
        
        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию                
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
        
- `Confirm [<SwitchParameter>]`
        
        Требуется?                    false
        Позиция?                    named
        Значение по умолчанию                
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
        
- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        "get-help about_commonparameters".





##### Примеры использования	

1. Создаём CName www2 как псевдоним к www.csm.nov.ru.

		Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -HostAliasName 'www2' -Name 'www';

##### Связанные ссылки

- [API Яндекс.DNS - add_cname_record](http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_cname_record.xml)
- [MS PowerShell DnsServer - Add-DnsServerResourceRecordCName](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832246.aspx)
