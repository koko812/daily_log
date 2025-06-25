# Physics of Language Models & Solomonoff Induction セッションまとめ

## 1. セッションの要約（時系列）
| 時刻 | 主題 | 概要 |
|------|------|------|
| 🕒 1 | **LLM ≒ Solomonoff Induction** | Wan & Mei (2025) の論文を起点に、ソロモンオフ帰納と LLM 学習の対応を整理。 |
| 🕒 2 | **Solomonoff Induction の歴史と理論** | 1964 年の原論文から AIT・MDL・AIXI まで、理論的背景を総覧。 |
| 🕒 3 | **Physics of Language Models (PoLM) シリーズへ移行** | Part 3.1 → 2.1 → 2.2 → 3.2 → 3.3 → 4.1 と段階的に深掘り。 |
| 🕒 4 | **Part 3.1 Knowledge Storage** | Augmentation が知識抽出に必須＝80–90 % 精度を実証。 |
| 🕒 5 | **Part 2.1 Grade-School Math** | 合成数学データで「隠れ推論」を可視化、V-probing を提案。 |
| 🕒 6 | **Part 2.2 Learn-from-Mistakes** | 誤答＋訂正を pretraining に入れると推論精度↑。 |
| 🕒 7 | **Part 3.2 Knowledge Manipulation** | Retrieval◎／Comparison△／Inverse Search✖—CoT でも改善せず。 |
| 🕒 8 | **Part 3.3 Knowledge Capacity** | 1 パラメータ ≈ 2 bit の知識を格納というスケーリング則を発見。 |
| 🕒 9 | **Part 4.1 Architecture Design** | “Canon” レイヤーを追加し推論深度・知識操作を倍増させる構造を提示。 |

---

## 2. 議論が膨らんだ話題
| トピック | キー論点 | ユーザーの関心度 |
|----------|----------|------------------|
| Augmentation vs. 重複データ | 多様性がなければ知識抽出は向上しない | ⭐⭐⭐ |
| Inverse Search の限界 | CoT でも性能改善せず、構造的対策が必須 | ⭐⭐⭐ |
| 知識容量の測定法 | 3-tuple × 正答率で bit 数換算、2 bit/param 則 | ⭐⭐ |
| Canon レイヤー | 隣接トークン伝播で推論深度 2×、構造汎用性 | ⭐⭐ |

---

## 3. 論文リスト（漏れなく列挙）

| # | タイトル | 会議・年 | 1–2 行要約 |
|---|----------|----------|------------|
| 1 | *A Formal Theory of Inductive Inference I & II* | **Information and Control, 1964** | ソロモンオフ帰納を初めて定式化。あらゆる停止プログラムに \(2^{-|p|}\) で事前を与える万能予測理論。 |
| 2 | *Universal Artificial Intelligence* | **Springer, 2005** | Hutter がソロモンオフ事前を強化し、意思決定モデル AIXI を構築。 |
| 3 | *An Introduction to Kolmogorov Complexity* | **Springer, 2008** | Li & Vitányi による AIT 標準教科書。 |
| 4 | *Large Language Models as Computable Approximations to Solomonoff Induction* | **arXiv, 2025** | LLM の学習をソロモンオフ事前の計算可能近似として定式化。推論も条件付き確率に収束。 |
| 5 | *Physics of LMs: Part 3.1 — Knowledge Storage & Extraction* | **arXiv, 2023** | パラフレーズ増強がないと知識抽出 0 %、10×増強で 80–90 % に急上昇。 |
| 6 | *Physics of LMs: Part 2.1 — Grade-School Math & Hidden Reasoning* | **OpenReview (ICLR 2025)** | iGSM データで GPT-2 をゼロ学習、V-probing が隠れ推論過程を可視化。 |
| 7 | *Physics of LMs: Part 2.2 — Learning from Mistakes* | **ICLR 2025** | 誤答＋訂正を含む pretraining が、同量の正答のみより高精度を達成。 |
| 8 | *Physics of LMs: Part 3.2 — Knowledge Manipulation* | **arXiv, 2024** | Retrieval は◎、Inverse Search は✖。CoT でも後者は改善せず。 |
| 9 | *Physics of LMs: Part 3.3 — Knowledge Capacity Scaling Laws* | **ICLR 2025** | 1 param ≈ 2 bit の知識格納効率を測定し、量子化・MoE など12要因を分析。 |
| 10 | *Physics of LMs: Part 4.1 — Architecture Design & Canon Layers* | **SSRN, 2025** | “Canon” レイヤーを挿入し、推論深度と知識操作性能を倍増。 |

---

## 4. アプリアイデアと要約

| 💡 アイデア | 機能・目的 |
|-------------|-----------|
| Adaptive Augmentor | pretraining データに自動パラフレーズ／翻訳を注入し、知識抽出しやすい表現多様性を確保するツール。 |
| Error-Feedback Trainer | モデルの誤答を即時ラベル付けし、訂正ペアを生成して再学習に組み込むパイプライン。 |
| Knowledge-Bit Meter | 任意モデルの三つ組知識復元率を測定し、パラメータ当たりビット効率を可視化。 |
| Canon-Injector | 既存 Transformer チェックポイントに Canon レイヤーを付加し、推論深度を強化するライブラリ。 |

---

## 5. ユーザーが特に関心を示した論文（5 本詳細）

1. **Large Language Models as Computable Approximations to Solomonoff Induction** (arXiv 2025)  
   LLM の cross-entropy 最小化を「プログラム長最小化＝ソロモンオフ事前近似」と同一視。定理 2–3 で訓練・推論が条件付きアルゴリズム的確率に収束する様子を示し、few-shot 選択戦略まで提案。

2. **PoLM Part 3.1 — Knowledge Storage & Extraction** (arXiv 2023)  
   合成人物データで、パラフレーズ 10×増強が知識の“線形局所エンコード”を生み、抽出精度 0 → 90 % へ激変。増強の質が量より重要であることを実証、実務の pretraining 戦略に大きな示唆。

3. **PoLM Part 3.2 — Knowledge Manipulation** (arXiv 2024)  
   Retrieval は得意だが Inverse Search は壊滅的。CoT も効果薄で、構造的対策（RAG、逆向きデータ）が必要と結論。知識「格納」と「操作」は別スキルであると示した。

4. **PoLM Part 3.3 — Knowledge Capacity Scaling Laws** (ICLR 2025)  
   1 param ≈ 2 bit のスケーリング則を提示し、量子化や MoE など多要因を系統解析。知識容量の“物理定数”を提案し、大規模モデル設計の新たな指標を提供。

5. **PoLM Part 4.1 — Architecture Design & the Magic of Canon Layers** (SSRN 2025)  
   トークン隣接伝播を担う Canon レイヤーを導入し、Transformer・State-space 系で推論深度と知識操作を倍増。構造変更が能力に直結することを定量的に示し、次世代 LLM 設計指針として注目。


