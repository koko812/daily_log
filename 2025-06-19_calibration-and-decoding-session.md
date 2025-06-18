# LLMキャリブレーション & デコーディング徹底議論まとめ

## 1. セッションの要約
- **前半**🧩  
  - ビームサーチ/サンプリング混合法 → 多様性と品質のトレードオフ  
  - Nucleus Sampling・Distinct-n・MBR など多様性指標の基礎整理  
  - FactCC・ハルシネーション検出・GPT-4 判定精度の限界
- **中盤**🔥  
  - **温度スケーリング**と **ECE** の仕組み  
  - Guo et al. (2017) の古典的温度校正 → 翻訳・要約への応用  
  - Adaptive Temperature Scaling（ATS） & APRICOT で token-level 信頼度補正
- **後半**🚀  
  - Calibrated Decoding, Uncertainty-Aware MBR, Value-Aware Sampling など最新論文  
  - 翻訳モデルで BLEU と log-prob の相関を最適化する学習手法  
  - 数学タスクの導出過程評価・誤答検出 AUROC・SymPy 検証

## 2. 議論が膨らんだ話題
| トピック | 深掘りポイント |
|----------|----------------|
| 温度スケーリング vs 多様性 | τ の調整で確信度とBLEUがどう動くか／ECE最小化グリッド探索 |
| Sequence-level Calibration | BLEU/BERTScore と確率のズレ → ECE 置き換え問題 |
| 翻訳モデルの信頼度指標 | Calibrated Decoding・Quality Estimation 併用の是非 |
| 数学CoTの答抽出 | 正規表現＋SymPyで最終答を判定／過程と答の不整合検出 |

## 3. 論文リスト（時系列）
| 論文タイトル | 会議・年 | 1-2行要約 |
|--------------|---------|-----------|
| **“The Curious Case of Neural Text Degeneration”** (ICLR 2020) | top-p (Nucleus) Samplingで高多様性生成を提案。 |
| **“On Calibration of Modern Neural Networks”** (ICML 2017) | 温度スケーリングでECEを大幅削減。キャリブレーション評価を定着させた古典。 |
| **“FUDGE: Controlled Text Generation with Future Discriminators”** (NAACL 2021) | 将来属性を判定する判別器でトークン確率を補正し、制御生成を実現。 |
| **“Direct Preference Optimization”** (arXiv 2023) | 人間選好データでRLHFを単純化するDPO手法を導入。 |
| **“Calibrated Decoding”** (ACL 2023) | BLEUと確率の相関を最大化する温度帯を分析、翻訳品質を向上。 |
| **“Calibrating Translation Decoding with Quality Estimation on LLMs”** (Wu et al., 2025) | QEモデルとの相関学習で確率自体を品質指標に転換、翻訳MAPを改善。 |
| **“Uncertainty-Aware Decoding with Minimum Bayes Risk”** (ICLR 2025) | パラメータ不確実性をMBRに統合し、ハルシネーション抑制を実現。 |
| **“Calibrating Language Models with Adaptive Temperature Scaling”** (ICLR 2024 W) | tokenごとに温度を動的調整し、ECEを最大50 %削減。 |
| **“APRICOT: Calibrating Large Language Models Using Their Generations Only”** (ACL 2024) | LLM出力だけで補助Calibratorを学習し、誤答検出AUROCを0.88に向上。 |
| **“FUDGE, VAS, IPO, IVO, Q-Decoding”** ほか | 各種 value-guided / contrastive / look-ahead デコーディングを紹介・比較。 |

## 4. アプリ／ツールアイデア
| 🔧ツール名 | 機能 | 目的 |
|------------|------|------|
| **Calibration Dashboard** | BLEU・ECE・BERTScoreをリアルタイム可視化 | 翻訳モデルの信頼度モニタリング |
| **ATS Plugin** | トークンごとに τ を補正する後処理ヘッド | RLHFモデルのover-confidence抑制 |
| **MBR Reranker+SymPy** | 多様候補を生成 → 数式検証 & BLEUで再選択 | 数学翻訳／推論の正確出力を保証 |
| **Hallucination Guard** | GPT-4 判定＋FactCCで事実性スコア | 長文要約の誤情報フィルタリング |

## 5. ユーザーが特に関心を示した論文（詳細要約）

### ① “On Calibration of Modern Neural Networks” (ICML 2017)  
Softmax確率が過信になる問題を指摘し、温度スケーリングでECEを最大10分の1に低減。後処理だけで信頼度を補正できる手軽さから、LLM分野の校正研究の出発点となった。開発者必読の古典。

### ② “Calibrated Decoding” (ACL 2023)  
翻訳候補の log-prob と BLEU の相関を分析し、τ=0.9–1.1 が最適と示す。温度調整だけで BLEU+1.5 向上を報告し、確率の信頼度指標化へ道を開いた。翻訳者が注目した実践的研究。

### ③ “Calibrating Language Models with Adaptive Temperature Scaling” (ICLR 2024 Workshop)  
固定τを廃し、トークンごとに温度を予測してスケーリング。RLHF後のモデルでECEを50 %削減しながら性能を維持。実装が公開され、既存LLMにプラグイン的に適用可能な実用度が高い。

### ④ “APRICOT: Calibrating Large Language Models Using Their Generations Only” (ACL 2024)  
LLMの生成テキストだけを使い、クラスタ正解率を教師信号にCalibratorを学習。ブラックボックスAPIにも適用でき、Chain-of-Thought＋自己信頼度でAUROC0.88を達成。誤答フィルタの新潮流。

### ⑤ “Calibrating Translation Decoding with Quality Estimation on LLMs” (2025)  
少量データでlog-probとCOMETのPearson相関を直接最適化。MAPデコーディングの確率をそのまま品質スコアとして利用可能にし、BLEU/COMETを両立。翻訳パイプラインに即投入できる最新手法。

