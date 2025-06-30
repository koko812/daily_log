# 2025-06-30 Beam-Search & 評価パイプライン強化セッション

## 1. セッションの流れ
| 時間帯 | 主な話題 | 技術キーワード |
|--------|----------|----------------|
| ⏱️ 開始 – Step 0 | 既存 *token-wise dual-model* 実装の要約 | 協調デコード, top-k 融合 |
| Step 1 | ビームサーチ拡張設計 → 関数 `beam_search_dual_model_decode` 提示 | beam_size, log prob, 長さ正規化 |
| Step 2 | Bash スクリプトをビーム版に対応 | `run_beam_search.sh`, `tee` |
| Step 3 | 評価スクリプト (`eval.py`) の言語自動判定を実装 | SacreBLEU, BERTScore, COMET |
| Step 4 | 実行+評価の一括スクリプト作成 | 入出力パス自動生成, ファイル名にパラメータ付与 |
| Step 5 | デバッグ出力の改善（ビームごと top-k / prefix / expanded list） | ログ可視化 |
| Finish | パラメータ別ファイル命名 (`beam4_top4_output.jsonl`) & ログ保存 | reproducibility |

## 2. 議論が膨らんだ話題
1. **ビームスコアの定義**  
   - 候補選択は確率平均、ビーム累積は log prob 加算で安定化  
2. **デバッグ可視化**  
   - Beam × Step の top-k 候補・拡張ビームを階層表示し、`tee` でログ同時保存  
3. **多言語自動判定**  
   - `input_dir` 名から ja/zh を推定し、プロンプト・評価トークナイザを自動切替  
4. **再現性ある実験ディレクトリ**  
   - `beam{B}_top{K}_output.jsonl` 形式でファイルを一意化し、結果衝突を回避  

## 3. 論文・ツールリスト
| # | タイトル | 年・会議 | 1–2行要約 |
|---|----------|---------|-----------|
| 1 | **SacreBLEU: A Standardized BLEU Metric** | 2018, *WMT* | 同一トークナイザを強制し BLEU 再現性問題を解決。CLI & Python API 提供。 |
| 2 | **BERTScore: Evaluating Text Generation with BERT** | 2020, *ICLR* | 事前学習 BERT 埋め込みの類似度で生成文と参照文の意味一致を測定。 |
| 3 | **COMET: Estimating Machine Translation Quality as a Ranking Problem** | 2022, *EMNLP-WMT* | 参照・ソースを利用する回帰+ranking モデルで文レベル翻訳品質を推定。 |
> ※ 本セッションでは上記3本のみ登場。新規論文の紹介はなし。

## 4. アプリ / ツールアイデア
| アイデア | 目的 |
|----------|------|
| 🛠 **run_tokenwise_beam_and_eval.sh** | 翻訳+評価を1コマンド化、言語・パラメータで自動パス生成 |
| 📑 **自動プロンプトプレビュー** | 1行目の `prompt_a / prompt_b` を表示しテンプレ誤りを即確認 |
| 📄 **デバッグログ(+tee)** | 標準出力をリアルタイム表示しつつ `log.txt` に保存、後解析を容易化 |
| 📂 **パラメータ付きファイル命名** | `beam{B}_top{K}_output.jsonl` で実験条件をファイル名に埋め込み |

## 5. ユーザーが特に関心を示した論文 (ベンチマーク系 3本)
1. **SacreBLEU (2018, WMT)**  
   BLEU計算の非再現性問題を解消。今回の ja/zh 評価で `tokenize=ja-mecab` や `zh` を自動切替できる基盤となった。  
2. **BERTScore (2020, ICLR)**  
   トークン一致ではなく意味的一致を測定。multi-metrics 評価パイプラインに不可欠で、長文翻訳の品質確認に活用。  
3. **COMET (2022, EMNLP-WMT)**  
   学習済みモデル `Unbabel/wmt22-comet-da` を呼び出し、GPU バッチ推論で高速文品質推定を実装。本セッションの評価フローの最後を担う。  
4–5. 本セッションで新規論文は登場せず、上述3本が主要参照。代替的に **BLEU** (2002, ACL) と **chrF** (2015, WMT) を指標論文として追記可能だが、重複を避けここでは割愛。

---

