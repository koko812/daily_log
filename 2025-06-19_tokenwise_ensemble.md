# 2025-06-19 Token-wise Dual-Model Fusion & Ensemble Decoding

## 1. セッションの要約（時系列 × 技術トピック）

| 時間軸 | 主な出来事・技術トピック |
|--------|--------------------------|
| 🔰 **導入** | 2 モデル翻訳デコーダを作る方針を共有（llm-jp v3 & Qwen3）。<br>→ Beam Search Runner を単一モデル→多モデルへ改修。 |
| 🏗 **基盤実装** | *token-wise decoding*：両モデルの top-k から同一トークンを選び、確率最大のものを採用。<br>→ JSONL へ `decoded/trace` 保存。 |
| 🎨 **可視化** | matplotlib ➜ 横バー表示 → 読みにくさを解決するため HTML カラーチップ版を提案・実装。 |
| ⚖ **融合アルゴリズム拡張** | 共通トークンは平均、片方のみは ½ 重みで線形合成。<br>→ EOS (`</s>`, `<|im_end|>`) は重み1.0として優先停止。 |
| 🛑 **EOS & ループ対策** | `skip_special_tokens=False` で特殊トークンも検出、EOS 出力で確実に終了。<br>→ 同一トークン連打ループを防止。 |
| 📊 **トレース改善** | `token/score/token_id/モデル名` を全てログに残し、可視化の詳細度向上。 |
| ✅ **検証 & 保存** | WMT24 en-ja データで動作確認。<br>`results/wmt24/ensemble/...tokenwise_linear__*.jsonl` に保存完了。 |

---

## 2. 議論が膨らんだ話題

| トピック | 深掘りポイント | 関心度 |
|----------|----------------|--------|
| Token-wise Dual-Model Decoding | 逐次融合の設計・停止条件・可視化 | ⭐⭐⭐⭐⭐ |
| 確率線形合成 vs. 共通優先 | 重み設計・片方のみの罰則・EOS 割増 | ⭐⭐⭐⭐ |
| トレース可視化 | matplotlib → HTML への発展、色分け・ツールチップ | ⭐⭐⭐⭐ |
| Self-Consistency / Ensemble MBR | 単一モデル自己検証 vs. 多モデル協調の汎用性比較 | ⭐⭐⭐ |
| 翻訳タスク以外への一般化 | QA, summarization への応用可否 | ⭐⭐⭐ |

---

## 3. 論文リスト（セッション登場順）

| # | タイトル | 会議・年 | 1-2 行要約 |
|---|----------|---------|-----------|
| 1 | **Investigating the Effectiveness of Multiple Expert Models Collaboration** | *Findings of EMNLP 2023* | 翻訳・QAで多数モデルを協調させる際のスコア融合・投票法を実験比較。 |
| 2 | **Speculative Ensemble: Fast Large Language Model Ensemble via Speculation** | *arXiv 2024* | 先読みトークンを小モデルで生成→大モデルで検証することでアンサンブルを高速化。 |
| 3 | **CharED: Character-wise Ensemble Decoding for Large Language Models** | *ACL 2024* | 文単位でなく **文字単位** の投票により日本語など多粒度言語で BLEU 向上を報告。 |
| 4 | **Self-Consistency Improves Chain-of-Thought Reasoning in LLMs** | *ICLR 2023* | CoT 生成を多数サンプルし投票で最終解を決定、単一モデル性能を底上げ。|
| 5 | **MBR-NMT: Minimum Bayes-Risk Decoding for Neural Machine Translation** | *EMNLP 2021* | 複数翻訳候補を期待損失最小化で選択、BLEU 改善。<br>（トピック比較用に参照） |

> **★ = 本セッションで特に深掘り**  
> ★1, ★2, ★3 は詳細議論あり。Self-Consistency は比較対象として触れた。

---

## 4. アプリアイデア & ツールまとめ

| 🆔 | アイデア / ツール | 目的・機能 |
|----|-------------------|-----------|
| 📱 **Tokenwise Fusion Decoder** | 2 モデル top-k を逐次融合し高品質翻訳を生成。 |
| 📄 **JSONL Trace Logger** | `token/source/score/id` を逐ステップ保存し解析容易化。 |
| 🖼 **Bar-Trace Visualizer** | Matplotlib 横バーで a/b/both を色分け表示。 |
| 🌐 **HTML Interactive Trace** | カラーチップ＋ツールチップでトークン情報を即時確認。 |
| ⚙ **Linear Score Mixer** | 共通=平均、単独=½重み、EOS=1.0 で Score を合成するクラス。 |

---

## 5. ユーザーが特に関心を持っていた論文 5 本

### 1. Investigating the Effectiveness of Multiple Expert Models Collaboration (Findings of EMNLP 2023)
複数専門モデルを協調させる際の重み付け、投票法、信頼度推定を大規模に比較。翻訳・QA 両タスクで **simple voting が意外に強い**ことや、スコア正規化の重要性を示し、今回の token-wise 研究の直接的動機となった。

### 2. Speculative Ensemble: Fast Large Language Model Ensemble via Speculation (arXiv 2024)
小モデルが “推測” でトークンを一括生成し、大モデルが高速にフィルタする枠組み。アンサンブルでも同一発想が適用可能で、**速度と品質のトレードオフ最適化**に貢献。ユーザーは token-wise 実装へ応用可否を議論。

### 3. CharED: Character-wise Ensemble Decoding for Large Language Models (ACL 2024)
日本語・中国語など形態素境界が曖昧な言語で、**文字単位** 投票を導入。BLEU+1.8 を報告し、本セッションの「token 粒度を変えた融合」への示唆を提供。

### 4. Self-Consistency Improves Chain-of-Thought Reasoning (ICLR 2023)
LLM の思考多様性を利用し、複数 CoT を投票して誤りを削減。今回は「単一 vs 複数モデル」の対比として引用され、**後検証型（post-edit）戦略**の候補として注目された。

### 5. MBR-NMT: Minimum Bayes-Risk Decoding for Neural Machine Translation (EMNLP 2021)
候補集合の期待損失を最小化する古典的手法を NMT 時代に適用。token-wise 融合との比較・評価指標議論でしばしば参照され、**確率的選択基準**の基盤として重視された。

