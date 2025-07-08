import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies([
        // Пока что без внешних зависимостей
        // Firebase добавим позже, когда базовая структура заработает
    ]),
    platforms: [.iOS]
)

// MARK: - Комментарии по выбору зависимостей

/*
Почему именно эти зависимости:

1. Firebase:
   - Быстрый старт для MVP
   - Готовые решения для Auth, Database, Storage
   - Бесплатный tier для начала
   - Легкая миграция на собственный backend в будущем

2. Kingfisher:
   - Стандарт для загрузки изображений в iOS
   - Отличное кэширование
   - Поддержка SwiftUI из коробки
   - Малый размер библиотеки

Используемые Firebase модули:
- FirebaseAuth: Авторизация пользователей
- FirebaseFirestore: База данных для активностей и чатов
- FirebaseStorage: Хранение изображений
- FirebaseMessaging: Push-уведомления
*/
