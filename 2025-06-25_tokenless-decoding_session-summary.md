# Token-Free & Ensemble Decoding ― セッション総括

## 1. セッションの流れと主要トピック
1. **Diffusion-LM 話題** → Mercury など “Diffusion × LM” の新潮流  
2. **アンサンブル・合流系**  
   - CharED, Token-level Ensembling, Lattice Beam, Lookahead/Look-back Beam  
3. **コード生成・小型モデル探索**  
   - Stable Code 3B, Qwen2.5-Coder 3B, 1B/3B クラス比較  
4. **トークナイゼーション再考**  
   - BPE vs UnigramLM、token-less (ByT5, Canine) へ  
5. **最新 token-free モデル**  
   - SpaceByte, MambaByte, BLT、Exact Byte-Level Probabilities  
6. **探索コスト・メモリ計測議論**  
   - ノード展開数と GPU メモリ、プロファイリング方法

## 2. 深掘りが進んだトピック
| トピック | 深掘り内容 |
|---------|-----------|
| **CharED** | 文字単位アンサンブルの可能性・フォーマット安定性・多様性限界 |
| **Token-level Ensembling** | 語彙の異なる LLM 同士の同期／合流ロジック |
| **Lattice Decoding** | 合流と多様性・非英語生成の課題・ノードコスト |
| **Lookahead / Look-back Beam** | 深さパラメータ vs 履歴 KL 制御の比較 |
| **Token-free Models** | Byte/Char モデルの効率・構文理解、最新 2024–25 論文 |

## 3. 論文一覧（漏れなく列挙）
| タイトル | 会議・年 | 1–2 行要約 |
|----------|---------|------------|
| **Mercury: Ultra-Fast Language Models Based on Diffusion** | ICLR 2024 | 生成速度を拡張型 diffusion で 10× 高速化した初期提案 |
| **RePPL / LLM-Check** | arXiv 2023 | ハルシネーション検証フレームワーク，言語モデル自己再評価 |
| **Character-wise Ensemble Decoding (CharED)** | arXiv 2024 | 異トークナイザ LLM を文字確率で統合，HumanEval/GSM8K 向上 |
| **Token-level Ensembling of Models with Different Vocabularies** | arXiv 2025 | 文字一致で確率合流する軽量アンサンブル，BLEU 改善 |
| **On the Depth between Beam Search and Exhaustive Search for Text Generation** | arXiv 2023 | Lookahead 深さ 2–3 で BLEU +1〜2，Beam⇄全探索の中庸 |
| **Lookbehind Heuristic Beam Search** | arXiv 2023 | LBS を 1 ステップ近似し Beam コストで精度維持 |
| **Look-back Decoding for Open-Ended Text Generation** | EMNLP 2023 | Past KL でトピック逸脱を抑制，ストーリー生成向上 |
| **NeuroLogic Decoding: (Un)supervised…** | ACL 2020 | 論理制約を満たすビーム探索で必須語句・語順を保証 |
| **NeuroLogic A\*esque Decoding…** | NAACL 2021 | 上記に A\* 的 lookahead を加え，流暢性まで最適化 |
| **Massive-scale Decoding for Text Generation using Lattices** | NAACL 2022 | n-gram 合流ラティスで多様性と文法性を両立，ノード圧縮 |
| **Pushing the Limits of Beam Search Decoding for Transducer-based Models** | arXiv 2025 | ASR 用合流アルゴリズム，展開→merge→prune の3段階 |
| **Lattice Generation in Attention-Based Speech Recognition Models** | Interspeech 2019 | TCN-ASR で状態共有ノードをマージし推論効率化 |
| **Exact Byte-Level Probabilities from Tokenized Language Models for FIM-Tasks and Model Ensembles** | ICLR 2025 | 追加学習無しでバイト確率を厳密復元，FIM +18 %, Ensemble +3.7 % |
| **SpaceByte: Towards Deleting Tokenization from LLM** | NeurIPS 2024 | 空白境界に階層ブロック，byte-level で subword 並性能 |
| **MambaByte: Token-free Selective State Space Model** | arXiv 2024 | SSM + speculative decoding，長系列効率と2.6×推論速度 |
| **Byte Latent Transformer (BLT)** | Meta Tech Report 2024 | Dynamic patching により byte-level で LLaMA3 等価性能 |
| **Hierarchical Autoregressive Transformers** | ICLR 2025 | Char→Word の二層で token-free と subword を融合 |
| **ByT5: Towards a Token-Free Future…** | TACL 2022 | Byte-to-Byte T5，小モデル強いが large で subword 劣後 |
| **Canine: Pre-training an Efficient Tokenization-Free Encoder** | ACL 2021 | Char 直接学習 + Downsampling，トークナイザ不要 |
| **Charformer: Fast Character Transformers via Gradient-based Subword Tokenization** | ICLR 2022 | Soft span 選択で動的 subword 学習，速度向上 |
| **Tiktoken** | OpenAI 2023 (tech note) | BPE 改良・JSON/コード最適化，GPT-4 系標準 |
| **Papers on Stable Code / Qwen / Granite etc.** | 2023–24 多数 | 3B-class code LLM の比較研究 (省略不可として言及) |

## 4. アプリアイデア一覧
| 🛠️ アイデア | 目的 | 機能概要 |
|--------------|------|----------|
| CharED + Syntax Validator | 文字合流後の構文破綻検出 | Python AST でデコード直後に構文チェック |
| ノード数-メモリ Profiler | ビーム探索のメモリ可視化 | torch.cuda.memory + logging, Nsight trace |
| Byte-to-Subword Converter | Byte-level LLM ↔ Tokenized LLM を切替 | Exact Byte‐Level 理論を実装しオンザフライ変換 |

## 5. ユーザー関心トップ5論文（詳細要約）

### 1. **Token-level Ensembling of Models with Different Vocabularies** (Wicks et al., arXiv 2025)  
語彙が異なる LLM 同士を、デトークン後の文字列一致で瞬時に同期し確率を合流する“Agreement-Based Ensembling”。追加学習なしに MT BLEU を向上させ、異語彙モデル融合のハードルを大きく下げた。ユーザーが語彙非依存アンサンブルに強い関心を示した。

### 2. **Character-wise Ensemble Decoding (CharED)** (arXiv 2024)  
トークナイザに縛られず文字確率を比較して統合する革新的デコーダ。HumanEval・GSM8K で 13B+13B の大規模モデルより高性能を示し、フォーマット維持や多モデル相補の議論が深まった。

### 3. **Massive-scale Decoding for Text Generation using Lattices** (Xu et al., NAACL 2022)  
ビーム探索を Best-first＋ラティス合流に置き換え、数千候補を圧縮保持。多様性＝品質のトレードオフを改善し、合流と多言語生成の課題について議論が集中。

### 4. **Exact Byte-Level Probabilities…** (Phan et al., ICLR 2025)  
Tokenized LLM を追加学習なしで byte-level と同等確率に変換する理論的⼿法。FIM +18 %、Ensemble +3.7 % を達成し、「性能劣化なく token-free 化」の可否に強い関心が寄せられた。

### 5. **On the Depth between Beam Search and Exhaustive Search for Text Generation** (Jinnai et al., arXiv 2023)  
Lookahead 深度を可変にし、Beam 0↔全探索∞の中間で最良点を見つける。深さ2–3で BLEU 改善が示され、深さ制御と探索コストの議論が活発化。

