# 🔄 LLM における文脈共有と多様性志向デコードの俯瞰メモ  
*(2025-06-10 chat session)*  

---

## 1. セッション全体の要約  
- **文脈共有の枠組み探し**  
  - KV-Cache 共有 (DroidSpeak 系) や共有メモリ (Memory Sharing, CoPS) を概観。  
- **デコード途中での協調生成**  
  - Collaborative Decoding / Mixture-of-Context など、生成中にモデルが通信する手法を比較。  
- **ビームサーチの多様性問題**  
  - Diverse Beam Search, Determinantal Beam Search, Self-Evaluation Beam などの多様化技術を整理。  
- **対照 & 典型性デコード**  
  - Contrastive Decoding と Typical Decoding を詳解し、自然さと情報量の両立を検討。  
- **RL×文脈共有**  
  - LoCo-RLHF や ICRL など、強化学習とコンテキストの融合例を確認。  
- **今後の方針**  
  - ① KV 共有 + Collaborative Decoding のハイブリッド実装をプロトタイプ  
  - ② 多様性制御（Contrastive / Typical）を評価ベンチで比較  
  - ③ RLHF 系アプローチでユーザ文脈を扱う報酬設計を検証  

---

## 2. 議論が膨らんだ話題  
- **Collaborative Decoding の発展形**  
  - Speculation を組み込む CoS / CoSD、トークン単位で生成者を切り替える Co-LLM まで掘り下げ。  
- **ビーム多様性 vs 品質のトレードオフ**  
  - DPP や Self-Evaluation を用いた“質の高い多様性”の取り方を詳細に分析。  
- **Contrastive vs Typical**  
  - 二段モデルによる退屈トークン抑制 (Contrastive) と surprisal 分布に基づく典型性フィルタ (Typical) を比較。  

---

## 3. 📚 論文一覧と要約  

| # | 論文タイトル | 年・会議 | 要約 (1-2 行) |
|---|--------------|---------|---------------|
| 1 | **DroidSpeak: KV Cache Sharing for Cross-LLM Communication and Multi-LLM Serving** | 2024, arXiv | 複数 LLM が KV キャッシュを再利用し推論を最大 3× 高速化。 |
| 2 | **Memory Sharing for Large Language Model based Agents** | 2024, arXiv | エージェント間で動的メモリプールを共有し Collective ICL を実現。 |
| 3 | **CoPS: Empowering LLM Agents with Provable Cross-Task Experience Sharing** | 2024-25, ICLR 提出 | タスク横断で経験ログを共有・選別し汎化性能を保証。 |
| 4 | **Chain-of-Agents: LLM Collaboration on Long-Context Tasks** | 2024 (NeurIPS 24) | 長文タスクを分割しチェーン型で処理、フル文脈モデルを凌駕。 |
| 5 | **DivTOD** | 2024, Findings of ACL | タスク指向対話で多様性を高める表現再学習フレームワーク。 |
| 6 | **Collaborative Decoding of LLMs via Message Passing** | 2024, ICLR | グラフ上でトークン分布を交換しながら協調生成、整合性向上。 |
| 7 | **Mixture-of-Context Decoding** | 2023, EMNLP | 複数文脈の出力分布をトークン毎に重み付け融合し QA を改善。 |
| 8 | **CoS: Collaborative Decoding via Speculation** | 2025, arXiv | 小-大モデルが交互に提案/検証し速度と品質を両立。 |
| 9 | **CoSD: Speculate then Collaborate** | 2025, arXiv | ドラフト→アシスト→統合で効率的に協調生成。 |
| 10 | **Co-LLM: Learning to Decode Collaboratively Token-Level** | 2024, arXiv | トークン毎に専門家モデルを切替える潜在変数モデル。 |
| 11 | **Low-Rank Contextual RLHF (LoCo-RLHF)** | 2024, arXiv | ユーザ文脈を低ランク表現に圧縮して RLHF に組込む。 |
| 12 | **Distributional Preference Learning in RLHF** | 2023, arXiv | Annotator 差異を報酬分布として扱い頑健性を向上。 |
| 13 | **In-Context Reinforcement Learning (ICRL)** | 2025 (ICLR 提出) | 出力+報酬履歴をプロンプトに入れパラメータ更新無しで学習。 |
| 14 | **Self-Evaluation Guided Beam Search for Reasoning** | 2023, arXiv | 各ビーム候補を自己採点して動的に剪定、GSM8K で +9%。 |
| 15 | **Meshed Context-Aware Beam Search** | 2024, Entropy | 画像キャプションで生成文脈を視覚注意にフィードバック。 |
| 16 | **Contextual Beam Search for Speaker Diarization** | 2023, arXiv | 音声+会話文脈を統合した joint beam で SA-WER 40%減。 |
| 17 | **Diverse Beam Search** | 2016, ACL | ビームをグループ化し n-gram ペナルティで多様性を確保。 |
| 18 | **Determinantal Beam Search** | 2021, arXiv | DPP で候補相関を抑えつつ確率質量を最大化。 |
| 19 | **Typical Decoding** | 2022, ICLR | surprisal 分布中心部のみサンプリングし「ほどよい」生成へ。 |
| 20 | **Mutual Information-based Reranking** | 2016, NAACL | 入力-出力の相互情報量でビーム候補を再ランクし blandness 改善。 |
| 21 | **Minimum Bayes Risk (MBR) Decoding** | 2004, HLT-NAACL | 期待リスク最小の代表候補を選び多様性と品質を両立。 |
| 22 | **Contrastive Decoding** | 2023, ICLR | 大-小モデル差分スコアで退屈トークンを抑制し情報量を強化。 |
| 23 | **Systematic Study of Cross-Layer KV Sharing** | 2025, NAACL | KV 共有手法を統一枠組みで分析し最適層数を提案。 |
| 24 | **Prompt Leakage via KV-Cache Sharing** | 2025, NDSS | 共有キャッシュが招く情報漏洩リスクを実証・対策提示。 |
| 25 | **CacheBlend** | 2025, (SIGCOMM 系) | 文書単位で KV を事前計算し RAG の TTFT を 2-3× 短縮。 |
| 26 | **KVLink** | 2025, arXiv | 文書連結キャッシュ再利用で QA 精度↑、TTFT90%減。 |
| 27 | **KVShare** | 2025, arXiv | 意味類似文書間でキャッシュ共有しヒット率 60%↑。 |

---

## 4. 📱 アプリのアイデア要約  

| アイデア | 趣旨 |
|----------|------|
| **Collaborative-KV Decoding Toolkit** | KV 共有 + Collaborative Decoding を試せるプラグイン型推論パイプライン。 |
| **Dynamic Diversity Decoder** | Contrastive / Typical / DBS を切替え評価できるハンズオン UI。 |
| **Contextual RLHF Playground** | ユーザメタ情報を報酬に組込む RLHF 実験環境。 |

---

## 5. ユーザーが特に興味を示した論文解説 (5 本)

### 5.1 Contrastive Decoding (ICLR 2023)  
- **概要**：大モデル出力から小モデル“退屈度”を差し引いてトークン選択。  
- **魅力**：流暢さを保ったまま情報量と新規性を向上、実装もシンプル。  

### 5.2 Typical Decoding (ICLR 2022)  
- **概要**：surprisal 分布の中心 ρ% だけをサンプリング。  
- **魅力**：暴走せず“ちょうど人間らしい”アウトプットを安定生成。  

### 5.3 Collaborative Decoding of LLMs via Message Passing (ICLR 2024)  
- **概要**：モデル同士がトークン分布を交換・説得し合う協調生成。  
- **魅力**：コード生成や推論で整合性が向上、KV 共有との統合余地も大。  

### 5.4 Diverse Beam Search (ACL 2016)  
- **概要**：ビームをグループ化し n-gram ペナルティで多様化。  
- **魅力**：現在も多様性制御のデファクト標準、他手法との併用が容易。  

### 5.5 DroidSpeak (arXiv 2024)  
- **概要**：KV キャッシュを共有してマルチ LLM 推論を高速化。  
- **魅力**：実システムで 3× スループット改善、協調デコード基盤として有望。  

---

