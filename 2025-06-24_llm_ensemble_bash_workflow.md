# 2025-06-24 セッションまとめ

## 1. セッション全体の流れ
| 時間帯 | 主なトピック | 技術・コマンド |
|--------|--------------|----------------|
| 前半   | 🔗 **LLMアンサンブル研究**<br>・プロセス/トークン/出力レベルの比較<br>・多言語対応と語彙整合手法 | 論文レビュー（LE-MCTS, EVA, DeePEn…） |
| 中盤   | 🛠 **翻訳結果の比較スクリプト作成**<br>・`jq` と `sed/awk` で JSONL 抽出<br>・ディレクトリ名/翻訳文のワンライナー表示 | Bash ワンライナー・改良版スクリプト |
| 後半   | ⚙ **vLLM グリッドサーチ & ロギング**<br>・`temperature × top-p` で自動デコード<br>・CUDA Graph ウォームアップの挙動把握 | grid-search.sh 改良（既存出力なら skip） |
| 終盤   | 🧹 **スクリプト微調整**<br>・除外ディレクトリ指定<br>・引数で行番号を指定<br>・source 文を 1 回だけ表示 | `set -eux` バッチスクリプト |

---

## 2. 深掘りされた話題
### 🔍 LLM アンサンブルの粒度
- **プロセスレベル (LE-MCTS)** vs **トークンレベル (EVA, DeePEn, UniTE)** vs **出力レベル (BoE, Blender)**
- 語彙整合が必要な場面・CUDA Graph 最適化との相互作用も議論
### 🛠 Bash × jq での JSONL 操作
- `sed -n "${N}p"` で行指定抽出 → `jq -r .hypothesis[0]`
- 先頭 source を1回だけ表示するロジック
### ⚡ vLLM 初期化ログの意味
- CUDA Graph capturing とメモリ使用量
- サーバ並列起動 (`--num_vllm_servers 4`) による複数回ログ

---

## 3. 論文リスト 📚
| # | 論文タイトル | 会議・年 | 1-2行要約 |
|---|--------------|----------|-----------|
| 1 | **Ensembling Large Language Models with Process Reward-Guided Tree Search** | NAACL 2025 | MCTS + PRM で複数 LLM の推論過程をエンセンブルし，複雑推論性能を大幅改善。 |
| 2 | **LLM-Blender: Ensembling Large Language Models with Pairwise Ranking and Generative Fusion** | ACL 2023 | PairRanker と GenFuser により出力をランク付け・融合する出力レベル手法。 |
| 3 | **EVA: Bridging the Gap between Different Vocabularies for LLM Ensemble** | NAACL 2024 | 語彙アライメント行列で logits を統合するトークンレベルエンセンブル。 |
| 4 | **Rethinking Mixture-of-Agents** | arXiv 2025 | 異種 LLM 混合の効果と限界を分析，Self-MoA を提案。 |
| 5 | **Token-level Ensembling of Models with Different Vocabularies** | arXiv 2025 | 表層文字列一致だけでトークン融合を実現，推論時のみで動作。 |
| 6 | **DeePEn: Ensemble Learning for Heterogeneous Large LMs** | NeurIPS 2024 | 相対表現空間で語彙差を吸収し，多様モデルの logit を結合。 |
| 7 | **UniTE: Determine-Then-Ensemble** | ICLR 2025 | Top-k トークン集合のみで軽量統合，語彙整合コストを最小化。 |
| 8 | **UnifyVocab: Unifying Vocabulary of LLM** | ICLR 2025 | 埋め込み類似度で 1:1 マッピングし，多言語語彙を一括置換。 |
| 9 | **TokAlign: Efficient Vocabulary Adaptation via Token Alignment** | arXiv 2025 | トークンID対応＋蒸留で多言語語彙を高速適応。 |
|10 | **Breaking the Curse of Multilinguality with Cross-lingual Expert Language Models** | EMNLP 2024 | 言語別エキスパートを Branch-Train-Merge で構築，干渉を回避。 |
|11 | **Massively Multilingual Shallow Fusion with LLMs** | EMNLP 2023 | Sparse-MoE 専門家を推論時に2モデル融合し，多言語 ASR を強化。 |
|12 | **Harnessing Multiple LLMs: A Survey on LLM Ensemble** | arXiv 2025 | アンサンブルの分類と応用例を体系化。 |
|13 | **ProxyLM: Predicting LM Performance on Multilingual Tasks** | NAACL 2025 | モデル選択を性能予測で自動化，off-the-shelf LLM の多言語推論向け。 |

---

## 4. アプリ／ツールアイデア 💡
| アイデア | 目的・機能 |
|----------|-----------|
| **翻訳比較 Bash スクリプト** | 複数モデルの JSONL 出力から指定行を抽出し，ディレクトリ名＋翻訳文を一覧表示・保存。 |
| **Grid-Search Decoding Launcher** | `temperature × top-p` パラメータを自動展開，既存出力があればスキップして効率実行。 |
| **vLLM Warm-up Insight Tool** | CUDA Graph キャプチャ時間とメモリを可視化し，多サーバ構成のボトルネックを分析。 |
| **ディレクトリ名一括リネームワンライナー** | `chatbest` → `chat_best` など文字列置換で実験結果フォルダを統一。 |

---

## 5. ユーザーが特に関心を示した論文（詳細解説） 🔥

1. **Ensembling LLMs with Process Reward-Guided Tree Search** (NAACL 2025)  
   MCTS と PRM 評価を組み合わせ，LLM 各ステップの「過程」を最適化。EBS や BoE より高性能で，数学推論で +3〜4 pp 改善。探索と活用を両立する UCT により，誤った初期ステップからのリカバリが容易。

2. **EVA** (NAACL 2024)  
   モデル間語彙のズレをアラインメント行列で補正し，logits 加重平均を実現。翻訳・QA で高い整合性を示すが，アラインメント誤差が性能低下要因。低資源言語や異種トークナイザ混在環境への応用が議論の中心に。

3. **Token-level Ensembling of Models with Different Vocabularies** (arXiv 2025)  
   表層文字列をキーにして Top-k logit を統合。学習不要で推論時だけ動くため，Bash スクリプトでの軽量実装例とも親和性が高い。Beam Search を採用しない理由も議論し，Greedy + Fusion の実用性を評価。

4. **Breaking the Curse of Multilinguality with Cross-lingual Expert LMs** (EMNLP 2024)  
   言語ごとに専門家モデルを Branch-Train-Merge で構築し，推論時に動的選択。低資源言語で特に効果的。ユーザーの多言語翻訳パイプラインへの統合可能性が話題に。

5. **DeePEn** (NeurIPS 2024)  
   相対埋め込み空間で語彙を整合し，多様な LLM を ensemble。語彙ズレの誤差をベクトル類似度で平滑化できるため，マルチドメイン翻訳や専門用語に強い。ユーザーは vLLM グリッドと組み合わせた活用を検討。

---

