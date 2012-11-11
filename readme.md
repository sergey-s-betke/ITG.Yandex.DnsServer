ITG.Yandex.DnsServer
====================

Обёртки для API Яндекс DNS для домена (pdd.yandex.ru) и командлеты на их основе.
Модуль предназначен для обеспечения той же функциональности, что и модуль DNSServer из комплекта
Windows Server 2012, но на базе DNS серверов Яндекса (естественно, с ограничениями),
интерфейс максимально приближен к интерфейсу командлет модуля DNSServer.

Функции модуля
--------------
			
### DnsServerResourceRecord
			
#### Remove-DnsServerResourceRecord

Метод (обёртка над Яндекс.API delete_record) предназначен для 
удаления записи из зоны "припаркованного" на Яндексе домене.

Remove-DnsServerResourceRecord [-ZoneName] <String> [-Name] <String[]> [[-RRType] <String>] [[-RecordData] <String[]>] [-PassThru] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]

			
### DnsServerResourceRecordA
			
#### Add-DnsServerResourceRecordA

Метод (обёртка над Яндекс.API add_a_record) предназначен для 
создания новой записи типа A на "припаркованном" на Яндексе домене.

Add-DnsServerResourceRecordA [-ZoneName] <String> [-Name] <String> [-IPv4Address] <IPAddress[]> [[-TimeToLive] <Object>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]

			
### DnsServerResourceRecordAAAA
			
#### Add-DnsServerResourceRecordAAAA

Метод (обёртка над Яндекс.API add_aaaa_record) предназначен для 
создания новой записи типа AAAA на "припаркованном" на Яндексе домене.

Add-DnsServerResourceRecordAAAA [-ZoneName] <String> [-Name] <String> [-IPv6Address] <IPAddress[]> [[-TimeToLive] <Object>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]

