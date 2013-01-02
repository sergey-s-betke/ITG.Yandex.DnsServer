ITG.Yandex.DnsServer
====================

Обёртки для API Яндекс DNS для домена (pdd.yandex.ru) и командлеты на их основе.
Модуль предназначен для обеспечения той же функциональности, что и модуль DNSServer из комплекта
Windows Server 2012, но на базе DNS серверов Яндекса (естественно, с ограничениями),
интерфейс максимально приближен к интерфейсу командлет модуля DNSServer.

Версия модуля: **2.0.0**

Функции модуля
--------------

### DnsServerResourceRecord

#### Обзор [Add-DnsServerResourceRecord][]

Метод (обёртка над Яндекс.API [add_a_record][]) предназначен для
создания новой записи на "припаркованном" на Яндексе домене
на основе данных о записи из конвейера.

	Add-DnsServerResourceRecord [-ZoneName] <String> [[-Name] <String>] [-RRType] <String> [[-RecordData] <String>] [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

Подробнее - [Add-DnsServerResourceRecord][].

#### Обзор [Get-DnsServerResourceRecord][]

Метод (обёртка над Яндекс.API [get_domain_records][]) предназначен для
получения записей из зоны "припаркованного" на Яндексе домене.

	Get-DnsServerResourceRecord [-ZoneName] <String> [[-Name] <String[]>] [[-RRType] <String[]>] [[-RecordData] <String[]>] <CommonParameters>

Подробнее - [Get-DnsServerResourceRecord][].

#### Обзор [Remove-DnsServerResourceRecord][]

Метод (обёртка над Яндекс.API [delete_record][]) предназначен для
удаления записи из зоны "припаркованного" на Яндексе домене.

	Remove-DnsServerResourceRecord [-ZoneName] <String> [-Name] <String> [[-RRType] <String>] [[-RecordData] <String[]>] [[-id] <String>] [-PassThru] [-Force] [-WhatIf] [-Confirm] <CommonParameters>

Подробнее - [Remove-DnsServerResourceRecord][].

### DnsServerResourceRecordA

#### Обзор [Add-DnsServerResourceRecordA][]

Метод (обёртка над Яндекс.API [add_a_record][]) предназначен для
создания новой записи типа A на "припаркованном" на Яндексе домене.

	Add-DnsServerResourceRecordA [-ZoneName] <String> [[-Name] <String>] [-IPv4Address] <IPAddress[]> [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

Подробнее - [Add-DnsServerResourceRecordA][].

### DnsServerResourceRecordAAAA

#### Обзор [Add-DnsServerResourceRecordAAAA][]

Метод (обёртка над Яндекс.API [add_aaaa_record][]) предназначен для
создания новой записи типа AAAA на "припаркованном" на Яндексе домене.

	Add-DnsServerResourceRecordAAAA [-ZoneName] <String> [[-Name] <String>] [-IPv6Address] <IPAddress[]> [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

Подробнее - [Add-DnsServerResourceRecordAAAA][].

### DnsServerResourceRecordCName

#### Обзор [Add-DnsServerResourceRecordCName][]

Метод (обёртка над Яндекс.API [add_cname_record][]) предназначен для
создания новой записи типа CNAME на "припаркованном" на Яндексе домене.

	Add-DnsServerResourceRecordCName [-ZoneName] <String> [-Name] <String> [-HostAliasName] <String> [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

Подробнее - [Add-DnsServerResourceRecordCName][].

### DnsServerResourceRecordMX

#### Обзор [Add-DnsServerResourceRecordMX][]

Метод (обёртка над Яндекс.API [add_mx_record][]) предназначен для
создания новой записи типа MX на "припаркованном" на Яндексе домене.

	Add-DnsServerResourceRecordMX [-ZoneName] <String> [[-Name] <String>] [-MailExchange] <String> [[-Preference] <UInt16>] [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

Подробнее - [Add-DnsServerResourceRecordMX][].

### DnsServerResourceRecordNS

#### Обзор [Add-DnsServerResourceRecordNS][]

Метод (обёртка над Яндекс.API [add_ns_record][]) предназначен для
создания новой записи типа NS на "припаркованном" на Яндексе домене.

	Add-DnsServerResourceRecordNS [-ZoneName] <String> [[-Name] <String>] [-NameServer] <String[]> [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

Подробнее - [Add-DnsServerResourceRecordNS][].

### DnsServerResourceRecordSRV

#### Обзор [Add-DnsServerResourceRecordSRV][]

Метод (обёртка над Яндекс.API [add_srv_record][]) предназначен для
создания новой SRV записи на "припаркованном" на Яндексе домене.

	Add-DnsServerResourceRecordSRV [-ZoneName] <String> [-Name] <String> [-Server] <String> [-Port] <UInt16> [[-Preference] <UInt16>] [[-Weight] <UInt16>] [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

Подробнее - [Add-DnsServerResourceRecordSRV][].

### DnsServerResourceRecordTxt

#### Обзор [Add-DnsServerResourceRecordTxt][]

Метод (обёртка над Яндекс.API [add_txt_record][]) предназначен для
создания новой записи типа TXT на "припаркованном" на Яндексе домене.

	Add-DnsServerResourceRecordTxt [-ZoneName] <String> [[-Name] <String>] [-DescriptiveText] <String[]> [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

Подробнее - [Add-DnsServerResourceRecordTxt][].

Подробное описание функций модуля
---------------------------------

#### Add-DnsServerResourceRecord

Метод (обёртка над Яндекс.API [add_a_record][]) предназначен для
создания новой записи на "припаркованном" на Яндексе домене
на основе данных о записи из конвейера.
Параметры в этом командлете не привязаны к конвейеру сознательно: привязка
будет осуществлена в вызываемом в зависимости от типа записи командлете.
Здесь же в параметрах следует видеть только явно заданные параметры.
Интерфейс командлета максимально приближен к аналогичному командлету
модуля DnsServer Windows Server 2012.

##### Синтаксис

	Add-DnsServerResourceRecord [-ZoneName] <String> [[-Name] <String>] [-RRType] <String> [[-RecordData] <String>] [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

##### Компонент

API Яндекс.DNS для доменов

##### Параметры

- `ZoneName <String>`
        имя домена, зарегистрированного на сервисах Яндекса
        Требуется?                    true
        Позиция?                    1
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
- `Name <String>`
        имя записи
        Требуется?                    false
        Позиция?                    2
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
- `RRType <String>`
        тип записи
        Требуется?                    true
        Позиция?                    3
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `RecordData <String>`
        содержание записи
        Требуется?                    false
        Позиция?                    4
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
- `TimeToLive <Object>`
        TTL записи
            [System.TimeSpan]
        Требуется?                    false
        Позиция?                    5
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
- `PassThru [<SwitchParameter>]`
        передавать ли описатель созданной записи в конвейер
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
        "get-help [about_CommonParameters][]".

##### Примеры использования

1. "Копирование" всех записей типа A, AAAA, CNAME из локальной зоны DNS в публичную зону DNS, размещённую на серверах Яндекса.

		Get-DnsServerResourceRecord -ZoneName 'csm.nov.local' -RRType 'A','CNAME','AAAA' | Add-YandexDnsServerResourceRecord -ZoneName 'csm.nov.ru';

#### Get-DnsServerResourceRecord

Метод (обёртка над Яндекс.API [get_domain_records][]) предназначен для
получения записей из зоны "припаркованного" на Яндексе домене.
Интерфейс командлета максимально приближен к аналогичному командлету
модуля DnsServer Windows Server 2012.
Все функции данного модуля используют ITG.Yandex, в частности - [Get-Token][].

##### Синтаксис

	Get-DnsServerResourceRecord [-ZoneName] <String> [[-Name] <String[]>] [[-RRType] <String[]>] [[-RecordData] <String[]>] <CommonParameters>

##### Компонент

API Яндекс.DNS для доменов

##### Параметры

- `ZoneName <String>`
        имя домена, зарегистрированного на сервисах Яндекса
        Требуется?                    true
        Позиция?                    1
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
- `Name <String[]>`
        имя записи
        Требуется?                    false
        Позиция?                    2
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `RRType <String[]>`
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
- `<CommonParameters>`
        Данный командлет поддерживает общие параметры: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer и OutVariable. Для получения дополнительных сведений введите
        "get-help [about_CommonParameters][]".

##### Примеры использования

1. Пример 1.

		Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru';

##### Связанные ссылки

- [get_domain_records][]
- [MS PowerShell DnsServer - Get-DnsServerResourceRecord](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832924.aspx)

#### Remove-DnsServerResourceRecord

Метод (обёртка над Яндекс.API [delete_record][]) предназначен для
удаления записи из зоны "припаркованного" на Яндексе домене.
Интерфейс командлета максимально приближен к аналогичному командлету
модуля DnsServer Windows Server 2012.

##### Синтаксис

	Remove-DnsServerResourceRecord [-ZoneName] <String> [-Name] <String> [[-RRType] <String>] [[-RecordData] <String[]>] [[-id] <String>] [-PassThru] [-Force] [-WhatIf] [-Confirm] <CommonParameters>

##### Компонент

API Яндекс.DNS для доменов

##### Параметры

- `ZoneName <String>`
        имя домена, зарегистрированного на сервисах Яндекса
        Требуется?                    true
        Позиция?                    1
        Значение по умолчанию
        Принимать входные данные конвейера?false
        Принимать подстановочные знаки?
- `Name <String>`
        имя записи
        Требуется?                    true
        Позиция?                    2
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
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
- `id <String>`
        id записи. Параметр специфичен только для реализации Яндекс.API.
        Получен должен быть через [Get-DnsServerResourceRecord][].
        Требуется?                    false
        Позиция?                    5
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
- `Force [<SwitchParameter>]`
        На данный момент параметр не используется. В дальнейшем - удаление созданных Яндексом записей
        при подключении домена возможно будет только с данным флагом
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
        "get-help [about_CommonParameters][]".

##### Примеры использования

1. Пример 1.

		Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -Name 'www2','www3' | Remove-DnsServerResourceRecord -ZoneName 'csm.nov.ru';

##### Связанные ссылки

- [delete_record][]
- [MS PowerShell DnsServer - Remove-DnsServerResourceRecord](http://msdn.microsoft.com/en-us/library/windows/desktop/hh833144.aspx)

#### Add-DnsServerResourceRecordA

Метод (обёртка над Яндекс.API [add_a_record][]) предназначен для
создания новой записи типа A на "припаркованном" на Яндексе домене.
Интерфейс командлета максимально приближен к аналогичному командлету
модуля DnsServer Windows Server 2012.

##### Синтаксис

	Add-DnsServerResourceRecordA [-ZoneName] <String> [[-Name] <String>] [-IPv4Address] <IPAddress[]> [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

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
        Требуется?                    false
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
- `PassThru [<SwitchParameter>]`
        передавать ли описатель созданной записи в конвейер
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
        "get-help [about_CommonParameters][]".

##### Примеры использования

1. Пример 1.

		Add-DnsServerResourceRecordA -ZoneName 'csm.nov.ru' -Name 'www2' -IPv4Address '172.31.0.8', '172.31.0.7' -TimeToLive 55 ;

##### Связанные ссылки

- [add_a_record][]
- [MS PowerShell DnsServer - Add-DnsServerResourceRecordA](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832244.aspx)

#### Add-DnsServerResourceRecordAAAA

Метод (обёртка над Яндекс.API [add_aaaa_record][]) предназначен для
создания новой записи типа AAAA на "припаркованном" на Яндексе домене.
Интерфейс командлета максимально приближен к аналогичному командлету
модуля DnsServer Windows Server 2012.

##### Синтаксис

	Add-DnsServerResourceRecordAAAA [-ZoneName] <String> [[-Name] <String>] [-IPv6Address] <IPAddress[]> [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

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
        Требуется?                    false
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
- `PassThru [<SwitchParameter>]`
        передавать ли описатель созданной записи в конвейер
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
        "get-help [about_CommonParameters][]".

##### Примеры использования

1. Пример 1.

		Add-DnsServerResourceRecordAAAA -ZoneName 'csm.nov.ru' -Name 'www2' -IPv6Address '::1';

##### Связанные ссылки

- [add_aaaa_record][]
- [MS PowerShell DnsServer - Add-DnsServerResourceRecordAAAA](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832245.aspx)

#### Add-DnsServerResourceRecordCName

Метод (обёртка над Яндекс.API [add_cname_record][]) предназначен для
создания новой записи типа A на "припаркованном" на Яндексе домене.
Интерфейс командлета максимально приближен к аналогичному командлету
модуля DnsServer Windows Server 2012.
Есть некоторая особенность в API Яндекса - он позволяет создавать CName только
для FQDN. Другими словами, создать "короткий" CName со ссылкой на запись того же
домена нельзя, только через FQDN. Данная функция проверяет значение параметра Name
и в том случае, если в конце не `.` (то есть - не FQDN), к значению предварительно
дописывает ZoneName + `.`. Введён данный функционал для обеспечения совместимости с
командлетами DnsServer.

##### Синтаксис

	Add-DnsServerResourceRecordCName [-ZoneName] <String> [-Name] <String> [-HostAliasName] <String> [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

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
- `HostAliasName <String>`
        FQDN записей, на которые будет ссылаться CName
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
- `PassThru [<SwitchParameter>]`
        передавать ли описатель созданной записи в конвейер
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
        "get-help [about_CommonParameters][]".

##### Примеры использования

1. Создаём CName www2 как псевдоним к www.csm.nov.ru.

		Add-DnsServerResourceRecordCName -ZoneName 'csm.nov.ru' -Name 'www2' -HostAliasName 'www';

##### Связанные ссылки

- [add_cname_record][]
- [MS PowerShell DnsServer - Add-DnsServerResourceRecordCName](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832246.aspx)

#### Add-DnsServerResourceRecordMX

Метод (обёртка над Яндекс.API [add_mx_record][]) предназначен для
создания новой записи типа MX на "припаркованном" на Яндексе домене.
Интерфейс командлета максимально приближен к аналогичному командлету
модуля DnsServer Windows Server 2012.
В описании API на Яндексе закралась ошибка. API принимает и параметр priority.

##### Синтаксис

	Add-DnsServerResourceRecordMX [-ZoneName] <String> [[-Name] <String>] [-MailExchange] <String> [[-Preference] <UInt16>] [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

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
        Требуется?                    false
        Позиция?                    2
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `MailExchange <String>`
        FQDN сервера, который будет принимать SMTP почту
        Требуется?                    true
        Позиция?                    3
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `Preference <UInt16>`
        Приоритет сервера
        Требуется?                    false
        Позиция?                    4
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `TimeToLive <Object>`
        TTL записи
        Требуется?                    false
        Позиция?                    5
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `PassThru [<SwitchParameter>]`
        передавать ли описатель созданной записи в конвейер
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
        "get-help [about_CommonParameters][]".

##### Примеры использования

1. Создаём MX запись в домене csm.nov.ru.

		Add-DnsServerResourceRecordMX -ZoneName 'csm.nov.ru' -MailExchange 'mx.yandex.ru.';

##### Связанные ссылки

- [add_mx_record][]
- [MS PowerShell DnsServer - Add-DnsServerResourceRecordMX](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832249.aspx)

#### Add-DnsServerResourceRecordNS

Метод (обёртка над Яндекс.API [add_ns_record][]) предназначен для
создания новой записи типа NS на "припаркованном" на Яндексе домене.
Интерфейс командлета максимально приближен к аналогичному командлету
модуля DnsServer Windows Server 2012.

##### Синтаксис

	Add-DnsServerResourceRecordNS [-ZoneName] <String> [[-Name] <String>] [-NameServer] <String[]> [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

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
        Поддомен. Если значение параметра не указано, будет создана дополнительная NS запись для основного домена (ZoneNam
        e).
        Требуется?                    false
        Позиция?                    2
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `NameServer <String[]>`
        FQDN адрес DNS сервера, на котором размещена зона для создаваемого поддомена.
        To-Do: Сейчас проверка значения данного параметра не выполняется, в дальнейшем
        необходимо ввести проверку параметра
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
- `PassThru [<SwitchParameter>]`
        передавать ли описатель созданной записи в конвейер
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
        "get-help [about_CommonParameters][]".

##### Примеры использования

1. Создаём поддомен support в домене csm.nov.ru и указываем, что зона для этого поддомена поддерживается сервером ns.csm.nov.ru.

		Add-DnsServerResourceRecordNS -ZoneName 'csm.nov.ru' -Name 'support' -NameServer 'ns.csm.nov.ru.';

##### Связанные ссылки

- [add_ns_record][]
- [MS PowerShell DnsServer - Add-DnsServerResourceRecordNS](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832790.aspx)

#### Add-DnsServerResourceRecordSRV

Метод (обёртка над Яндекс.API [add_srv_record][]) предназначен для
создания новой SRV записи на "припаркованном" на Яндексе домене.
Интерфейс командлета максимально приближен к аналогичному командлету
модуля DnsServer Windows Server 2012.
To-Do: обнаружил ошибку в API: при создании SRV записи через API Яндекса
возникает ещё одна "фантомная" запись с тем же содержанием, но в состоянии
"добавляется". И так и висит. Удалить её нет возможности...

##### Синтаксис

	Add-DnsServerResourceRecordSRV [-ZoneName] <String> [-Name] <String> [-Server] <String> [-Port] <UInt16> [[-Preference] <UInt16>] [[-Weight] <UInt16>] [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

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
- `Server <String>`
        FQDN сервера, на котором расположен сервис, описываемый SRV записью
        Требуется?                    true
        Позиция?                    3
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `Port <UInt16>`
        Порт сервера
        Требуется?                    true
        Позиция?                    4
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `Preference <UInt16>`
        Приоритет сервера
        Требуется?                    false
        Позиция?                    5
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `Weight <UInt16>`
        Вес сервера
        Требуется?                    false
        Позиция?                    6
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `TimeToLive <Object>`
        TTL записи
        Требуется?                    false
        Позиция?                    7
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `PassThru [<SwitchParameter>]`
        передавать ли описатель созданной записи в конвейер
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
        "get-help [about_CommonParameters][]".

##### Примеры использования

1. Создаём SRV запись в домене csm.nov.ru.

		Add-DnsServerResourceRecordSRV -ZoneName 'csm.nov.ru' -Name '_xmpp-server._tcp' -Server 'xmpp' -Port 5269 -Weight 0 -Priority 40;

2. Копируем SRV записи, описывающие XMPP (Jabber) сервис, с одного домена в другой.

		Get-DnsServerResourceRecord -ZoneName 'csm.nov.ru' -RRType 'SRV' | ? { $_.HostName -like '*xmpp*' } | Add-DnsServerResourceRecord -ZoneName 'nice-tour.nov.ru';

##### Связанные ссылки

- [add_srv_record][]
- [MS PowerShell DnsServer - Add-DnsServerResourceRecordSRV](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832799.aspx)

#### Add-DnsServerResourceRecordTxt

Метод (обёртка над Яндекс.API [add_txt_record][]) предназначен для
создания новой записи типа TXT на "припаркованном" на Яндексе домене.
Интерфейс командлета максимально приближен к аналогичному командлету
модуля DnsServer Windows Server 2012.

##### Синтаксис

	Add-DnsServerResourceRecordTxt [-ZoneName] <String> [[-Name] <String>] [-DescriptiveText] <String[]> [[-TimeToLive] <Object>] [-PassThru] [-WhatIf] [-Confirm] <CommonParameters>

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
        Поддомен. Если значение параметра не указано, будет создана дополнительная NS запись для основного домена (ZoneNam
        e).
        Требуется?                    false
        Позиция?                    2
        Значение по умолчанию
        Принимать входные данные конвейера?true (ByPropertyName)
        Принимать подстановочные знаки?
- `DescriptiveText <String[]>`
        Содержание TXT записи
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
- `PassThru [<SwitchParameter>]`
        передавать ли описатель созданной записи в конвейер
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
        "get-help [about_CommonParameters][]".

##### Примеры использования

1. Пример 1.

		Add-DnsServerResourceRecordTxt -ZoneName 'csm.nov.ru' -Name 'hostmaster' -Text 'IT department of CSM of Velikiy Novgorod. Sergey S. Betke.';

##### Связанные ссылки

- [add_txt_record][]
- [MS PowerShell DnsServer - Add-DnsServerResourceRecordTxt](http://msdn.microsoft.com/en-us/library/windows/desktop/hh832800.aspx)


[about_CommonParameters]: http://go.microsoft.com/fwlink/?LinkID=113216 "Описание параметров, которые могут использоваться с любым командлетом."
[add_a_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_a_record.xml 
[add_aaaa_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_aaaa_record.xml 
[add_cname_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_cname_record.xml 
[add_mx_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_mx_record.xml 
[add_ns_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_ns_record.xml 
[add_srv_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_srv_record.xml 
[add_txt_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_add_txt_record.xml 
[Add-DnsServerResourceRecord]: <ITG.Yandex.DnsServer#Add-DnsServerResourceRecord> "Метод (обёртка над Яндекс.API add_a_record) предназначен для создания новой записи на "припаркованном" на Яндексе домене на основе данных о записи из конвейера."
[Add-DnsServerResourceRecordA]: <ITG.Yandex.DnsServer#Add-DnsServerResourceRecordA> "Метод (обёртка над Яндекс.API add_a_record) предназначен для создания новой записи типа A на "припаркованном" на Яндексе домене."
[Add-DnsServerResourceRecordAAAA]: <ITG.Yandex.DnsServer#Add-DnsServerResourceRecordAAAA> "Метод (обёртка над Яндекс.API add_aaaa_record) предназначен для создания новой записи типа AAAA на "припаркованном" на Яндексе домене."
[Add-DnsServerResourceRecordCName]: <ITG.Yandex.DnsServer#Add-DnsServerResourceRecordCName> "Метод (обёртка над Яндекс.API add_cname_record) предназначен для создания новой записи типа CNAME на "припаркованном" на Яндексе домене."
[Add-DnsServerResourceRecordMX]: <ITG.Yandex.DnsServer#Add-DnsServerResourceRecordMX> "Метод (обёртка над Яндекс.API add_mx_record) предназначен для создания новой записи типа MX на "припаркованном" на Яндексе домене."
[Add-DnsServerResourceRecordNS]: <ITG.Yandex.DnsServer#Add-DnsServerResourceRecordNS> "Метод (обёртка над Яндекс.API add_ns_record) предназначен для создания новой записи типа NS на "припаркованном" на Яндексе домене."
[Add-DnsServerResourceRecordSRV]: <ITG.Yandex.DnsServer#Add-DnsServerResourceRecordSRV> "Метод (обёртка над Яндекс.API add_srv_record) предназначен для создания новой SRV записи на "припаркованном" на Яндексе домене."
[Add-DnsServerResourceRecordTxt]: <ITG.Yandex.DnsServer#Add-DnsServerResourceRecordTxt> "Метод (обёртка над Яндекс.API add_txt_record) предназначен для создания новой записи типа TXT на "припаркованном" на Яндексе домене."
[delete_record]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_delete_record.xml 
[get_domain_records]: http://api.yandex.ru/pdd/doc/api-pdd/reference/api-dns_get_domain_records.xml 
[Get-DnsServerResourceRecord]: <ITG.Yandex.DnsServer#Get-DnsServerResourceRecord> "Метод (обёртка над Яндекс.API get_domain_records) предназначен для получения записей из зоны "припаркованного" на Яндексе домене."
[Get-Token]: <ITG.Yandex#Get-Token> "Метод (обёртка над Яндекс.API get_token) предназначен для получения авторизационного токена."
[Remove-DnsServerResourceRecord]: <ITG.Yandex.DnsServer#Remove-DnsServerResourceRecord> "Метод (обёртка над Яндекс.API delete_record) предназначен для удаления записи из зоны "припаркованного" на Яндексе домене."

---------------------------------------

Генератор: [ITG.Readme](http://github.com/IT-Service/ITG.Readme "Модуль PowerShell для генерации readme для модулей PowerShell").

