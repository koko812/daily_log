## セッションまとめ
### 1. 話題の流れ
1. **適応的温度スケーリング (ATS)** － 既存 TS の限界と Zhou et al. (2023, ICLR) のトークン別温度学習  
2. **コントラストデコーディング & 協調生成** － Li et al. (2022, NeurIPS) → 共同草稿検証型 (CoSD, Speculative Ensemble)  
3. **ビーム探索の拡張** － Dynamic-Width Spec Beam (AAAI 25) / Ensemble Beam Search (NAACL 25) / EBBS (Zero-shot MT)  
4. **多モデル協調＋校正** － Collab (Mixture of Agents) と GETS / ACE / APRICOT による信頼度強化  
5. **構造化 & 木探索** － GSD・DySpec・SpecInfer と **Token-level MCTS 系**（Reward Transformer, SC-MCTS*, SEM-CTRL, etc.）  
6. **パス合流・辞書差吸収** － BeamAggR, Token-level Ensembling, CharED で重複統合・語彙不整合を解決

### 2. 議論が膨らんだ話題
| トピック | ポイント |
|----------|----------|
| **異構造モデルの Speculative Decoding** | Draft ↔ Verifier を交替、アンサンブル分布で検証（Speculative Ensemble / CoS） |
| **Graph/DAG でのドラフト合流** | GSD のノード合流・DySpec の動的ツリー・SpecInfer のツリー検証 |
| **Token-level MCTS** | Reward Transformer による高速価値推定、SEM-CTRL の意味制約、SC-MCTS* の対比報酬 |
| **ゼロショット翻訳 EBBS** | Bi-Level ビームで soft voting、文字列再トークナイズで語彙差解消 |
| **温度スケーリングのアンサンブル応用** | GETS (GNN) と ACE (画像) を LLM 協調生成へ転用するアイデア |

### 3. 論文リスト（漏れなく列挙）
| タイトル | 年/会議 | 1-2行要約 |
|---|---|---|
| Calibrating Language Models with Adaptive Temperature Scaling | 2023 ICLR | Hidden state→温度予測ヘッドでトークン別温度を学習し ECE を大幅低減 |
| Contrastive Decoding: Open-ended Text Generation as Optimization | 2022 NeurIPS | 条件付き LM と無条件 LM の確率差でスコアし冗長な定型句を抑制 |
| Speculate, then Collaborate: Fusing Knowledge of LMs during Decoding (CoSD) | 2025 ICLR | Draft+Assistant+決定木で知識補完し BLEU +10 % |
| Speculative Ensemble / Collaborative Spec-Decoding (CoS) | 2025 ICML | Draft ↔ 複数 Verifier を交替し 2.2×高速化・品質維持 |
| Dynamic-Width Speculative Beam Decoding for LLM Inference | 2025 AAAI | 森構造ビーム幅を動的調整しメモリ削減と 5-10 %速度向上 |
| EBBS: Bi-Level Beam Search for Zero-Shot MT | 2025 AAAI | モデル別ビーム→soft voting→共通ビームで 62ペア中56ペア BLEU↑ |
| Collab: Controlled Decoding using Mixture of Agents | 2025 ICLR | 長期報酬 Q-関数 + KL 正則化でトークン毎に最適エージェント切替 |
| Graph Ensemble Temperature Scaling (GETS) | 2024 NeurIPS-Workshop | GNNノード単位MoE温度で ECE-25 % |
| Adaptive Calibrator Ensemble (ACE) | 2023 ICCV | 低難度/高難度 2校正器を難易度推定で混合し OOD 校正向上 |
| APRICOT: Calibrating LLMs Using Their Generations Only | 2024 ACL | 質問クラスタ正答率をターゲットに補助モデルでブラックボックス校正 |
| Token-Level MCTS with Reward Transformer for LLM Decoding | 2025 arXiv | Reward-Transformer+Streaming MCTS で Greedy 比 +79 % |
| SC-MCTS*: Interpretable Contrastive MCTS Reasoning | 2024 arXiv | Contrastive reward × UCT で高速・解釈可能推論 |
| SEM-CTRL: Semantically Controlled Token-Level MCTS | 2025 arXiv | 文法/意味制約をMCTSに組込み安全生成 |
| LSR-MCTS: From Token to Line | 2025 arXiv | 行単位コード生成にトークン評価を組み込んだMCTS |
| DySpec: Dynamic Token Tree Speculative Decoding | 2025 ICLR | クエリ適応ツリーで最大9.4×高速化 |
| SpecInfer: Tree-based Speculative Inference and Verification | 2023 NAACL | ドラフトツリー + 並列検証で 2-3×高速化 |
| Graph-Structured Speculative Decoding (GSD) | 2024 ACL-Findings | トークングラフ合流で冗長探索削減・多様性維持 |
| BeamAggR: Beam Aggregation Reasoning | 2024 arXiv | マルチソース推論パスを確率集約し合流 |
| Token-level Ensembling of Models with Different Vocabularies | 2025 arXiv | 文字デコード→確率融合で語彙不整合を解消 |
| CharED: Character-wise Ensemble Decoding | 2024 ICML-WS | 文字単位確率を平均し辞書差を吸収 |
| KCTS: Knowledge-Constrained Tree Search | 2023 EMNLP | 知識整合評価を報酬にトークンMCTSで幻覚抑制 |
| PPL-MCTS: Discriminator-Guided MCTS Decoding | 2021 arXiv | 制約適合度でMCTSを誘導し感情/毒性制御 |
| Ensemble Beam Search (EBS) | 2025 NAACL | Process-reward-guided beam × 複数モデルで数学推論 +3.9 pp |
| Token-Level Ensembling (CharED含む) | 2024-25 | 異語彙協調生成—文字平均・Graphマージなど |

### 4. アプリ / ツールのアイデア
| アイデア | 機能・目的 |
|----------|-----------|
| **Adaptive Ensemble Calibrator** | Draft × Verifier の確率をモデル温度で動的調整し ECE を下げる |
| **Graph-Beam Visualizer** | GSD/DySpec の DAG を可視化し冗長ノード・合流点をリアルタイム表示 |
| **Token-MCTS Playground** | Reward 関数を差し替えて MCTS 生成を試行できる実験 UI |
| **Zero-Shot MT Quick-Distill** | EBBS 出力をワンクリックで蒸留→単一モデル化し推論コスト削減 |

### 5. 特に関心が強かった論文（5本）
1. **Graph-Structured Speculative Decoding (ACL-F-2024)**  
   Draft 候補をトークングラフで結合し、同一ノードを即時マージ。冗長ビームを省きつつ多様性を維持し、従来スペキュレーティブより 1.7–2.0×高速。文字列再トークナイズで異語彙モデルにも拡張可。

2. **EBBS: An Ensemble with Bi-Level Beam Search (AAAI 2025)**  
   モデル別ビームでドラフトを生成し、上位層で soft voting 合流 → 再トークナイズ prefix を各モデルに同期。62 言語ペア中 56 で BLEU 改善、蒸留後も品質維持と推論効率向上を両立。

3. **Token-Level MCTS with Reward Transformer (arXiv 2025)**  
   Reward-Transformer が各トークン列の将来価値を即時推定。Streaming MCTS で価値最大パスを探索しつつ 79 % 以上の出力品質向上。トークン粒度で MCTS を実用化した初の大規模検証。

4. **Collab: Controlled Decoding using Mixture of Agents (ICLR 2025)**  
   複数エージェントの Q-関数を学習し、長期報酬＋KL 正則化でトークン毎に最適モデルを切替。GPT-4 評価で 72 % 勝率向上。動的モデル選択 × 校正の先駆け。

5. **Calibrating LMs with Adaptive Temperature Scaling (ICLR 2023)**  
   LM hidden state→温度を予測する軽量ヘッドを追加し、トークン別に確率スケーリング。ECE を 10–50 % 改善し RLHF 後の過信を緩和。後続研究の温度適応系（GETS, ACE 等）の礎となった。


