# Makefile для проекта Tochka
.PHONY: help setup generate clean build test lint format install bootstrap

# Переменные
PROJECT_NAME = Tochka
SCHEME = Tochka
WORKSPACE = $(PROJECT_NAME).xcworkspace

# Цвета для вывода
YELLOW = \033[1;33m
GREEN = \033[1;32m
RED = \033[1;31m
NC = \033[0m # No Color

help: ## Показать справку по командам
	@echo "$(YELLOW)Доступные команды для проекта $(PROJECT_NAME):$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

setup: ## Полная настройка проекта (первый запуск)
	@echo "$(YELLOW)🚀 Настройка проекта Tochka...$(NC)"
	@make install
	@make bootstrap
	@make generate
	@echo "$(GREEN)✅ Проект настроен! Запустите 'make open' для открытия$(NC)"

install: ## Установка зависимостей (Tuist, SwiftLint)
	@echo "$(YELLOW)📦 Установка инструментов разработки...$(NC)"
	@if ! command -v tuist &> /dev/null; then \
		echo "Установка Tuist..."; \
		brew tap tuist/tuist && brew install tuist; \
	else \
		echo "Tuist уже установлен"; \
	fi
	@if ! command -v swiftlint &> /dev/null; then \
		echo "Установка SwiftLint..."; \
		brew install swiftlint; \
	else \
		echo "SwiftLint уже установлен"; \
	fi
	@if ! command -v swiftformat &> /dev/null; then \
		echo "Установка SwiftFormat..."; \
		brew install swiftformat; \
	else \
		echo "SwiftFormat уже установлен"; \
	fi

bootstrap: ## Скачивание зависимостей проекта
	@echo "$(YELLOW)📦 Скачивание зависимостей...$(NC)"
	tuist install

generate: ## Генерация Xcode проекта
	@echo "$(YELLOW)🔧 Генерация Xcode проекта...$(NC)"
	tuist generate

clean: ## Очистка build артефактов
	@echo "$(YELLOW)🧹 Очистка проекта...$(NC)"
	tuist clean
	rm -rf build/
	rm -rf DerivedData/
	rm -rf .build/

build: ## Сборка проекта
	@echo "$(YELLOW)🔨 Сборка проекта...$(NC)"
	xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration Debug clean build

build-release: ## Сборка релизной версии
	@echo "$(YELLOW)🔨 Сборка релизной версии...$(NC)"
	xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration Release clean build

test: ## Запуск всех тестов
	@echo "$(YELLOW)🧪 Запуск тестов...$(NC)"
	xcodebuild test -workspace $(WORKSPACE) -scheme $(SCHEME) -destination 'platform=iOS Simulator,name=iPhone 16 PRO,OS=latest'

test-unit: ## Запуск только юнит тестов
	@echo "$(YELLOW)🧪 Запуск юнит тестов...$(NC)"
	xcodebuild test -workspace $(WORKSPACE) -scheme Core -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'

lint: ## Проверка стиля кода
	@echo "$(YELLOW)🔍 Проверка стиля кода...$(NC)"
	swiftlint lint --strict

lint-autocorrect: ## Автоматическое исправление стиля кода
	@echo "$(YELLOW)🔧 Автоматическое исправление стиля...$(NC)"
	swiftlint lint --autocorrect

format: ## Форматирование кода
	@echo "$(YELLOW)✨ Форматирование кода...$(NC)"
	swiftformat .

open: ## Открыть проект в Xcode
	@if [ -e $(WORKSPACE) ]; then \
		open $(WORKSPACE); \
	else \
		echo "$(RED)❌ Workspace не найден. Запустите 'make generate'$(NC)"; \
	fi

status: ## Показать статус проекта
	@echo "$(YELLOW)📊 Статус проекта:$(NC)"
	@echo "Project: $(GREEN)$(PROJECT_NAME)$(NC)"
	@echo "Workspace: $(if $(wildcard $(WORKSPACE)),$(GREEN)✅ Существует$(NC),$(RED)❌ Не найден$(NC))"
	@echo "Tuist: $(if $(shell command -v tuist),$(GREEN)✅ Установлен$(NC),$(RED)❌ Не установлен$(NC))"
	@echo "SwiftLint: $(if $(shell command -v swiftlint),$(GREEN)✅ Установлен$(NC),$(RED)❌ Не установлен$(NC))"
	@echo "SwiftFormat: $(if $(shell command -v swiftformat),$(GREEN)✅ Установлен$(NC),$(RED)❌ Не установлен$(NC))"

update: ## Обновление зависимостей
	@echo "$(YELLOW)🔄 Обновление зависимостей...$(NC)"
	tuist install --update
	tuist generate

reset: ## Полная очистка и пересоздание проекта
	@echo "$(YELLOW)🔄 Полный сброс проекта...$(NC)"
	@make clean
	@make bootstrap
	@make generate
	@echo "$(GREEN)✅ Проект сброшен и пересоздан$(NC)"

graph: ## Показать граф зависимостей
	@echo "$(YELLOW)📊 Генерация графа зависимостей...$(NC)"
	tuist graph

edit: ## Редактировать конфигурацию Tuist
	tuist edit

# Алиасы для частых команд
g: generate ## Алиас для generate
b: build ## Алиас для build
t: test ## Алиас для test
l: lint ## Алиас для lint
o: open ## Алиас для open

# Firebase команды
firebase-setup: ## Настройка Firebase Emulator
	@echo "$(YELLOW)🔥 Настройка Firebase Emulator...$(NC)"
	@if ! command -v firebase &> /dev/null; then \
		echo "Установка Firebase CLI..."; \
		npm install -g firebase-tools; \
	fi
	firebase login
	firebase init emulators

firebase-start: ## Запуск Firebase Emulator
	@echo "$(YELLOW)🔥 Запуск Firebase Emulator...$(NC)"
	firebase emulators:start

# Git хуки
install-hooks: ## Установка git хуков
	@echo "$(YELLOW)🪝 Установка git хуков...$(NC)"
	cp scripts/pre-commit .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "$(GREEN)✅ Git хуки установлены$(NC)"

# Команды для CI/CD
ci-setup: ## Настройка для CI/CD
	@make install
	@make bootstrap

ci-test: ## Тесты для CI/CD
	@make lint
	@make test

ci-build: ## Сборка для CI/CD
	@make build-release
