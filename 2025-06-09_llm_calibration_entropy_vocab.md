# LLMのキャリブレーション・エントロピー・語彙サイズ総覧

## 1. セッションの要約（話題の流れ、登場した技術・論文・今後の方針）
- **MBR Decoding** の数学的保証 → 損失関数依存の限界を議論  
- **キャリブレーション問題** に焦点転換：  
  - Guo et al. (2017) を基礎に LLM 研究を概観  
  - 確信度と正答率の乖離・測定指標 (ECE, NLL) を整理  
- **語彙サイズの影響**：大語彙×小モデルでの過小信頼・メモリ負荷を分析  
- **エントロピー視点**：  
  - Braverman et al. (2020) でエントロピー率上昇と記憶力低下  
  - Entropy-Lens など内部情報流可視化研究を紹介  
- **新規アンサンブル/キャリブレーション手法**  
  - *Token-Level Ensembling Across Vocab Sizes*  
  - *Sample Consistency* による後処理校正  
- **今後の方針**  
  1. 語彙サイズ別の ECE 実測実験を小モデルで実施  
  2. Sample Consistency 指標の実装・可視化ツール化  
  3. エントロピー率と Beam Diversity の関係を検証  

## 2. 議論が膨らんだ話題
- **語彙サイズ×モデル容量**：embedding 行列肥大化と tail-word 学習困難性  
- **エントロピー率と長文劣化**：生成が進むにつれ過信→不確実性増大  
- **キャリブレーション指標の実用性**：ECE のビン依存・NLL とのトレードオフ  
- **アンサンブルの語彙非互換問題**：表層一致ベース合意による解決策  

## 3. 出てきた論文一覧（年度・会議付き／各1-2行要約）
| タイトル | 年・会議 | 要約 |
|---|---|---|
| On Calibration of Modern Neural Networks | 2017 ICML | 深層NNが過信する事実を示し、温度スケーリングで校正可と実証 |
| Calibration of Pre-trained Transformers | 2020 EMNLP Findings | BERT 系でイン/アウトドメイン校正差と温度調整効果を定量化 |
| Calibration, Entropy Rates, and Memory in LMs | 2020 ICML | エントロピー率上昇と記憶減衰を理論・実験で解析し校正劣化を説明 |
| How Can We Know When LMs Know? | 2022 TACL | QA で LLM の確信度-正答率乖離を測定し温度最適化を提案 |
| On the Probability–Quality Paradox | 2022 ACL | 高確率出力が必ずしも高品質でない矛盾を情報理論的に解析 |
| On the Calibration of Large LMs and Alignment | 2023 EMNLP Findings | モデルサイズと RLHF が校正に与える影響を比較 |
| Benchmarking Confidence of LLMs in Medical QA | 2023 JAMA Net Open | 医療QAで複数 LLM の確信度-正答率相関を系統評価 |
| Calibrating LMs with Sample Consistency | 2024 AAAI | 多サンプル一致度で後処理校正、追加学習不要で ECE 改善 |
| Entropy-Lens: Information Signature of Transformers | 2024 ICLR | 層ごとの Shannon エントロピーを可視化し情報流を解析 |
| THERMOMETER: Universal Calibration for LLMs | 2024 ICML(予定) | マッピング関数でマルチタスク校正を実現、追加推論不要 |
| Adaptive Temperature Scaling for LLMs | 2024 arXiv | トークン毎に動的温度を学習し RLHF 後の校正崩れを補正 |
| A Token-Level Decoding Algorithm for Ensembling… | 2025 ARR | 語彙非互換モデルを表層一致でアンサンブルし BLEU/COMET 改善 |

## 4. アプリのアイデア要約
1. **Consistency-Meter**：同入力多サンプル生成→一致度ヒートマップで校正可視化  
2. **Vocab-Aware Ensembler**：異語彙モデルを実行時に統合するデコーダライブラリ  
3. **Entropy-Tracer**：生成トークンごとのエントロピー率をリアルタイム表示し、長文劣化を警告  

## 5. 特に興味を持っていた論文の詳細解説
### Calibration, Entropy Rates, and Memory in LMs (ICML 2020)
- **エントロピー率**を極限理論で定義し、生成が進むと不確実性が上昇し校正悪化することを証明  
- **相互情報量**で LSTM vs Transformer の記憶力差を可視化し、長期依存の課題を定量化  

### Calibrating LMs with Sample Consistency (AAAI 2024)
- **3種の一致度指標**（合意比率・エントロピー・FSD）でモデル信頼度を推定  
- 追加学習不要で GPT-4 など閉源モデルにも適用可能、ECE を最大35%削減  

### A Token-Level Decoding Algorithm for Ensembling… (ARR 2025)
- 異語彙モデルを**表層文字列一致**で合意評価しビーム探索に組込み  
- 学習不要・推論時のみで BLEU +1.5, COMET +0.7 の改善を報告  


