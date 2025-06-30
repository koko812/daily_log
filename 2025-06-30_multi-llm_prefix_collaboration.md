# Multi-LLM Prefix Collaboration & Ambiguity-Sensitive Prediction セッションまとめ

## 1. セッションの要約（話題の流れ・技術トピック）
- **導入**：2 本の最新研究 ―  
  1) *Next-Token Prediction Should be Ambiguity-Sensitive*（2025, arXiv）  
  2) *PToco: Prefix-based Token-level Collaboration Enhances Reasoning for Multi-LLMs*（COLING 2025）  
  を中心に議論開始。  
- **あいまい性とメタラーニング**：Ambiguity-Sensitive NTP の背景にある認知科学的視点と MetaHMM ベンチマークを整理。  
- **マルチ LLM 協調推論**：PToco の枠組み、prefix grouping アルゴリズム、トークナイザー非依存設計（Carol 例）を詳細解説。  
- **実装・評価議論**：Ablation で prefix grouping の有効性を確認、計算コストとのトレードオフを検討。  
- **派生トピック**：multi-agent debate 系研究（Du et al. 2023, Liang et al. 2023 など）や token-wise ensemble（Hoang et al. 2023, Li et al. 2024）へ言及。  

## 2. 議論が膨らんだ話題
- 🔍 **Prefix Grouping の内部処理**：確率合算式・Unicode ベース共有接頭辞でのグループ化[?12;4$yヒューリスティック  
- 🔄 **異なるトークナイザー連携**：Carol の特殊設計と部分一致許容ロジック  
- 🧪 **Ablation Study**：PToco なし / naive ensemble / 提案手法の比較と解釈  

## 3. 論文リスト（漏れなく列挙）

| # | タイトル | 会議名・年 | 1〜2 行要約 |
|---|----------|-----------|-------------|
| 1 | **Next-Token Prediction Should be Ambiguity-Sensitive: A Meta-Learning Perspective** | arXiv 2025 | 高あいまい文脈で Transformer が苦戦する点を示し、MetaHMM でモンテカルロ型予測を評価。 |
| 2 | **PToco: Prefix-based Token-level Collaboration Enhances Reasoning for Multi-LLMs** | COLING 2025 | 異なる LLM・トークナイザー間で prefix 合意により推論精度を向上させる協調デコード法を提案。 |
| 3 | Debateフレームワークによる多エージェント推論 (Du et al., EMNLP 2023) | EMNLP 2023 | GPT 系モデル複数を議論させることで回答品質を高める手法を実証。 |
| 4 | Multi-Agent Debate improves factuality (Liang et al., ACL 2023) | ACL 2023 | 反復的自己修正＋投票で回答の信頼性向上を確認。 |
| 5 | **Token-Wise Logit Fusion for Ensemble LMs** (Hoang et al., Findings 2023) | Findings 2023 | 同一トークナイザー前提で logits を加重平均し、翻訳・QA で一貫した改善を報告。 |
| 6 | **Diverse Token Alignment for Heterogeneous LMs** (Li et al., NAACL 2024) | NAACL 2024 | 異サイズサブワード間のマッピング関数を導入し、モデル混合を可能にした先行研究。 |

## 4. アプリアイデアと要約

| アイデア | 目的・機能 | メモ |
|----------|-----------|------|
| 📚 **PToco-Wrapper Library** | Hugging Face 互換 API で prefix grouping 協調デコードを簡単に呼び出す | 異トークナイザー自動整合・ablation オプション付き |
| 🛠️ **Ambiguity-Sensitive Beam Search Toolkit** | MetaHMM 風ベンチマーク生成＆可視化、温度/ヒューリスティック切替 | 高あいまい度検知→探索方策を動的変更 |

## 5. ユーザーが特に関心を持っていた論文（5 本）

1. **PToco: Prefix-based Token-level Collaboration Enhances Reasoning for Multi-LLMs**  
   *COLING 2025* — Prefix 共有で異なる LLM 間にトークンレベルの合意形成フローを導入。トークナイザー非依存のグルーピングで GSM8K 等の reasoning 精度を大幅向上し、ablation で手法要素ごとの寄与を定量化。

2. **Next-Token Prediction Should be Ambiguity-Sensitive: A Meta-Learning Perspective**  
   *arXiv 2025* — 高・低あいまい文脈を区別する MetaHMM ベンチマークを提案し、Transformer の限界を実証。モンテカルロ型予測分解アプローチで改善の可能性を示したメタラーニング視点の研究。  

3. **Debateフレームワークによる多エージェント推論**  
   *EMNLP 2023* — 複数 GPT-系モデルが議論し投票する「multi-agent debate」で、数学・推論タスクの正答率を向上。PToco と同様の「モデル間合意形成」思想の先駆的事例。  

4. **Token-Wise Logit Fusion for Ensemble LMs**  
   *Findings 2023* — 同一トークナイザーを前提に logits 加重平均で翻訳・QA 改善。PToco が prefix 合意という一般化に進む上で比較対象となる代表的 token-level ensemble。  

5. **Diverse Token Alignment for Heterogeneous LMs**  
   *NAACL 2024* — 異なるサブワード粒度間のマッピングを学習し、混合デコードを可能にした研究。PToco の「byte/char ベース共有 prefix」設計の動機づけとして重要。  

