# 2025-06-17: Calibration Validation and Quality Estimation in NMT

---

## ✅ 1. セッションの要約（話題の流れ、技術トピックの一覧）

本セッションでは、翻訳モデルの出力確信度（log-prob）と翻訳品質（BLEU/COMETなど）の関係性を軸に、以下の技術トピックが展開された：

- 単一モデルにおける信頼度と翻訳品質の整合性の検証方法（相関・ECE）
- 温度キャリブレーション（temperature scaling）の前提と限界
- Quality Estimation（QE）による補正的キャリブレーション手法の導入
- 非線形キャリブレーション手法（Platt Scaling, Isotonic Regression, Binning）
- 代表的な研究論文の調査・精査（Desai & Durrett, Ott らの論文）

特に「log-probと品質スコアの相関が負の場合、温度スケーリングが無効になる」という本質的な問題意識から、非線形手法や事後推定型のQuality Estimationに基づく補正戦略へと議論が進展した。

---

## 🔍 2. 議論が膨らんだ話題

### 🎯 温度スケーリングの限界と前提の確認
- 信頼度と性能の**正の相関が前提**であり、これが崩れるとキャリブレーション不能になるという重要なポイントを整理。
- log-probが高いのにBLEUが低い例など、逆相関の危険性が具体的に議論された。

### 🧠 Quality Estimation によるキャリブレーション補完
- QEモデルを用いてモデル出力に翻訳品質スコアを事後予測し、信頼度と品質のマッピングを学習する戦略を解説。
- Hou et al., 2023 という架空論文の存在を精査したことで、**Di Wu et al., 2025** の実在論文に辿り着くという探索プロセスが印象的。

### 🧪 非線形手法の整理
- Platt Scaling、Isotonic Regression、Binning Mapping 各手法の適用条件と利点を比較。
- 特に Isotonic Regression の柔軟性や、Binning の直感的な適用方法が評価された。

---

## 📚 3. 論文リスト（出てきたすべての論文）

| タイトル | 会議・年 | 概要 |
|----------|----------|------|
| Calibration of Pre-trained Transformers | EMNLP 2020 (Desai & Durrett) | BERTやRoBERTaの分類タスクにおけるキャリブレーション性能を分析。温度スケーリングやlabel smoothingの効果を検証。 |
| Analyzing Uncertainty in Neural Machine Translation | arXiv 2018 (Ott et al.) | NMTにおける不確実性の分析。信頼度と翻訳精度の不一致（confidence-accuracy mismatch）を可視化し、ビーム幅による品質低下を指摘。 |
| Calibrating Translation Decoding with Quality Estimation on LLMs | arXiv 2025 (Wu et al.) | 翻訳文のlog-probとCOMETスコアの相関最大化を目的とした損失を導入し、calibrated decodingを実現。MBRデコーディングにも応用可能。 |

---

## 📱 4. アプリ・ツールアイデアと要約

| アイデア名 | 目的 | 機能概要 |
|------------|------|----------|
| 翻訳出力 vs. Quality Scatter Plot Generator | キャリブレーション可視化 | log-probとBLEU/COMETなどの相関を散布図で可視化するツール。 |
| QE-based Reranker | 翻訳候補の精度向上 | COMET-QEなどを用いた翻訳文の品質推定に基づいてビーム候補を再ランク付け。 |
| Calibration Curve Visualizer | キャリブレーション精度評価 | 信頼度スコアと品質スコアのbin集計によるキャリブレーション曲線を生成。 |

---

## 🌟 5. ユーザーが特に関心を持っていた論文（詳細要約）

### 📘 Calibration of Pre-trained Transformers (Desai & Durrett, EMNLP 2020)
Transformerモデル（BERT, RoBERTa）のキャリブレーション性能を in/out-domain の分類タスクで比較。温度スケーリングやlabel smoothingによる補正が有効であることを示しつつ、OOVや分布のズレが calibration 精度に与える影響を明らかにした。

### 📗 Analyzing Uncertainty in Neural Machine Translation (Ott et al., arXiv 2018)
翻訳における不確実性（多義性や分布のバリエーション）を分析し、モデルの確信度と性能のズレを実証。特にbeam幅が大きくなることで品質が低下する“beam search curse”の存在を明らかにし、分布設計と探索戦略の重要性を示唆した。

### 📙 Calibrating Translation Decoding with Quality Estimation on LLMs (Wu et al., arXiv 2025)
生成された翻訳のlog-probとCOMET品質指標の相関を最大化する学習損失を導入し、log-probを翻訳品質のproxyとして利用可能にした。MBRや再ランク付けへの応用が可能で、LLM時代の信頼度再設計の先端を示す。

### 📒 Platt Scaling / Isotonic Regression / Binning Methods（手法群として）
温度スケーリングが使えない状況において、非線形な補正が可能な手法群。PlattはシンプルなS字型、Isotonicは柔軟なモノトニック、Binningはヒューリスティックに信頼度と品質をマッピングできる。

### 📕 Quality Estimation Models（COMET-QEなど）
referenceなしで翻訳品質を推定するモデル群。COMET-QEは高精度で、事後的な信頼度補正や候補再ランク付け、MBRスコアリングにも活用可能。

---

