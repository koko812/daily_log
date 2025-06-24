# 2025-06-24 セッションまとめ

## 1. セッションの流れと主要トピック
| 時系列 | トピック | 概要 |
|--------|---------|------|
| 🕒 1 | **Hugging Face 認証トラブル** | private repo 404 → 401 を解決。`read` vs `fine-grained` トークンの違いを整理。 |
| 🕒 2 | **翻訳評価指標のアップデート** | COMET 系列・BARTScore・UniEval・BLEURT から GPT-Eval, MetricX-24, xCOMET まで最新動向をレビュー。 |
| 🕒 3 | **Genesis プロジェクト紹介** | 4D 生成型物理エンジンをオープンソースで公開する大型研究の和訳。 |
| 🕒 4 | **評価集計スクリプト改良** | `mono_oracle` と `ensemble` の結果を結合し、LaTeX 表を自動生成する Python スクリプトをリファクタリング。 |

---

## 2. 深掘りされた話題
| 🔍 話題 | ポイント |
|---------|----------|
| Hugging Face 認証 | トークンの発行・渡し方／CLI バージョン依存／Git LFS 認証など実践的 Tips を共有。 |
| 最新 MT 評価指標 | MetricX-24 と xCOMET など、WMT24 Metrics Shared Task 前後のトレンドを整理。 |
| スクリプト自動化 | 評価結果のマージ & ランク付け → LaTeX 出力までワンショットで行う実装改善。 |

---

## 3. 論文リスト（登場順）  
| タイトル | 年／会議 | 1–2 行要約 |
|----------|---------|-----------|
| **“COMETKiwi: Enhancing Quality Estimation for Machine Translation”** | 2022 ACL | 文・語レベル統合の QE を実現し、参照なしでも高精度を達成。 |
| **“COMET-22: Training Unbabel COMET at Scale”** | 2022 WMT | 大規模データで再学習し、システムレベル DA 相関を更新。 |
| **“COMET-23: Continual Learning for MT Evaluation”** | 2023 WMT | 毎年のデータ追加で性能を維持する CL フレームワーク。 |
| **“BARTScore: Evaluating Generated Text as Text Generation”** | 2022 EMNLP Findings | BART の自己回帰確率で多様な生成タスクを一貫評価。 |
| **“UniEval: A Unified Benchmark of Human Evaluation for Text Generation”** | 2022 ACL | 翻訳・要約・QA を横断する多目的評価モデルを提案。 |
| **“BLEURT: Learning Robust Metrics for Translation”** | 2020 ACL | BERT 微調整により意味合致を数ショットで学習する指標。 |
| **“G-Eval: Conversational GPT for NLG Evaluation”** | 2023 arXiv | GPT-3.5/4 をプロンプト誘導し、fluency・adequacy を直接採点。 |
| **“Demystifying GPT as MT Evaluator”** | 2023 arXiv | GPT-4 評価の再現性とバイアスを実証的に検証。 |
| **“MetricX: Hybrid Reference/Referenceless MT Metric”** | 2024 WMT | mT5 ベースで参照有無両対応、WMT24 で最高相関を記録。 |
| **“xCOMET: Explainable COMET with Error Spans”** | 2023 WMT | COMET を拡張し、誤訳箇所の検出と分類を同時に出力。 |

---

## 4. アプリ／ツールアイデア
| 📱 アイデア | 目的・機能（概要） |
|-------------|--------------------|
| **HF Private Downloader Helper** | トークン生成・検証・CLI/Python API 設定を GUI で支援する小ツール。 |
| **MT Metrics Dashboard** | COMET/BARTScore など複数指標を一括計算し、順位変動を可視化。 |
| **Eval-Merger Script (改良版)** | `mono_oracle` と `ensemble` の JSON をマージし、最高・次点を太字／下線で LaTeX 出力。 |
| **Genesis Playground** | 生成型物理エンジン上でロボットタスクをノーコード試行できる WebUI。 |

---

## 5. 特に関心が高かった論文（5 本詳細）

### 5.1 MetricX-24 (2024, WMT Metrics Task)
ハイブリッド構成（参照あり／なし両対応）の mT5 XL を二段階学習。システム・セグメント両レベルで人手評価と最高相関を示し、リファレンスレス設定でも従来指標を上回った。公開モデルは多言語・高スループットで実運用しやすい。

### 5.2 xCOMET (2023, WMT)
COMET を Explainable に改良し、スコアのみならずエラー範囲とタイプ（語順、誤訳、脱落など）をラベル付け。分析・デバッグ用途で高評価を獲得し、WMT23 以降の QE ツールチェーンに組み込まれつつある。

### 5.3 COMETKiwi (2022, ACL)
品質推定（QE）の教師あり・教師なし双方を高精度化。文レベル DA と語レベルタグ付けを統合し、低リソース言語でも堅牢。大規模公開データセット「Kiwi」も提供し、QE 研究の標準ベンチとなった。

### 5.4 BARTScore (2022, EMNLP Findings)
生成文 ⇒ 入力文 の自己回帰確率を利用して可逆性を測定。翻訳・要約・対話全般に適用可能で、シンプルながら高い人手相関を達成。モデルを差し替えるだけで多言語化できる点も実用的。

### 5.5 G-Eval (2023, arXiv)
大型言語モデル GPT-4 を評価器として活用。高度な推論で流暢性・意味充足度を粒度別に評点し、従来指標を圧倒。ただし再現性問題から WMT 公式では unconstrained 扱いとなり、研究コミュニティで議論が続いている。

---

