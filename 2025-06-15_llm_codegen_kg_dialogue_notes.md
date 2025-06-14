# 2025-06-15  セッションまとめ  
（LLM によるコード生成の限界／知識グラフ × LLM／対話的学習・可視化）

---

## 1. セッション要約（時系列ハイライト）

- **LLM のコード生成の限界**  
  - 小関数は得意だが大規模システムや設計一貫性は弱い  
  - Self-Evolve, LLM_GP, SICA など *自己改善型エージェント* を紹介
- **長コンテキスト Attention の実態**  
  - 「Lost-in-the-Middle」問題，位置バイアス，可視化の難しさ
- **会話ログの整理と可視化**  
  - Markdown → Mermaid → 知識グラフ化  
  - 重複トピック検出・タグ付け・散布図マッピングのアイデア
- **知識グラフ (KG) × LLM**  
  - K-BERT, CoKE, GALAXY, Neuro-symbolic など  
  - triplet 表現の利点・冗長性・縮約の議論
- **Graph Neural Network と KG**  
  - GNN が構造付き伝播を担う理由，MLP との対比
- **対話が学習を促進する認知的根拠**  
  - 能動的リトリーバル・ナラティブ構造・メタ認知
- **タスク指向対話の構造化分析**  
  - *Task-Oriented Dialogue as Dataflow Synthesis*  
  - *What Makes a Good Argument?* の評価指標
- **音声対話への拡張**  
  - イントネーション・ポーズを含むマルチモーダル議論解析

---

## 2. 議論が膨らんだ話題

1. **Markdown ログ → Mermaid グラフ自動生成**  
   - タグ抽出・類似度クラスタリング・知識グラフ出力まで一貫自動化したい  
2. **Triplet 表現の限界と圧縮**  
   - 冗長性対策・サブグラフ要約・LLM への効率的注入方法
3. **対話が思考を誘導するメカニズムの定量分析**  
   - 発話のフローを Data-flow として捉え，説得力・意思決定への影響を測定
4. **音声プロソディと議論品質**  
   - ポーズ長・強調イントネーションが説得力スコアと相関するかを検証したい

---

## 3. 📚 論文一覧と要約

| タイトル | 年・会議 | 1–2行サマリ |
| --- | --- | --- |
| **SelfEvolve** | 2023 arXiv | LLM が生成→実行→自己修正のループでコード精度を高めるフレームワーク |
| **LLM_GP** | 2024 Springer | 遺伝的プログラミングに LLM を組み込み世代的にコード進化を行う |
| **SICA: A Self-Improving Coding Agent** | 2025 ICLR W/S (arXiv) | エージェントが自身のコードを編集し SWE-Bench Verified で 17→53 % 成功 |
| **AI Scientist** | 2024–25 | 実験コードを自己改変した産業事例，安全性議論を喚起 |
| **AlphaEvolve** | 2025 DeepMind Tech Report | 進化探索でアルゴリズム最適化，数学・データセンタ効率で成果 |
| **K-BERT** | 2020 AAAI | 文に KG subtree を注入し visible-matrix で注意制御，分類・QA向上 |
| **CoKE** | 2020 EMNLP | Transformer で KG triplet を文脈化しリンク予測精度を改善 |
| **GALAXY** | 2022 ACL | LLM と KG によるマルチホップ推論を生成的に統合し対話性能向上 |
| **LLM4KG (Survey)** | 2023 arXiv | LLM を用いた KG 構築・補完・QA の最新動向を体系化 |
| **Neuro-symbolic LLM Systems** | 2024 ICLR/NIPS | LLM が生成した論理ルールを KG で実行する統合推論の潮流 |
| **R-GCN** | 2018 ESWC | 関係タイプ付き GNN，KG のノード分類・リンク予測で標準ベンチ達成 |
| **CompGCN** | 2020 ICLR | ノードとエッジ両方を学習し KG 完成タスクで SOTA |
| **KGT5** | 2021 NAACL | T5 に KG 三つ組を系列化し生成・質問応答を一体化 |
| **Task-Oriented Dialogue as Dataflow Synthesis** | 2020 EMNLP | 発話列→Dataflow グラフに変換し複雑タスクを柔軟に実行 |
| **What Makes a Good Argument?** | 2021 ACL | Reddit/CMV を分析し論点明確性・根拠性など説得力指標を定量化 |
| **OpenIE / ReVerb** | 2011 AAAI | 自然文から S-P-O 三つ組を大規模抽出する先駆的システム |

---

## 4. 📱 アプリアイデアと要約

| アイデア | 要約 |
| --- | --- |
| **md2mermaid.py** | Markdown ログから見出しとトピックを抽出し自動で Mermaid グラフ生成 |
| **topic_indexer.py** | セッション群を走査し重複トピック・タグ別インデックスを出力 |
| **term_normalizer.py** | 表記揺れを正規化し同義概念を統合する辞書生成ツール |
| **cross_topic_map.py** | 会話内で混在した話題を検出し「橋渡しノード」を可視化 |
| **prosody_kg_builder** | 音声ログからプロソディ特徴＋テキスト triplet を統合したマルチモーダルKG |

---

## 5. 📃 ユーザーが特に興味を持っていた論文

### Task-Oriented Dialogue as Dataflow Synthesis, EMNLP 2020  
- **ポイント**: 対話履歴を「変数・関数呼び出し・依存エッジ」で構成される Dataflow グラフへ変換。  
- **貢献**: 複雑な日程照会・フィルタリングなど従来の Slot-Filling では扱えない要求を論理的に分解・実行。  
- **示唆**: あなたの Markdown 対話ログを Dataflow 化すれば、思考過程を追跡・再利用可能。

### What Makes a Good Argument?, ACL 2021  
- **ポイント**: Reddit/CMV の説得成功データを用い、論点の明確化・根拠引用・反論耐性などの指標を抽出し説得力を自動予測。  
- **貢献**: 構造的（論理）・スタイル的（言語）特徴を組み合わせたモデルが人間評価と高相関。  
- **示唆**: 今後の音声対話分析で「プロソディ＋論理構造」が説得力向上に寄与するかの検証が可能。

---


