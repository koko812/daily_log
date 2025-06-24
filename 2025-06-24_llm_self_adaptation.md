# 自己適応・自己最適化 LLM 関連セッションまとめ（2025-06-24）

## 1. セッションの要約（話題の流れ・技術トピック）
- **メタ最適化の潮流**  
  - Sakana AI の *LLM²* 構想に始まり、LLM 自身が損失関数や学習ループを発明・検証する動きが加速:contentReference[oaicite:0]{index=0}。  
- **連続学習フレームワーク**  
  - MIT・SEAL (*Self-Adapting Language Models*) が「自己編集→SFT→RL」を回す継続学習ループを提案:contentReference[oaicite:1]{index=1}。  
- **自己評価・自己修正文脈**  
  - Meta／NYU らの *Self-Rewarding LMs* と Google DeepMind 系 *SCoRe* が「モデル自身が報酬/修正を生成」する手法を提示:contentReference[oaicite:2]{index=2}。  
- **トークン化の壁と推論時改変**  
  - 「1 Byte LM」論文がバイトレベル変換でトークナイザ非互換を解消:contentReference[oaicite:3]{index=3}。  
- **マルチモーダル表現アライメントの解剖**  
  - 視覚特徴が言語空間にどの層で適合するかを層別検証する解析フレームワークが登場:contentReference[oaicite:4]{index=4}。  
- **実務視点**  
  - Gigazine 記事が「AI に “write better code” を連呼→速度↑バグ↑」という実験を紹介:contentReference[oaicite:5]{index=5}。  
  - rsync + SSH ブログは安全なファイル同期ノウハウを整理:contentReference[oaicite:6]{index=6}。

## 2. 議論が膨らんだ話題
| トピック | 主な論点・関連性 |
|---|---|
| **自己適応 (SEAL)** | 継続学習における「壊滅的忘却」とスケジューリング課題 |
| **自己報酬 (SRLM/SCoRe)** | 評価器の精度 VS 学習安定性、RL コスト |
| **損失自動発見 (DiscoPOP)** | 人間設計 DPO との性能比較・転移性 |
| **トークナイザ非互換** | Ensemble・Proxy-Tuning での語彙統一 |
| **視覚-言語アライメント** | ViT 出力と LLM 早期層のミスマッチ解消策 |

## 3. 論文リスト（漏れなく列挙）
| # | タイトル | 会議/出版年 | 1-2 行要約 |
|---|---|---|---|
| 1 | *Discovering Preference Optimization Algorithms with and for Large Language Models* | arXiv 2024:contentReference[oaicite:7]{index=7} | LLM が新損失を提案→評価→改良し、混合ロジスティック系損失 “DiscoPOP” を発見。 |
| 2 | *Self-Adapting Language Models (SEAL)* | arXiv 2025:contentReference[oaicite:8]{index=8} | モデルが自己編集データを生成し SFT→RL で重み更新、知識追加と few-shot 汎化を実現。 |
| 3 | *Self-Rewarding Language Models* | ICML 2024（arXiv 2024-01）:contentReference[oaicite:9]{index=9} | LLM を “Judge” として用い DPO ループを自己完結、AlpacaEval で GPT-4 を上回る。 |
| 4 | *How Visual Representations Map to Language Feature Space in Multimodal LLMs* | arXiv 2025:contentReference[oaicite:10]{index=10} | ViT+線形アダプタで層別対応を可視化、中後層で整合が収束することを発見。 |
| 5 | *Sampling from Your Language Model One Byte at a Time* | arXiv 2025:contentReference[oaicite:11]{index=11} | 任意 BPE LM を推論時に文字/バイト LM 化し、PBP 解決と異語彙 Ensemble を可能に。 |
| 6 | *Training Language Models to Self-Correct via Reinforcement Learning (SCoRe)* | arXiv 2024-09:contentReference[oaicite:12]{index=12} | Google DeepMind、自己生成データのみで多段階 RL を行い数学／HumanEval 大幅改善。 |

## 4. アプリアイデアと要約
| アイデア | 目的・機能 |
|---|---|
| **LLM² 自動損失探索パイプライン** | LLM が候補損失を出力→コード実装→性能フィードバックで進化的に最適化。 |
| **SEAL 継続学習ループ** | 入力ごとに自動 “Self-Edit” を生成し永続的にモデルをリライト。 |
| **SRLM / SCoRe 自己評価・自己修正** | モデル自身が報酬・修正文を生成し反復強化。 |
| **Byte-Level Inference Wrapper** | トークナイザ依存性を排し、異なる語彙モデルを動的に統合。 |
| **「vibe coding」プロンプト戦略** | コード改善を GPT 系へ反復依頼して高速化（ただしバグ増）。 |
| **rsync over SSH スクリプト拡張** | `-av -e 'ssh -p XXX'` テンプレで安全なサーバ同期を自動化。 |

## 5. 特に関心を示した論文（詳細要約）

### 5.1 Self-Adapting Language Models (SEAL) – arXiv 2025  
静的 LLM の限界を破り、**自己編集**を生成して自らの重みを更新するフレームワーク。入力ごとに最適な微調整指示を作り出し、SFT＋RL で永続的に学習。知識追加タスクで Llama-2 に大幅な BLEU 向上、Few-Shot 汎化でも従来の LoRA 系を凌駕。課題は計算コストと忘却対策:contentReference[oaicite:13]{index=13}。

### 5.2 Self-Rewarding Language Models – ICML 2024  
LLM を “評価器” として再帰的に利用し、外部 RM を排除。Iterative DPO でわずか 3 周の微調整でも AlpacaEval 2.0 首位を獲得。報酬品質と学習安定性のバランス制御が研究テーマ:contentReference[oaicite:14]{index=14}。

### 5.3 Discovering Preference Optimization Algorithms with and for LLMs – arXiv 2024  
Sakana AI が提案する **LLM²** 実証。LLM が新損失関数をコード生成→評価→自己改善し、最終的に混合 logistic+exp な DiscoPOP 損失で DPO を上回る。低計算コストでメタ最適化を自動化:contentReference[oaicite:15]{index=15}.

### 5.4 Training Language Models to Self-Correct via RL (SCoRe) – arXiv 2024  
Google DeepMind が “自己修正” を RL で学習。Stage-I 初期化で多様な誤りパターンを付与し、Stage-II で報酬整形を施す。MATH +9 pt、HumanEval +9 pt 向上と、論理／コード両面での自己修正能力を証明:contentReference[oaicite:16]{index=16}。

### 5.5 How Visual Representations Map to Language Feature Space in MLLMs – arXiv 2025  
ViT と凍結 LLM を線形アダプタで接続、Sparse Autoencoder をプローブに層別解析。中〜後層で視覚→言語整合が顕著に上昇し、初期層ミスマッチが残ることを示す。アダプタ設計とマルチモーダル可視化の指針に:contentReference[oaicite:17]{index=17}。

