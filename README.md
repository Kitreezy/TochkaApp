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

1. **Клонирование репозитория**
   ```bash
   git clone https://github.com/yourusername/tochka-app.git
   cd tochka-app
   ```

2. **Установка Tuist**
   ```bash
   brew tap tuist/tuist
   brew install tuist
   ```

3. **Генерация проекта**
   ```bash
   tuist fetch        # Скачивание зависимостей
   tuist generate     # Генерация Xcode проекта
   ```

4. **Настройка Firebase**
   - Создай проект в [Firebase Console](https://console.firebase.google.com)
   - Скачай `GoogleService-Info.plist`
   - Добавь файл в `Tochka/Resources/`
   - Настрой Firestore Database и Authentication

5. **Обновление Team ID**
   ```swift
   // В Project.swift замени YOUR_TEAM_ID на свой
   "DEVELOPMENT_TEAM": "YOUR_ACTUAL_TEAM_ID"
   ```

6. **Запуск**
   ```bash
   open Tochka.xcworkspace
   # Выбери схему Tochka и запусти
   ```

### Настройка окружения разработки

#### SwiftLint и SwiftFormat
```bash
# Установка
brew install swiftlint swiftformat

# Автоматический запуск при сборке уже настроен в проекте
```

#### Firebase Emulator (для разработки)
```bash
npm install -g firebase-tools
firebase login
firebase init emulators
firebase emulators:start
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

### Правила коммитов

```bash
# Формат: type(scope): description

feat(map): add location search functionality
fix(chat): resolve message ordering issue
docs(readme): update installation instructions
refactor(core): simplify error handling
test(activity): add unit tests for creation flow
```

## 📱 Функциональность

### MVP (Минимально жизнеспособный продукт)

- [x] ✅ Модульная архитектура проекта
- [ ] 🗺️ Карта с отображением мест
- [ ] 📍 Создание активностей в выбранных местах
- [ ] 💬 Чат внутри активности
- [ ] 👤 Базовый профиль пользователя
- [ ] 🔐 Авторизация через Firebase

### Roadmap

#### Фаза 2 (Q2 2025)
- [ ] 🔔 Push-уведомления
- [ ] ⭐ Рейтинг пользователей
- [ ] 📷 Отправка фото в чат
- [ ] 📅 Интеграция с Apple Calendar

#### Фаза 3 (Q3 2025)
- [ ] 🏗️ Собственный backend
- [ ] 🔍 Улучшенный поиск и фильтры
- [ ] 👥 Система друзей
- [ ] 📊 Аналитика и метрики

## 🧪 Тестирование

### Запуск тестов

```bash
# Все тесты
xcodebuild test -workspace Tochka.xcworkspace -scheme Tochka

# Конкретный модуль
xcodebuild test -workspace Tochka.xcworkspace -scheme Core
```

### Типы тестов

- **Unit Tests**: Тестирование бизнес-логики и ViewModels
- **Integration Tests**: Тестирование взаимодействия между модулями
- **UI Tests**: Автоматизированное тестирование пользовательского интерфейса
- **Snapshot Tests**: Визуальное тестирование компонентов

## 📦 Сборка и деплой

### Debug сборка
```bash
tuist generate
xcodebuild -workspace Tochka.xcworkspace -scheme Tochka -configuration Debug
```

### Release сборка
```bash
tuist generate
xcodebuild -workspace Tochka.xcworkspace -scheme Tochka -configuration Release
```

### Fastlane (планируется)
```bash
# Деплой в TestFlight
fastlane beta

# Деплой в App Store
fastlane release
```

## 🤝 Участие в разработке

1. Fork репозитория
2. Создай feature branch (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'feat(scope): add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Открой Pull Request

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл `LICENSE` для подробностей.

## 📞 Контакты

- **Разработчик**: [Ваше имя]
- **Email**: your.email@example.com
- **Telegram**: @yourusername

---

**Статус проекта**: 🚧 В разработке

Последнее обновление: 07.07.2025
