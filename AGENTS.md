# AGENTS.md

このファイルは、このリポジトリで作業するエージェント向けの作業指針です。

## Project Overview

- プロダクト名: よかスナップ
- 目的: 福岡の「写真・動画を撮りたくなる場所」を写真、タグ、エリアから探せる投稿型サービスを作る
- MVP の主眼: 写真一覧、タグ、エリア、投稿、いいね、行きたい保存、管理者による非公開対応の検証
- 主要資料:
  - `docs/yoka-snap-prd.md`
  - `docs/ui-images/README.md`
  - `docs/ui-images/*.png`
  - `docs/ui-images/*.svg`

## Source Of Truth

- 要件判断では `docs/yoka-snap-prd.md` を最優先する。
- 画面構成や見た目の方向性は `docs/ui-images/README.md` と各 UI モックを参照する。
- `.agents/subagents/ui-designer.md` は UI/UX 検討、画面レビュー、Rails view 実装方針の補助コンテキストとして使う。
- PRD と実装が食い違う場合は、勝手に仕様を広げず、MVP に必要な最小範囲へ寄せる。

## Planned Stack

- Rails フルスタック構成
- SQLite
- Active Storage
- Rails auth generator による email + password 認証
- 地図 API、OAuth、SNS 連携、動画アップロード、通知、コメント、フォロー、ランキングは MVP 対象外

## Product Scope

MVP で実装する主な画面:

- トップ / 投稿一覧
- 投稿詳細
- 投稿作成
- ログイン
- マイページ
- 行きたい一覧
- 管理画面

MVP で優先する機能:

- 公開投稿の新着一覧
- タグ絞り込み
- エリア絞り込み
- 投稿画像アップロード
- 投稿詳細表示
- いいね / 解除
- 行きたい保存 / 解除
- ログイン必須操作の制御
- 管理者による投稿の非公開化

MVP で実装しないもの:

- 地図表示
- 地図上での場所指定
- Google / X / Apple ログイン
- コメント、フォロー、DM、通知
- ランキング、レコメンド
- Instagram / TikTok 連携
- 動画アップロード
- 課金、広告、フォトコンテスト

## Domain Guidelines

- 一般ユーザーには `published` の投稿だけを表示する。
- 投稿ステータスは PRD の `draft / published / hidden / rejected` を基本にする。
- MVP では、投稿は原則 `published` で作成し、管理者が必要に応じて `hidden` にできる形でよい。
- 投稿、いいね、行きたいはログイン必須にする。
- 閲覧はログイン不要にする。
- 同じユーザーが同じ投稿に複数回いいね、または複数回行きたい保存できないようにする。
- 撮影禁止場所、私有地、人物写り込み、迷惑行為につながる投稿への注意導線を投稿作成と管理画面で扱う。

## Data Model Direction

PRD のデータ設計を基本にする。

- `users`: name, avatar, email, password_digest, role
- `posts`: user, title, description, area, address, recommended_time, status
- `tags`: name, slug
- `post_tags`: post と tag の中間テーブル
- `reactions`: user, post, reaction_type

`reaction_type` は `like` と `want_to_go` を基本にする。必要以上にテーブルや概念を増やさない。

## UI Guidelines

- スマートフォン最優先で設計する。
- 写真を主役にし、スポット名、エリア、タグ、いいね数、行きたい数で素早く判断できるようにする。
- 観光サイト風の長い説明より、投稿を探す、見る、保存する、投稿する体験を優先する。
- 投稿、いいね、行きたい、ログイン状態に応じた導線は見つけやすくする。
- 福岡らしい文言は活かすが、操作 UI はシンプルに保つ。
- 初期の色やトーンは UI モックに合わせる。
  - ベース: 明るい生成り、淡いグリーン系
  - 主色: `#2f6b4f`, `#24513c`
  - アクセント: `#ba5e4a`
- UI を変更するときは、モバイル幅で文字あふれや要素の重なりがないか確認する。

## Implementation Guidelines

- Rails 標準の慣習に沿い、過剰な抽象化を避ける。
- 仕様が曖昧な場合は、PRD の MVP 範囲に収まる最小実装を選ぶ。
- まずローカルプロトタイプとして動くことを重視する。
- 本番向けの PostgreSQL、S3、外部地図 API などは後続フェーズまで導入しない。
- 画像アップロードは Active Storage を使う。
- 管理画面は管理者権限で保護する。
- 投稿一覧の画像はサムネイル表示を前提にし、一覧表示が重くならないようにする。
- UI 文言は日本語を基本にする。

## Testing Guidelines

- モデル制約、スコープ、認可、ログイン必須操作を重点的にテストする。
- いいねと行きたいは重複作成できないこと、解除できることを確認する。
- 一般ユーザーに `hidden` 投稿が表示されないことを確認する。
- 管理者以外が管理画面へアクセスできないことを確認する。
- 画面実装では、主要導線がスマートフォン幅で使えることを確認する。

## Branch Rules

- ブランチ名は `<type>/<short-description>` を基本にする。
- `<short-description>` は英小文字、数字、ハイフンを使い、内容が分かる短い名前にする。
- 主な `<type>`:
  - `feat/`: 新機能追加
  - `fix/`: 不具合修正
  - `hotfix/`: 緊急修正
  - `chore/`: 依存関係更新、設定変更、雑務
  - `docs/`: ドキュメントのみの変更
  - `test/`: テスト追加、テスト修正
  - `refactor/`: 振る舞いを変えない整理、設計改善
- 例: `feat/post-upload`, `fix/hidden-post-filter`, `hotfix/admin-access`, `chore/update-rails-config`

## Working Rules

- 既存のドキュメント、UI モック、生成スクリプトを不要に書き換えない。
- 大きな仕様追加は、PRD の今後の検討事項に該当するか確認してから行う。
- `.DS_Store` など作業環境由来のファイルは触らない。
- 作業後は、変更したファイルと実行した確認コマンドを簡潔に報告する。
