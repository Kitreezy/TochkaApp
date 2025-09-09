# 📍 Tochka

> Находи интересные активности рядом с тобой

## 🎯 Описание проекта

Tochka — это iOS приложение для поиска и создания активностей по геолокации. Пользователи могут:
- Выбирать места на карте и создавать мероприятия
- Присоединяться к активностям других пользователей
- Общаться в чате до и во время мероприятий
- Оставлять отзывы после завершения активностей

## 🏗 Архитектура

### Техническая структура
- **UI**: SwiftUI + UIKit (для MapKit и сложных компонентов)
- **Архитектура**: MVVM + Clean Architecture
- **Модульность**: Tuist для управления зависимостями и модулями
- **Backend**: Firebase (MVP) → собственный backend (roadmap)
- **Реактивность**: Combine

### Модули проекта

```
Tochka/
├── Tochka/                 # Основное приложение
├── Modules/
│   ├── Core/              # Базовые модели и утилиты
│   ├── DesignSystem/      # UI компоненты и стили
│   ├── MapFeature/        # Карта и геолокация
│   ├── ActivityFeature/   # Создание и управление активностями
│   ├── ChatFeature/       # Чат и сообщения
│   ├── AuthFeature/       # Авторизация и регистрация
│   └── ProfileFeature/    # Профиль пользователя
└── Tests/                 # Юнит и UI тесты
```

## 🛠 Установка и настройка

### Требования
- Xcode 15.0+
- iOS 15.0+
- Swift 5.9+
- macOS 13.0+

### Быстрый старт

```bash
make setup # Полная настройка проекта 

make generate # Генерация Xcode проекта

make test # Запуск тестов

make lint # Проверка стиля кода
```


## 🚀 Разработка

### Структура файлов в модуле

```
ModuleName/
├── Sources/
│   ├── Models/           # Модели данных
│   ├── ViewModels/       # View Models
│   ├── Views/           # SwiftUI Views
│   ├── Services/        # Сервисы и репозитории
│   └── Utils/           # Утилиты модуля
└── Tests/
    └── ModuleNameTests/ # Тесты модуля
```

### Добавление нового модуля

1. **Создание структуры папок**
   ```bash
   mkdir -p Modules/NewFeature/Sources
   mkdir -p Modules/NewFeature/Tests
   ```

2. **Добавление в Project.swift**
   ```swift
   Target(
       name: "NewFeature",
       platform: .iOS,
       product: .framework,
       bundleId: "com.tochka.app.newfeature",
       sources: ["Modules/NewFeature/Sources/**"],
       dependencies: [.target(name: "Core")]
   )
   ```

3. **Регенерация проекта**
   ```bash
   tuist generate
   ```

### Стиль кода

Проект использует SwiftLint для поддержания качества кода:

```swift
// ✅ Правильно
// MARK: - View Model

class ActivityListViewModel: BaseViewModel {
    @Published var activities: [Activity] = []
    
    func loadActivities() {
        // Implementation
    }
}

// ❌ Неправильно
class activityListViewModel{
var activities:[Activity]=[]
func loadActivities(){}}
```


## 📱 Функциональность

### MVP 
- [x] ✅ Модульная архитектура проекта
- [x] 🗺️ Карта с отображением мест
- [ ] 📍 Создание активностей в выбранных местах
- [ ] 💬 Чат внутри активности
- [x] 👤 Базовый профиль пользователя
- [x] 🔐 Авторизация через Firebase

## 🧪 Тестирование

### Запуск тестов

```bash
# Все тесты
xcodebuild test -workspace Tochka.xcworkspace -scheme Tochka

# Конкретный модуль
xcodebuild test -workspace Tochka.xcworkspace -scheme Core
```
или проще
```bash

make test

```


### Типы тестов

- **Unit Tests**: Тестирование бизнес-логики и ViewModels
- **Integration Tests**: Тестирование взаимодействия между модулями
- **UI Tests**: Автоматизированное тестирование пользовательского интерфейса
- **Snapshot Tests**: Визуальное тестирование компонентов




