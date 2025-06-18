# 2025-06-18 翻訳実験の評価とMBRデコーディングの検討

---

## 1. セッションの要約（話題の流れ・技術トピックの一覧）

このセッションでは、WMT23翻訳タスクに関する多モデル出力の分析と可視化に取り組んだ。中心となる流れは、翻訳候補から oracle 選択（評価指標ベース）の実装・評価であり、その後、token-wiseなMBR decodingの可能性とその難易度についても議論が展開された。GCPでのアプリ共有作業も挙げられたが、本セッションでは主に研究タスクに集中した。

- ✅ `oracle BLEU/comet などの計算と可視化`
- ✅ `複数モデルからの文選択・評価スクリプト化`
- ✅ `評価済みファイルのスキップ、出力整備`
- ✅ `言語ペアごとのファイル整理 (en-ja など)`
- ✅ `MBR decodingの性能・実装議論`
- ✅ `プロンプトの言語選択と説明抑制の指示文設計`

---

## 2. 議論が膨らんだ話題

### 🔍 Oracle選択と評価指標による性能向上
- 各モデルの出力から BLEU/COMET/BERTScore などで最良文を選ぶことで性能がどれほど上がるかを検証。
- `oracle_final_score_avg` による選択も追加し、評価スクリプトをカスタマイズ。
- COMETなどがBLEUよりも精度向上に貢献しやすいことが判明。

### 🔧 評価スクリプトの改良
- 既に評価済みのファイルを `.summary.json` で判定してスキップ。
- `selected_model` があれば、選ばれた頻度も summary に出力。

### 📁 データ整理と将来拡張
- ファイル名に言語ペアを含める構成から、`wmt23/en-ja/eval/` のように整理。
- 複数言語での比較実験を想定して、混在しない構造に。

### 🤖 MBR decoding とその限界
- token-wise MBR decoding の理論的困難さと、実験面での準備の必要性を議論。
- 当面は確率付き出力を用いて文単位で評価・選択する方針に。

---

## 3. 論文リスト 📚

| タイトル | 会議・年 | 要約 |
|----------|----------|------|
| *Is MAP Decoding All You Need?* | ACL 2020 | MAP decoding の限界を指摘し、MBR decoding によるBLEU/TER改善を報告。 |
| *Understanding Minimum Bayes Risk Decoding in Neural Machine Translation* | ACL Findings 2022 | MBRの理論的分析とCOMETによる選択精度の高さを検証。 |
| *High-Quality Translation by Mining Millions of Parallel Sentences* | TACL 2022 | 大規模な並列コーパスを活用し、MBR reranking による品質向上を実証。 |
| *Selective Pre-Translation for Multilingual Prompting* | ICLR 2024 | 翻訳対象に応じてプロンプト言語を選択し、LLMの翻訳性能を向上させる手法。 |
| *Few-Shot Parameter-Efficient Fine-Tuning is Better and Cheaper than In-Context Learning* | NeurIPS 2022 | 翻訳含む言語タスクで、In-Context Learningより効率的なPEFTを評価。 |

---

## 4. アプリアイデア・ツール設計 💡

| 機能名 | 目的 | 概要 |
|--------|------|------|
| `oracle 選択バッチスクリプト` | 多モデル出力の最良選択 | 指定評価指標で各文に最良モデル出力を選択し、jsonlに記録 |
| `eval.py の自動化` | 翻訳文評価を簡易化 | すでに評価されたファイルをスキップして高速化 |
| `言語ペアディレクトリ整理ツール` | 多言語翻訳データの分離管理 | `en-ja` など言語ペアごとに`eval/`ディレクトリを整理して可視化・再利用性向上 |
| `プロンプトテンプレート生成ツール` | 指示文自動生成 | 翻訳指示と「説明を含めないで」という出力制約を英語でテンプレート化 |

---

## 5. ユーザーが特に関心を持っていた論文（詳細要約）

### 1. *Is MAP Decoding All You Need?* (Eikema & Aziz, ACL 2020)
MAP (Maximum a Posteriori) decoding の限界を強調し、MBR decoding によって BLEU や TER のスコアが安定して改善することを示した論文。モデル出力の多様性を活かすことで、より自然な翻訳選択が可能となることを実証。

### 2. *Understanding Minimum Bayes Risk Decoding in NMT* (Zhou et al., ACL Findings 2022)
MBR decoding の理論的分析と、評価指標の選択（COMET vs BLEU）による性能の違いを定量的に分析。特に COMET など意味ベースの指標がより適した reranking 基準であることを示した。

### 3. *Selective Pre-Translation for Multilingual Prompting* (ICLR 2024)
翻訳タスクでプロンプトの入力言語を動的に切り替えることで、LLMの翻訳性能が向上することを報告。各言語対において最適なプロンプト言語を自動的に選択する方針は、今後の多言語NMT設計に示唆を与える。

### 4. *High-Quality Translation by Mining Millions of Parallel Sentences* (Freitag et al., TACL 2022)
多言語大規模コーパスから高品質な文ペアを抽出し、MBR reranking によって BLEU で最大2.0ポイント以上の向上を報告。データ品質と reranking の連携による翻訳精度改善の重要性を示した。

### 5. *Few-Shot Parameter-Efficient Fine-Tuning is Better and Cheaper than ICL* (NeurIPS 2022)
LLM に対する PEFT (Parameter-Efficient Fine-Tuning) の有効性を、翻訳やQAなどの言語タスクにおいて検証。特に翻訳タスクにおける低リソース領域での有望性を示し、ICL との比較を含めた評価が詳細。


