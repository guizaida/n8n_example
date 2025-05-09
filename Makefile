# Makefile - 分散式 n8n 部署與自動初始化

# 設定目錄與共用變數
YML_DIR=.
ENV_FILE=.env

REDIS_YML=$(YML_DIR)/docker-compose.redis.yml
POSTGRES_YML=$(YML_DIR)/docker-compose.postgres.yml
MAIN_YML=$(YML_DIR)/docker-compose.main.yml
WORKER_YML=$(YML_DIR)/docker-compose.worker.yml

DC=docker compose --env-file $(ENV_FILE)

# 自動建立 n8n import 命令字串
IMPORT_COMMAND=$(shell find ./workflows -name '*.json' | xargs -I{} echo "n8n import:workflow --input={}" | paste -sd ' && ' -)


# 啟動所有主服務
.PHONY: up
up: up-redis up-postgres up-main up-worker

up-redis:
	$(DC) -f $(REDIS_YML) up -d

up-postgres:
	$(DC) -f $(POSTGRES_YML) up -d

up-main:
	$(DC) -f $(MAIN_YML) up -d n8n-main

up-worker:
	$(DC) -f $(WORKER_YML) up -d

# 初始化（建立 owner + 匯入 workflows）
.PHONY: init
init: setup import

setup:
	@echo "⏳ 執行 n8n-setup 初始化..."
	$(DC) -f $(MAIN_YML) up --abort-on-container-exit n8n-setup

import:
	@echo "⏳ 自動匯入 workflows..."
	@echo "#!/bin/sh" > workflows/import_all.sh
	@find ./workflows -name '*.json' | while read file; do \
		basefile=$$(basename $$file); \
		echo "n8n import:workflow --input=$$basefile" >> workflows/import_all.sh; \
	done
	@chmod +x workflows/import_all.sh
	$(DC) -f $(MAIN_YML) run --rm \
		-v $$PWD/workflows:/workflows \
		n8n-import-auto sh -c "/workflows/import_all.sh"



# 停止所有服務
.PHONY: down
down: down-redis down-postgres down-main down-worker

down-redis:
	$(DC) -f $(REDIS_YML) down

down-postgres:
	$(DC) -f $(POSTGRES_YML) down

down-main:
	$(DC) -f $(MAIN_YML) down

down-worker:
	$(DC) -f $(WORKER_YML) down
