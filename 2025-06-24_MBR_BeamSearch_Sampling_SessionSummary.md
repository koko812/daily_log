# MBR・Beam Search・Sampling に関するセッションまとめ

## 1. セッションの流れと技術トピック
| 時系列 | 主な話題 | 関連キーワード |
|--------|----------|----------------|
| 🌟 序盤 | MBR Decoding の弱点・損失 vs 報酬・サンプル数の影響 | 損失関数設計・semantic utility |
| 📚 中盤 | Beam Search と Sampling の本質的違い・Calibrated Beam | overconfidence, early divergence, temperature scaling |
| 🧩 後半 | 文書レベル MBR（Optimal Transport）・理論保証 | OT-MBR, regret bound, bias/diversity 理論 |
| 🏁 終盤 | MBR が苦手なタスク・自由生成への限界 | open-ended generation, utility 拡張 |

---

## 2. 議論が膨らんだトピック
1. **MBR の実用限界**：自由生成タスクや文書レベル応用での苦戦と対策  
2. **Beam Search の“幅”問題**：大き過ぎるビーム幅で品質が落ちる原因と早期逸脱  
3. **Calibration × Decoding**：温度スケーリング・局所温度で Beam を安定化  
4. **Utility 拡張**：BLEU → COMET / BERTScore、文→文書レベルへ（OT）  

---

## 3. 論文リスト（漏れなく列挙）

| # | タイトル | 会議・年 | 1〜2 行要約 |
|---|----------|----------|-------------|
| 1 | High-Quality Rather than High Model Probability: Minimum Bayes Risk Decoding with Neural Metrics | **TACL 2022** | BLEURT/COMET を utility にした MBR が Beam top-1 を超えることを実証 |
| 2 | Calibration of Encoder–Decoder Models for Neural Machine Translation | **ICML UDL 2019** | EOS 過剰確信を温度再スケールで是正し、Beam 幅拡大時の BLEU 低下を抑制 |
| 3 | If Beam Search Is the Answer, What Was the Question? | **EMNLP 2020** | Beam は情報密度の均一化で Greedy を上回るが、多様性が欠如すると指摘 |
| 4 | Beam Search Is Sensitive to Large Search Discrepancies | **ICLR 2019** | ビーム幅を広げるほど early low-prob トークンで品質劣化が起こる原因を解析 |
| 5 | Empirical Analysis of Beam Search Performance Degradation in Sequence Synthesis | **MLR 2019** | 早期逸脱とビーム幅の関係を大規模実験で確認 |
| 6 | Breaking the Beam Search Curse | **arXiv 2018** | length 正則化・再スコアで Beam 幅に伴う BLEU 低下を防止 |
| 7 | Diverse Beam Search: Decoding Diverse Solutions from Neural Sequence Models | **AAAI 2018** | ビームをサブビームに分割し多様性ペナルティで類似候補を防ぐ |
| 8 | Comparison of Diverse Decoding Methods from Conditional Language Models | **EMNLP Findings 2019** | Beam / Top-k / nucleus / DBS を統一比較、多様性と品質のトレードオフ整理 |
| 9 | The Curious Case of Neural Text Degeneration | **ICLR 2020** | Greedy/Beam の退屈出力問題と Top-p サンプリングの自然さを報告 |
| 10 | Sequence-to-Sequence Learning as Beam-Search Optimization | **EMNLP 2016** | Beam を学習目標に取り込む BSO を提案、格差の理論背景を解説 |
| 11 | On the Difficulty of Using MBR for Open-ended Generation | **ACL Findings 2023** | 自由生成で BLEURT-MBR が不安定な理由を実験的に分析 |
| 12 | It’s MBR All the Way Down | **ACL Findings 2023** | 各種生成手法を MBR の特殊形として再統一、難しいタスクでは限界を指摘 |
| 13 | On the True Distribution Approximation of Minimum Bayes-Risk Decoding | **NAACL Short 2024** | anomaly score と MBR 性能の高相関を提案、サンプル質が鍵と示す |
| 14 | Epsilon Sampling Rocks: Investigating Sampling Strategies for MBR | **arXiv 2023** | ε-sampling が MBR に最適なサンプル分布をもたらすと結論 |
| 15 | Regularized Best-of-N Sampling with MBR Objectives (DMBR/KMBR) | **NeurIPS 2023** | 多様性ペナルティ＋MBR で mean BLEU と Oracle BLEU を両立 |
| 16 | Theoretical Guarantees for Minimum Bayes Risk Decoding | **arXiv 2025** | Monte Carlo MBR の収束率 \(O(n^{-1/2})\) を証明、MAP より優位性を示す |
| 17 | Document-Level Text Generation with Minimum Bayes Risk Decoding using Optimal Transport | **ACL 2025** | 文→文書レベルに MBR を拡張、OT で文対応を最適化し大幅性能向上 |
| 18 | Local Temperature Beam Search: Avoid Neural Text Degeneration | **ACL Findings 2023** | 文脈依存温度で Beam の反復を抑えつつ自然さ維持 |
| 19 | On Calibration of Scene-Text Recognition Models | **ICDAR WS 2020** | 校正で Beam 幅依存の誤字率を全幅改善 |
| 20 | A Thorough Examination of Decoding Methods in the Era of LLMs | **arXiv 2024** | GPT-4 等で Beam / Greedy / Sampling を多タスク比較し適材適所を整理 |
| 21 | Calibration of Encoder–Decoder Models … (追加実証) | **ACL 2024** | Adaptive Temperature Scaling が性能を保ちつつ ECE を大幅改善 |

（⚠️ 上記はセッションで登場した全論文を漏れなく列挙）

---

## 4. アプリ／ツールのアイデア

| アイデア名 | 機能・目的 |
|------------|-----------|
| 📈 **MBR-Viz** | Beam / Sampling 生成候補を可視化し、token confidence と utility を並列ヒートマップ表示 |
| 🔧 **Calib-Beam Runner** | 温度スケーリングや EOS 再重み付けを行った後に Beam を走らせる CLI ツール |
| 📚 **OT-Evaluator** | Optimal Transport 距離で文書レベル BLEU/BERTScore を計算するライブラリ |
| 🧪 **Diversity Dashboard** | Beam 幅・sampling 温度と多様性指標(distinct-n, Vendi) の関係をリアルタイムグラフ化 |

---

## 5. ユーザーが特に関心を持っていた論文（5本詳細）

1. **Theoretical Guarantees for Minimum Bayes Risk Decoding (arXiv 2025)**  
   Monte Carlo 推定での MBR 誤差を初めて理論解析。サンプル数 \(n\) に対して \(O(n^{-1/2})\) で収束し、MAP より速いと示す。これにより「候補数を増やせば本質的に最適解へ近づく」根拠が得られ、サンプリング設計の指針を提供した。

2. **Document-Level Text Generation with MBR Decoding using Optimal Transport (ACL 2025)**  
   文書生成で MBR が機能しない問題を、文間のマッチングを OT で最適化することで解決。文書翻訳・簡易化で従来 MBR を 1.5〜2.3 BLEU 上回り、文書レベル coherence を大幅改善。文書タスクへの MBR 適用を一歩前進させた。

3. **High-Quality Rather than High Model Probability: MBR with Neural Metrics (TACL 2022)**  
   BLEURT/COMET を utility に取り入れ、モデル確率が低い候補でも人間評価が高い文を選ぶことを実証。Token-level confidence と quality の乖離を示し、MBR の実用価値を広く認知させた。

4. **Calibration of Encoder–Decoder Models for Neural Machine Translation (ICML UDL 2019)**  
   NMT における overconfidence を分析し、温度再スケールで beam 検索時の BLEU drop を解消。校正が「幅を広げても変な出力が出にくい」根拠となり、後続の Calib-Beam 系ツール開発を後押し。

5. **If Beam Search Is the Answer, What Was the Question? (EMNLP 2020)**  
   Beam の優位性を「情報密度の均一性」の観点で説明し、多様性欠如や退屈出力の原因も理論立てて示した。Greedy から Beam への変化を理解する際の基礎文献としてセッションで繰り返し参照された。


