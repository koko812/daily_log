# マルチエージェント協調と最新デコーディング手法まとめ（2025-06-20）

## 1. セッションの要約 🚀
- **前半（協調型デコーディング）**  
  - Ensemble Beam Search → Self-Consistency／Contrastive系 → DMoA へと議論が発展。  
  - 一貫性 vs 多様性、速度 vs 品質のトレードオフが主題。  
- **中盤（マルチエージェント協調）**  
  - MacNet・COPPER などで “意図共有／自己反省” を検討。  
  - Shapley値による貢献度評価や MultiAgentBench の限界も議論。  
- **後半（高速化・並列化デコーディング）**  
  - Medusa, SuffixDecoding, AdaDecode など推論高速化手法を列挙。  
  - 2025年登場の LAPS-SD, MagicDec, HeteroSpec など最新 Speculative 系を整理。  
- **終盤（適応協調の可能性）**  
  - タスク依存で協調戦略を変化させる Adaptive / Task-aware アプローチを検討。  
  - 単一LLM多人格 vs 異種LLM混合の構成比較へ発展。

---

## 2. 議論が膨らんだ話題 🔍
| トピック | 主な論点 | 深掘りポイント |
|----------|---------|----------------|
| 協調型デコーディング | EBS と DMoA の比較 | 一貫性指標／ゲーティング機構 |
| マルチエージェント協調 | 役割分担・意図共有 | COPPER の反省ループ，Shapley値 |
| 高速化・並列デコーディング | Medusa, SuffixDecoding | Draft/Verify パイプライン，suffix tree |
| タスク依存適応 | 算術 vs 翻訳 | 協調が効く／効かない条件の整理 |

---

## 3. 論文リスト 📚
| # | タイトル | 年・会議 | 1–2 行要約 |
|---|----------|----------|-------------|
| 1 | Learning to Decode Collaboratively with Multiple Language Models | 2024 ACL | トークンごとに担当 LLM を切替える協調デコーディング。 |
| 2 | Graph-Structured Speculative Decoding | 2024 Findings ACL | 仮説を DAG に統合し高速検証する Speculative 拡張。 |
| 3 | Speculative Ensemble: Fast LLM Ensemble via Speculation | 2025 arXiv | proposer / verifier を交替させる高速アンサンブル。 |
| 4 | Collaborative Decoding via Speculation (CoS) | 2025 ICML | n モデル合同 spec-decoding。 |
| 5 | Ensembling Large Language Models with Process Reward-Guided Beam Search | 2025 NAACL | マルチLLMでビームを合流・分岐し品質向上。 |
| 6 | Self-Consistency Improves Chain of Thought Reasoning | 2022 NeurIPS | 多数決で思考多様性と一貫性を両立。 |
| 7 | Contrastive Decoding: Open-ended Text Generation as Optimization | 2022 NeurIPS | Fluent × Faithful の対比選別。 |
| 8 | Fast Inference from Transformers via Speculative Decoding | 2023 arXiv | 小モデル draft＋大モデル verify による高速化。 |
| 9 | Contrastive Search | 2023 ACL | 多様候補を並列探索＆再評価。 |
| 10 | Tree of Thoughts: Deliberate Problem Solving with LLMs | 2024 ICML | 思考をツリー展開し探索。 |
| 11 | Mixture-of-Agents Enhances Large Language Model Capabilities | 2025 ICLR | DMoA：タスク毎に動的に LLM 混合比を最適化。 |
| 12 | SuffixDecoding: A Model-Free Approach to Speeding Up LLM Inference | 2024 arXiv | suffix tree キャッシュで 2.9× 高速化。 |
| 13 | Mixture of Decoding (MoD) | 2025 arXiv | LVLM 幻覚軽減のため Attention 一貫性でモード切替。 |
| 14 | Active Layer-Contrastive Decoding | 2025 arXiv | 層レベルで contrastive を適用し factuality 改善。 |
| 15 | AdaDecode: Accelerating LLM Decoding with Adaptive Layer Parallelism | 2025 ICML | 中間層予測＋並列補完で 1.7× 高速化。 |
| 16 | Permute-and-Flip: An Optimally Stable and Watermarkable Decoder | 2025 ICLR | 順序ランダム化→Flip で品質と安定性保証。 |
| 17 | Semi-Clairvoyant Scheduling of Speculative Decoding Requests | 2025 arXiv | リクエスト優先度制御でレイテンシ 39% 削減。 |
| 18 | Long-Context Lossless Speculative Decoding (MagicDec) | 2025 arXiv | 階層ドラフタで長文でも品質劣化なし。 |
| 19 | Guided Speculative Inference | 2025 arXiv | 報酬モデルを組み込んだ spec-decoding。 |
| 20 | Unveil Speculative Decoding's Potential for Accelerating Sparse MoE | 2025 arXiv | Sparse-MoE でも spec-decoding を適用可能に。 |
| 21 | HeteroSpec: Leveraging Contextual Heterogeneity for Efficient Speculative Decoding | 2025 arXiv | 文脈 entropy でドラフタ深度を動的決定。 |
| 22 | PipeSpec: Breaking Stage Dependencies in Hierarchical LLM Decoding | 2025 arXiv | 階層パイプライン化で 2.5× 加速。 |
| 23 | ML-SpecQD: Multi-Level Speculative Decoding with Quantized Drafts | 2025 arXiv | 量子化ドラフタ＋多段 spec で 2.7× 加速。 |
| 24 | MetaGPT: Meta Programming for A Multi-Agent Collaborative Framework | 2023 arXiv | 役割分担でソフトウェア開発を自動協調。 |
| 25 | COPPER: Reflective Multi-Agent Collaboration based on LLMs | 2024 NeurIPS | 反省ループで協調推論を強化。 |
| 26 | Scaling LLM-based Multi-Agent Collaboration (MacNet) | 2024 arXiv | 1000+ DAG エージェントで協調スケール。 |
| 27 | Shapley-Coop: Credit Assignment for Emergent Cooperation in Self-Interested LLM Agents | 2025 arXiv | Shapley値で公平な報酬配分を実現。 |
| 28 | Multi-Agent Collaboration Mechanisms: A Survey of LLMs | 2025 arXiv | LLM 協調メカニズムの総合調査。 |
| 29 | Evaluating the Collaboration and Competition of LLM Agents (MultiAgentBench) | 2025 arXiv | 協調・競合タスクの標準ベンチマーク。 |
| 30 | Medusa: Simple LLM Inference Acceleration Framework with Multiple Decoding Heads | 2024 arXiv | 追加ヘッドで並列 draft，最大 3× 加速。 |
| 31 | Skeleton-of-Thought: LLMs Can Do Parallel Decoding | 2023 NeurIPS Wksp | 骨格生成→並列展開で 2.4× 加速。 |
| 32 | Accelerating Transformer Inference for Translation via Parallel Decoding | 2023 ACL | Jacobi 法ベースで翻訳モデルを高速化。 |

---

## 4. アプリ／ツールアイデア 💡
| 名称 | 機能 | 目的 |
|------|------|------|
| **Adaptive-Collab Router** | 入力タスクを自動分類し、最適な協調戦略（EBS, DMoA, 単一モデル等）を動的選択 | タスク依存で推論品質と速度を両立 |
| **Spec-Dash** | Speculative 系手法（Medusa, SuffixDecoding 等）の速度・コストを可視化するダッシュボード | デプロイ時の手法選定を支援 |
| **Agent-Shapley Analyzer** | マルチエージェント出力に Shapley値を計算し、貢献度ヒートマップを生成 | エージェント間バランスの最適化 |

---

## 5. ユーザーが特に関心を持っていた論文（詳細要約） 🔎
1. **Mixture-of-Agents Enhances Large Language Model Capabilities (ICLR 2025)**  
   *複数 LLM の出力を層構造で統合する動的ゲーティングを導入。一貫性スコアを用いてエージェント比率をオンラインで更新し、算術推論では GPT-4 を上回り、翻訳では過剰多様性を抑えて性能維持。SOTA を示しつつタスク依存適応の重要性を実証した。*  

2. **Medusa: Simple LLM Inference Acceleration Framework with Multiple Decoding Heads (arXiv 2024)**  
   *Transformer に複数 Draft Head を増設し、Base-Proposal-Verifier によるツリー生成で一度に複数トークンを検証。追加学習なしでも 2×、fine-tune で最大 3× の加速を達成し、Speculative 系の実装コストを劇的に低減した。*  

3. **Ensembling Large Language Models with Process Reward-Guided Beam Search (NAACL 2025)**  
   *ビームサーチを複数 LLM に並列展開し、プロセス報酬モデルで候補をスコア共有。ビームの合流／分岐を動的管理し、探索多様性と一貫性を兼備。数学・推論ベンチで単一モデルを大幅に上回った。*  

4. **SuffixDecoding: A Model-Free Approach to Speeding Up LLM Inference (arXiv 2024)**  
   *推論中に出現する長い連続トークン列を suffix tree でキャッシュし、ドラフタ不要で 2.9× レイテンシ削減。agent pipeline やループ生成で特に高効率を示し、実運用での導入が進む。*  

5. **Shapley-Coop: Credit Assignment for Emergent Cooperation in Self-Interested LLM Agents (arXiv 2025)**  
   *協力ゲーム理論の Shapley値をマルチLLM環境に応用し、各エージェントの貢献度に応じた報酬配分を実現。タスク協調を促進しつつ free-rider を抑制する設計が注目を集める。*


