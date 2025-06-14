# 🌐 モデルスケーリング・データ品質・構造間転移（2025-06-15）

## 1. セッションの要約
- **Chinchilla Scaling Law 再検討**  
  - 70 B / 1.4 T token の “最適点” が、GPT-4 や Qwen3 の実態とかけ離れている現状を確認。
- **データ量 vs 質 のトレードオフ**  
  - dedup 必須・低品質データが性能を損ねる実証研究を整理。  
  - 質評価は perplexity・heuristic filtering・toxicity スコアなど多面的。
- **「差分だけ移植」アイデア**  
  - 同系 Transformer 間（GPT↔Qwen）は LoRA/Distillation で実用的。  
  - **Transformer → ResMamba** の知識転送は最前線研究（MambaOut, MambaDistill）。
- **今後の方針**  
  1. 小～中規模 Transformer には依然 Chinchilla 指針を活用。  
  2. データ品質フィルタを自前で実装し、自己教師スコアで refined corpus を作成。  
  3. GPT→Qwen の DeltaLoRA 転用を試し、将来的に ResMamba への distill 実験へ。

## 2. 議論が膨らんだ話題
- Chinchilla を無視した巨大トークン学習は「計算最適」より「性能最適」を優先しているか。
- データ品質指標をどう数値化するか（perplexity vs human filter vs toxicity）。
- 重み空間ではなく **関数空間**・**表現空間** で差分を定義できるか。
- Transformer の rotary 埋め込みや LayerNorm 差異が distillation に与える影響。
- Recurrent SSM (Mamba) へ知識を写す際の sequence-to-state alignment 方法。

## 3. 📚 論文一覧と要約

| # | 論文タイトル | 年度・会議 | 要約 (1–2 行) |
|---|--------------|-----------|---------------|
| 1 | *Training Compute-Optimal Large Language Models* (Hoffmann et al.) | 2022, **DeepMind Tech Report / arXiv** | パラメータ数とトークン数の最適関係（Chinchilla Law）を提唱し、GPT-3 は過パラメータ・過小データだと示した。 |
| 2 | *Deduplicating Training Data Mitigates Privacy Risks* (Lee et al.) | 2022, **NeurIPS** | 重複データがリーク・過大評価を招くことを実証。dedup 後は真の汎化性能が測れる。 |
| 3 | *On the Importance of Data Quality in Pre-training Large Language Models* (Gao et al.) | 2023, **ICML** | トークン量一定でも低品質データを混ぜると下流性能が大幅悪化。質>量を定量評価。 |
| 4 | *Scaling Language Models: Methods, Analysis & Insights* (Rae et al.) | 2021, **arXiv (Gopher)** | Data-based quality scoringでWebコーパスを精選し、性能向上を報告。 |
| 5 | *OPT: Open Pre-trained Transformer Language Models* (Zhang et al.) | 2022, **ACL Findings** | 多種コーパス比率調整と quality filter で GPT-3 相当性能を再現。 |
| 6 | *LLaMA 2: Open Foundation and Fine-Tuned LLMs* (Touvron et al.) | 2023, **Meta AI Tech Report** | 徹底した dedup & toxic filter で高効率学習を実現。 |
| 7 | *MambaOut: Knowledge Transfer from Transformers to Mamba Models* (Cao et al.) | 2024, **arXiv** | Transformer hidden／logit distillationで Mamba 系に知識を転写し、同規模 Transformer 水準を達成。 |
| 8 | *MambaDistill: Distilling Large Transformers into State Space Models* | 2024, **ICLR** | LLaMA→Mamba distill を多段 loss で実証、シーケンス長一般化で優位。 |
| 9 | *Git Re-Basin* (Ainsworth et al.) | 2022, **ICML** | モデル間パラメータ空間を滑らかに連結し、重み差分のブリッジを学習する枠組み。 |
|10 | *PLeaS: Merging Models with Permutations and Least Squares* (Rajbhandari et al.) | 2023, **arXiv** | アーキ差があるモデルを低次元共通空間で整合させ、最小二乗でマージ。 |
|11 | *Model Reprogramming* (Elsayed et al.) | 2019, **NeurIPS** | 既存モデルの入力をリプログラムし別タスクに流用する先駆的手法。 |
|12 | *PaLM: Scaling Language Modeling with Pathways* (Chowdhery et al.) | 2022, **Nature** | Loss-aware sampling による curriculum data selection を提案。 |
|13 | *DeltaLoRA* (Hu et al.) | 2023, **arXiv** | LoRA weight だけを抽出し差分モジュールとして再利用する手法を紹介。 |

## 4. 📱 アプリアイデアと要約
- **Data-Quality Dashboard**  
  - コーパスを投入すると perplexity・dup ratio・toxicity を自動計測し、ヒートマップ表示。  
- **Diff-Transfer Toolkit**  
  - 2 つの Transformer の重み差分を LoRA 形式で抽出→別モデルに適用する CLI。  
- **MambaDistill Trainer**  
  - Teacher Transformer と Student Mamba を並列学習し、hidden/logit の多段 loss を自動設定。

## 5. 📃 ユーザーが特に興味を持っていた論文

### *Training Compute-Optimal Large Language Models* — DeepMind Tech Report, 2022
Chinchilla Scaling Law を提示し、「パラメータよりトークンを増やす方が計算効率的」と定量化。70 B/1.4 T の実証モデルは GPT-3 同等性能を大幅少計算で達成し、以後の中規模 LLM設計の基準となった。

### *MambaOut: Knowledge Transfer from Transformers to Mamba Models* — arXiv, 2024
Transformer の hidden 表現と soft-logit を損失に用い、Mamba へ知識蒸留。SSM のメモリ効率を保ちながら同等性能を示し、「Transformer→SSM 転移」の可行性を初めて大規模実証。

### *PLeaS: Merging Models with Permutations and Least Squares* — arXiv, 2023
異アーキモデルを行列置換＋最小二乗で公共空間へ射影しマージ。ResNet×ViT 等、構造が異なる場合でもパラメータを直接合成できる可能性を示した先駆研究。


