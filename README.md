# n8n 分散式部署與自動初始化

使用 Docker Compose 來部署 n8n 的分散式環境，並自動初始化工作流程

## 目錄結構

- `Makefile`: 包含啟動、停止及初始化服務的指令。
- `docker-compose.redis.yml`: Redis 服務的 Docker Compose 配置。
- `docker-compose.postgres.yml`: Postgres 服務的 Docker Compose 配置。
- `docker-compose.main.yml`: n8n 主服務的 Docker Compose 配置。
- `docker-compose.worker.yml`: n8n 工作者服務的 Docker Compose 配置。
- `workflows/`: 存放 n8n 工作流程的 JSON 文件。

## 使用方法

### 啟動服務

要啟動所有服務，請執行以下命令：

```bash
make up
```

這將依次啟動 Redis、Postgres、n8n 主服務和工作者服務。

### 分別啟動不同服務

- **啟動 Redis 服務**：
  ```bash
  make up-redis
  ```

- **啟動 Postgres 服務**：
  ```bash
  make up-postgres
  ```

- **啟動 n8n 主服務**：
  ```bash
  make up-main
  ```

- **啟動 n8n 工作者服務**：
  ```bash
  make up-worker
  ```

### 初始化

初始化過程會建立 n8n 的擁有者並匯入所有工作流程。執行以下命令進行初始化：

```bash
make init
```

### 停止服務

要停止所有服務，請執行：

```bash
make down
```

## .env 文件配置

在執行任何命令之前，請確保 `.env` 文件已正確配置。

## 部署步驟

1. **準備環境**：
   - 確保已安裝 Docker 和 Docker Compose。
   - 配置 `.env` 文件，確保所有必要的環境變數已正確設置。

2. **啟動服務**：
   - 使用 `make up` 命令啟動所有服務，或根據需要分別啟動特定服務。

3. **初始化 n8n**：
   - 執行 `make init` 以初始化 n8n，這將建立擁有者並匯入工作流程。

4. **驗證部署**：
   - 確認所有服務均已成功啟動，並且 n8n 可以正常運行。

5. **停止服務**：
   - 使用 `make down` 停止所有服務。

