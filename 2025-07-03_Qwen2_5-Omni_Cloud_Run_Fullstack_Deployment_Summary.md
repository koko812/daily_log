# Qwen2.5-Omni 音声AIサービスのフルスタック開発とデプロイ

## 1. セッション概要

本セッションは、ユーザーが所有するQwen2.5-Omni-3Bモデルを基盤とした音声フィードバックAIサービスのフルスタック開発とデプロイに焦点を当てました。具体的には、FastAPIバックエンドをGoogle Cloud Run (GPU利用) にデプロイし、そのAPIと連携するReactフロントエンドをFirebase Hostingに公開する一連のプロセスを支援しました。セッションを通じて、Dockerイメージのビルド、GCPのIAM・Artifact Registry・Cloud Run関連のデプロイエラーの解決、Reactアプリケーションの初期セットアップ、Firebase Hostingへのデプロイ、そして認証機能の追加と削除、APIタイムアウト設定、音声ファイルアップロード機能、API応答時間表示など、多岐にわたる技術的な課題に取り組み、デバッグと修正を繰り返しながらシステムを完成させました。

## 2. 論文・技術一覧

### モデル
- **Qwen2.5-Omni-3B**: 音声認識とテキスト生成が可能なマルチモーダル大規模言語モデル。

### ツール・ライブラリ・API・コマンド
- **Docker**: アプリケーションのコンテナ化に使用。
- **FastAPI**: Python製のWebフレームワーク。バックエンドAPIの実装に使用。
- **Cloud Run**: Google Cloud Platformのサーバーレスコンテナ実行環境。GPU (NVIDIA L4) を利用したAIモデルのホスティングに利用。
- **Artifact Registry**: Dockerイメージを保存・管理するGCPサービス。
- **Firebase Hosting**: 静的サイトホスティングサービス。Reactフロントエンドの公開に利用。
- **React**: フロントエンドのユーザーインターフェース構築に使用したJavaScriptライブラリ。
- **Tailwind CSS**: ユーティリティファーストのCSSフレームワーク。Reactアプリケーションのスタイリングに利用。
- **PostCSS**: CSS変換ツール。Tailwind CSSの処理やAutoprefixerの実行に利用。
- **Autoprefixer**: PostCSSプラグイン。CSSにベンダープレフィックスを自動付与。
- **`npx`**: Node.jsパッケージ実行ツール。グローバルインストールなしでCLIツールを実行。
- **`npm`**: Node.jsのパッケージマネージャー。依存関係のインストールと管理。
- **`gcloud` CLI**: Google Cloud Platformのコマンドラインツール。GCPリソースの操作、Cloud Runデプロイに使用。
- **`firebase` CLI**: Firebaseのコマンドラインツール。Firebase Hostingの初期化とデプロイに使用。
- **`MediaRecorder` API**: Webブラウザでマイクからの音声録音に使用。
- **`AbortController`**: `fetch` APIリクエストのタイムアウト処理（キャンセル）に利用。
- **`performance.now()`**: JavaScriptで高精度な時間計測（API応答時間）に利用。
- **`firebase` (JavaScript SDK)**: (議論されたが最終的に削除) Firebase Authenticationなどのクライアントサイド機能。
- **`firebase-admin` (Python SDK)**: (議論されたが最終的に削除) バックエンドでのFirebase IDトークン検証。

## 3. 主な問題とその解決方法

### 3.1. バックエンドDockerビルドと初期デプロイに関する問題
- **問題1: `"/omni_model_inference.py": not found`**
    - **原因**: ユーザーが`docker build`コマンドを`Dockerfile`や対象ファイルが存在しないディレクトリで実行していた。
    - **解決**: `docker build .` を、`Dockerfile`とPythonスクリプトが同階層にある`omni-backend`ディレクトリで実行するよう指示。
- **問題2: `apt-get update` 時のGPGエラーと `exit code: 100`**
    - **原因**: Dockerイメージビルド中の`apt-get update`がUbuntuリポジトリのGPG署名を検証できなかった。一時的なネットワーク問題やコンテナ内キャッシュの破損が考えられた。
    - **解決**: `Dockerfile`に`gnupg`, `ca-certificates`などの必須ツールの事前インストールと、`apt`キャッシュのクリーンアップステップを追加し、`apt-get update`をより堅牢化。

### 3.2. Cloud RunデプロイとGCP権限に関する問題
- **問題3: `PERMISSION_DENIED: Permission 'iam.serviceaccounts.actAs' denied`**
    - **原因**: `gcloud run deploy`実行ユーザー (`kokoko888kokoko888@gmail.com`) が、デプロイ対象のサービスアカウント (`880310653118-compute@developer.gserviceaccount.com`) に対する`サービスアカウントユーザー`ロールを持っていなかった。
    - **解決**: Google Cloud Consoleまたは`gcloud iam service-accounts add-iam-policy-binding`コマンドで、当該ユーザーに`roles/iam.serviceAccountUser`ロールを付与。
- **問題4: `docker push` で `denied: Unauthenticated request`**
    - **原因**:
        1.  Artifact Registryのレポジトリ (`qwen2-audio-repo`) がまだ作成されていなかった。
        2.  レポジトリ作成後もエラーが続いたため、DockerクライアントがGCPの認証情報を正しく使用できていない、または古い認証情報がキャッシュされていた。
    - **解決**:
        1.  `gcloud artifacts repositories create`コマンドでArtifact Registryレポジトリを作成。
        2.  `gcloud auth configure-docker asia-southeast1-docker.pkg.dev`を実行し、DockerクライアントをGCP認証情報と連携させる。必要に応じて`docker logout`も推奨。

### 3.3. フロントエンド開発とデプロイに関する問題
- **問題5: `npx tailwindcss init -p` で `sh: tailwind: command not found`**
    - **原因**:
        1.  初期段階では、`tailwindcss`パッケージが正しくインストールされていないか、`npx`が実行ファイルを見つけられないパスの問題が疑われた。
        2.  後の調査で、`ls -F node_modules/.bin/tailwindcss`がファイル不在を示し、さらに`npm bin`が`Unknown command`と表示されたことから、**Node.js/npmのインストール自体が破損しているか、非常に古いバージョンである**可能性が濃厚となった。
        3.  最終的に、ユーザーの環境で**複数の`tailwindcss`バージョンが競合していた**ことが判明し、片方を削除することで解決した。
    - **解決**:
        1.  `rm -rf node_modules package-lock.json`と`npm cache clean --force`によるクリーンな再インストールを推奨。
        2.  Node.js/npmの完全な再インストール（`nvm`の利用推奨）を提案したが、ユーザーがローカルの競合を特定し解決。
- **問題6: `npm install -g firebase-tools` で `EACCES: permission denied`**
    - **原因**: グローバルな`node_modules`ディレクトリへの書き込み権限がなかった。
    - **解決**: `sudo npm install -g firebase-tools`で管理者権限でインストール。
- **問題7: `firebase init` で `Error: There are no Firebase projects associated with this account.`**
    - **原因**: 既存のGoogle CloudプロジェクトがFirebaseプロジェクトとして有効化されていなかった。
    - **解決**: Firebase Consoleで該当のGoogle CloudプロジェクトをFirebaseプロジェクトとして追加・有効化するよう指示。
- **問題8: Reactアプリが真っ白で `TypeError: null is not iterable`**
    - **原因**: `useState`フックの初期化構文に誤りがあった (`const [state, setState] = null;` のように記述されていた)。
    - **解決**: `const [state, setState] = useState(null);` のように正しい構文に修正。
- **問題9: CORS設定の不一致**
    - **原因**: バックエンドのFastAPIのCORS `origins` リストに、デプロイされたFirebase HostingのURLが正確に記載されていなかった。
    - **解決**: `omni_main.py`の`origins`リストにFirebase HostingのURLを追加し、バックエンドを再デプロイ。

## 4. ユーザーが特に関心を示した話題

- **Docker/GCPデプロイ時のエラー解決**: 特に、原因が複雑な権限エラーや環境設定の問題に対して、ユーザーは粘り強く取り組み、解決策の具体的な手順を繰り返し確認しました。
- **認証機能の要件変更**: アプリケーションのデモ目的から、当初のGoogle認証、メール/パスワード認証、最終的な認証なしへの変更要求は、ユーザーのニーズに合わせた柔軟な対応への強い関心を示しました。
- **APIパフォーマンスとコスト**: ヘルスチェックがCloud RunのGPUインスタンスのスケールダウンに与える影響や、API応答時間の表示機能への関心は、実運用におけるパフォーマンスとコスト効率への意識の高さを示しました。
- **フロントエンドのデバッグ**: ReactのコンパイルエラーやCORSエラーなど、ブラウザでの表示に関わる問題の解決に強い関心がありました。

## 5. 今後の課題・検討ポイント

- **モデルの応答品質向上**: 現在のモデル応答が質問に対して直接的でない場合があるため、より高度なプロンプトエンジニアリングや、必要に応じたモデルのファインチューニングを検討。
- **認証の再検討**: デモ目的で認証を削除したが、本番運用を考慮する場合はFirebase Authentication（メール/パスワード、Googleサインインなど）のような、より堅牢なユーザー管理・認証システムへの再導入を検討。
- **データ永続化**: ユーザーごとのフィードバック履歴などを保存したい場合、Firebase Firestoreなどのデータベース統合を検討し、ユーザー体験を向上させる。
- **UI/UXのさらなる洗練**: デザインの改善、フィードバック表示の強化、音声入力の視覚化など、ユーザー体験を向上させるための機能追加。
- **エラーハンドリングの強化**: ユーザーフレンドリーなエラーメッセージの表示や、リトライメカニズムの導入。
