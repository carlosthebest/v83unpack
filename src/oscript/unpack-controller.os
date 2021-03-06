﻿
Перем Распаковщик;
Перем Параметры;

Процедура Синхронизировать()

	СоздатьРаспаковщик();
	Распаковщик.РежимОтладки(Истина);
	Попытка
		
		ПараметрыИнициализации = Распаковщик.ПолучитьПараметрыИнициализации();
		Если Параметры.Свойство("ПутьКПлатформе83") Тогда
			ПараметрыИнициализации.ПутьКПлатформе83 = Параметры.ПутьКПлатформе83;
		КонецЕсли;
		ПараметрыИнициализации.ПутьGit = Параметры.ПутьGit;
		ПараметрыИнициализации.ДоменПочтыДляGit = Параметры.ДоменПочтыДляGit;
		
		Распаковщик.Инициализация(ПараметрыИнициализации);
		Если Не Распаковщик.СинхронизироватьХранилищеКонфигурацийСГит(Параметры) Тогда
			ВызватьИсключение "Синхронизация завершилась неудачно. См. лог";
		КонецЕсли;
	Исключение
		Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
		ВызватьИсключение;
	КонецПопытки;
	
	Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
	
КонецПроцедуры

Процедура ОтправитьНаУдаленныйУзел()
	СоздатьРаспаковщик();
	Распаковщик.РежимОтладки(Истина);
	
	Попытка
		
		ПараметрыИнициализации = Распаковщик.ПолучитьПараметрыИнициализации();
		Если Параметры.Свойство("ПутьКПлатформе83") Тогда
			ПараметрыИнициализации.ПутьКПлатформе83 = Параметры.ПутьКПлатформе83;
		КонецЕсли;
		ПараметрыИнициализации.ПутьGit = Параметры.ПутьGit;
		Распаковщик.Инициализация(ПараметрыИнициализации);
		
		Результат = Распаковщик.ВыполнитьGitPush(Параметры.КаталогВыгрузки, Параметры.GitURL, "master");
		Если Результат <> 0 Тогда
			ВызватьИсключение "Git push завершился с кодом <"+Результат+">";
		КонецЕсли;
		
	Исключение
		Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
		ВызватьИсключение;
	КонецПопытки;
	
	Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
	
КонецПроцедуры

Процедура ПрочитатьПараметры()
	Параметры = ПолучитьПараметрыИзОкружения();
КонецПроцедуры

Функция АбсолютныйПуть(Знач ОтносительныйПуть)
	
	Каталог = Новый Файл(ТекущийСценарий().Источник).Путь;
	Возврат Каталог + "\" + ОтносительныйПуть;
	
КонецФункции

Процедура СоздатьРаспаковщик()

	Если Распаковщик = Неопределено Тогда
		ПодключитьСценарий(АбсолютныйПуть("unpack.os"), "V83Unpack");
		Распаковщик = Новый V83Unpack;
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьПараметрыИзОкружения()

	СИ = Новый СистемнаяИнформация();
	Окружение = СИ.ПеременныеСреды();
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПутьКФайлуХранилища1С", Новый Файл(Окружение["storage_dir"]).ПолноеИмя + "\1cv8ddb.1CD");
	Параметры.Вставить("КаталогВыгрузки", Новый Файл(Окружение["git_local_repo"]).ПолноеИмя);
	Параметры.Вставить("ПутьКПлатформе83", Окружение["v8_executable"]);
	Параметры.Вставить("ПутьGit", Окружение["git_executable"]);
	Параметры.Вставить("GitURL", Окружение["git_remote_repo"]);
	Параметры.Вставить("ДоменПочтыДляGit", Окружение["git_email_domain"]);
	
	Возврат Параметры;

КонецФункции

ПрочитатьПараметры();
Синхронизировать();
ОтправитьНаУдаленныйУзел();
