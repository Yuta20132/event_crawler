# My API Template

## テンプレートから作成した直後にやること

この章の項目は、テンプレートから新しいプロジェクトを作った直後に一度対応すれば十分です。

### 1. Git 履歴を切り離して再初期化（初回のみ）

```bash
rm -rf .git
git init
git add .
git commit -m "Initial commit from template"
```

必要なら新しいリモートを設定します。

```bash
git remote add origin <new-repository-url>
git branch -M main
git push -u origin main
```

### 2. DB 名と接続情報をプロジェクト名に合わせる（初回のみ）

`config/database.yml` の以下を変更してください。

- `development.database` (`myapp_development`)
- `test.database` (`myapp_test`)
- `production.primary.database` (`my_api_template_production`)
- `production.cache.database` (`my_api_template_production_cache`)
- `production.queue.database` (`my_api_template_production_queue`)
- `production.cable.database` (`my_api_template_production_cable`)
- `production.primary.username` (`my_api_template`)
- `production.primary.password` で参照する環境変数名（`MY_API_TEMPLATE_DATABASE_PASSWORD`）

必要に応じて `default` の `username` / `password` / `port` もローカル環境に合わせて更新してください。

変更後に DB を作成・反映します。初回セットアップ時、または DB 設定を見直したときに実行してください。

```bash
bundle exec rails db:prepare
```

### 3. プロジェクト名を README などに反映（初回のみ）

- README タイトル（`# My API Template`）を実プロジェクト名へ変更
- 必要なら Swagger の `swagger/v1/swagger.yaml` の `info.title` も変更

## Swagger でエンドポイントを確認する

このテンプレートでは `rswag` を使って OpenAPI ドキュメントを生成し、Swagger UI から API を実行できます。

### 1. サーバ起動前の準備

```bash
bundle install                   # 初回セットアップ時、または Gemfile 変更時
bundle exec rails db:prepare     # 初回セットアップ時、または DB 定義変更時
```

### 2. OpenAPI ファイルを再生成（任意。API 仕様を変更したとき）

```bash
# test DB に接続できる状態で実行
bin/rake rswag:specs:swaggerize
```

`swagger/v1/swagger.yaml` は初期ファイルを同梱しているため、再生成しなくても `/api-docs` は表示できます。

### 3. Rails サーバ起動

```bash
bundle exec rails server
```

Swagger UI:

- `http://localhost:3000/api-docs`

### 4. 動作確認用エンドポイント

- `GET /api/v1/health`

Swagger UI 上で `Try it out` を押すと、レスポンスとして以下が返ります。

```json
{
  "status": "ok"
}
```

## GitHub Actions 相当をローカルで確認する

GitHub Actions の `scan_ruby` / `lint` / `test` は、ローカルでも個別に確認できます。

### 1. 事前準備

```bash
bundle install                   # 初回セットアップ時、または Gemfile 変更時
bundle exec rails db:prepare     # 初回セットアップ時、または DB 定義変更時
```

`config/database.yml` のデフォルトは `127.0.0.1:3307` です。別ポートや別ユーザーを使う場合は `DB_HOST` / `DB_PORT` / `DB_USERNAME` / `DB_PASSWORD` を指定してください。

### 2. セキュリティチェック

```bash
bin/brakeman --no-pager
bin/bundler-audit
```

`bin/bundler-audit` は初回実行時に advisory DB をダウンロードします。

### 3. Lint

```bash
bin/rubocop
```

### 4. テスト

```bash
RAILS_ENV=test bundle exec rails db:prepare
RAILS_ENV=test bundle exec rspec
```

`RAILS_ENV=test bundle exec rails db:prepare` は、初回の test DB 作成時と test 用の DB 定義変更時に実行してください。

GitHub Actions の `test` ジョブと同じ接続先で確認したい場合は、環境変数を付けて実行します。

```bash
RAILS_ENV=test DB_HOST=127.0.0.1 DB_PORT=3306 DB_USERNAME=app_user DB_PASSWORD=app_pass bundle exec rails db:prepare
RAILS_ENV=test DB_HOST=127.0.0.1 DB_PORT=3306 DB_USERNAME=app_user DB_PASSWORD=app_pass bundle exec rspec
```
