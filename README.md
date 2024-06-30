# Tracker
___

## О приложении:

Tracker - Приложение для отслеживания своих активностей.
Большая часть данных о трекерах хранится в CoreData, но также используется хранилище UserDefaults.
Изночальная архитектура приложения - MVC, но в последствии для большинста экран был произведен рефакторниг в MVVM с помощью байндингов, реализованных через замыкания.
Для обнавления данных в коллециях и таблицах используется NSFetchedResultsController, что снижает громозкость архитектуры.
В приложение добавлена локализация для двух языков (русского и английского), темная тема, скриншот тесты и метрики от Яндекс.

___

## Описание функционала

При первом запуске приложения можно увидеть экран онбординга:

<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/Onboarding.png">
</p>

#

При нажатии на кнопку "Вот это технологии!", осуществляетя переход на основной экран и онбординг больше не показывается при повторном запуске:
Если трекеров на нужный день нет, вместо коллекции видна заглушка

Русская локализация:
<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/EmptyMain.png">
</p>

Английская локализация:
<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/%20MainEnglish.png">
</p>

#

Есть два вида трекера, привычка и нерегулярное событие.
Отличие привычки от нерегулярного события в том, что нерегулярное события создается только для конкретной выбранной даты, и его можно выполнить только один раз,
а привычка - это регулярное событие, и для него можно выбрать дни, в которые оно будет повторятся.
При создании привычки можно выбрать название, категорию, дни, цвет и емоджи трекера. Для нерегулярного события набор такой же,
за исключением дней.

<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/TrackerCreation.png">
</p>

Ниже представлен экран выбора дней:

<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/Schedule.png">
</p>

#

На главном экране можно выбрать день, чтобы посмотреть трекеры для этого дня или даты:

<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/%20DatePicker.png">
</p>

Также можно искать трекеры по названию с помощью search bar'а в верху главного экрана:

<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/Search.png">
</p>

#

Зажав палец на ячейке трекара, появляется контекстно меню, где можно выбрать 3 варианта взаимодействия с трекером:
Закрепить/Открепить(Зависит от статуса закрепленности трекера), редактировать и удалить

<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/%20ContextMenu.png">
</p>

При нажатии на кнопку "Закрепить" в контекстном меню закрепленный трекер отображается в категории закрепленные в самом верху.
При нажатии на "Открепить" трекер возвращается в своё исходное положение

<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/%20Pinned.png">
</p>

При нажатии на кнопку редактировать, открывается экран редактирования, где можно поменять любые данные трекера, кроме количества выполненых дней

<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/Editing.png">
</p>

#

Все выполненные трекеры считаются и отображаются на экране со статистикой:

<p align="center">
  <img width="294" height="639" src="https://github.com/AlexanderPleshakov/Tracker/blob/main/ReadMeAssets/%20Statistic.png">
</p>


