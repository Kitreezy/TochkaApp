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


### Tuist установка и настройка 

- **Модульная архитектура** - каждая фича в отдельном модуле
- **Масштабируемость** - легко добавлять новые модули
- **Переиспользование** - shared компоненты между модулями
- **Быстрая сборка** - только измененные модули пересобираются
  
  
```swift
# Установка через Homebrew 
brew tap tuist/tuist 
brew install tuist 

# Проверка установки 
tuist version
```

```swift
# Создаем папку проекта 
mkdir TochkaApp 
cd TochkaApp 

# Инициализация Tuist проекта 
tuist init --path Tochka
```

### Настройка Project.swift (главный конфигурационный файл)

Создаем/редактируем `Project.swift`:
```swift
import ProjectDesciption

let project = Project(
	name: "имя проекта",
	organizationName: "имя организации"

	settings: .settings(
		base: []
		configurations: []
	),
	targets:[
		.target(
			name: "",
			platform: .,
			product: .,
			bundleId: "",
			deploymentTarget: .,
			infoPlist: .,
			sources: [""],
			resources: [""],
			dependencies: [
				.target(name: ""),
				...
				.target(name: "")
			]
		),
		...
		.target(
			...
		)
	]
)
```

```swift

# Создаем структуру папок для проекта
mkdir -p Tochka/Sources
mkdir -p Tochka/Resources

# Создаем модули
mkdir -p Modules/Core/Sources
mkdir -p Modules/DesignSystem/Sources
mkdir -p Modules/DesignSystem/Resources
mkdir -p Modules/MapFeature/Sources
mkdir -p Modules/ActivityFeature/Sources
mkdir -p Modules/ChatFeature/Sources
mkdir -p Modules/AuthFeature/Sources
mkdir -p Modules/ProfileFeature/Sources

# Создаем папки для тестов
mkdir -p Tests/CoreTests
mkdir -p Tests/MapFeatureTests
```

После настройки и создания базовых файлов, переходим к созданию зависимостей для Tuist:

### Создание Package.swift для зависимостей: 

```swift 
import PackageDescription

let package = Package(
	name: "имя для зависимостей",
	platforms: [.iOS(.v15)],
	products: [],
	dependencies: [
		.package(
			url: "",
			from: ""
		),
		...
		.package(
		)
	],
	targets: []
)
```


### Создание Dependencies.swift (для Tuist)
```swift
import ProjectDescription

let dependencies = Dependencies( 
	swiftPackageManager: SwiftPackageManagerDependencies([
		 .remote( 
			 url: "https://github.com/firebase/firebase-ios-sdk.git",
			 requirement: .upToNextMajor(from: "10.18.0") 
		 ), 
		 
		 .remote( 
			 url: "https://github.com/onevcat/Kingfisher.git", 
			 requirement: .upToNextMajor(from: "7.10.0") 
			 ) 
	 ]), 
	 platforms: [.iOS] 
)


