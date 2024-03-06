# RepIt App

Приложение для создания и изучения карточек

Этим репозиторием хочу показать стиль написания кода, который я использую в написании приложений.

Вдохновлен идеями и решениями этих замечательных людей: https://github.com/hawkkiller и https://github.com/PlugFox

При написании данного приложения, решил воспользоваться https://github.com/hawkkiller/sizzle_starter

Чем именно нравится идея такого стартера:

- Отличное решение для DI с использованием Inhretied Widget, что отлично подходит для написания Flutter приложений, без использования доп пакетов
- В качеcтве стейт-менеджмента выбран BLoC, что на мой взгляд тоже одно из лучших решений для Flutter (также имеется опыт с RiverPod)
- Отличное решение для смены темы приложения и локализации, с использованием Inhretied Widget
- Уже есть готовые GitHub Actions and GitLab для CI
- Drift пакет, для локальной базы банных
- Уже готовый линтер и анализатор

## Navigation

В качестве навигатора, решил сделать https://pub.dev/packages/octopus (пока в качестве изучения этого пакета, так как нравится все, что делает FOX =) )
На других проектах, использовал GoRouter и Auto Route

## State-managment

BloC, так как считаю, что данный пакет лучшим решением для Flutter

## DateBase

Drift выбран для локальной базы данных. Что касается именно Флаттер, с другими пакетами я не работал, так слышу много плохих отзывов про isar и hive. И Drift мне напоминает Room в нативной Андройд разработке

## Testing

Каждый метод, который обращается к базе данных покрыт Unit тестами. В дальнейшем планы написать интеграционные и Golden тесты