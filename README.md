# よかスナップ

福岡の「写真撮るのによかとこ」を写真、タグ、エリアから探せる Rails プロトタイプです。

## セットアップ

```sh
bin/setup
bin/rails db:seed
```

## 起動

```sh
bin/dev
```

初期データには一般ユーザーと管理者ユーザーが含まれます。

- 一般ユーザー: `user@example.com` / `password`
- 管理者: `admin@example.com` / `password`

## staging / 限定公開環境で Basic 認証を使う

staging やレビュー用の限定公開環境では、以下の環境変数を設定するとアプリ画面に Basic 認証がかかります。

```sh
BASIC_AUTH_ENABLED=true
BASIC_AUTH_USERNAME=your-staging-user
BASIC_AUTH_PASSWORD=your-staging-password
```

`BASIC_AUTH_ENABLED` が未設定、または `false` の場合は Basic 認証を要求しません。

`BASIC_AUTH_USERNAME` と `BASIC_AUTH_PASSWORD` は秘匿値として扱い、リポジトリや README には実際の値を書かないでください。Basic 認証は HTTPS 前提で使います。

ヘルスチェック用の `/up` は Rails 標準の `rails/health#show` にルーティングされ、アプリの `ApplicationController` を通らないため、追加対応なしで Basic 認証の対象外です。

## テスト

```sh
bin/rails test
bin/ci
```

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
