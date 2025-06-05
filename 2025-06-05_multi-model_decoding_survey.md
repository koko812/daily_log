# 2025-06-05  セッションまとめ

## 1. セッションの要約
- **進行状況の整理**  
  - BLEU/chrF で複数モデル（CALM-2 8B, LLM-JP 3.7B, Qwen 系）の翻訳性能を比較  
  - 単一モデルのビームサーチ実装を確認し，**「モデル横断ビーム（5+5=10 本）」や token 一致点での合流**を次ステップに設定  
- **技術・アイデア**  
  - トークン一致／投票，文字単位アンサンブル，Twist Decoding，動的トークナイゼーションなど **協調的デコーディング手法**を検討  
  - CharED, Twist Decoding など論文の知見を実装案にマッピング  
- **論文サーベイ**  
  - 協調生成・TreeSearch・動的語彙の 11 本をリストし要点共有  
- **今後の方針**  
  - (a) Qwen + LLM-JP のマルチモデルビーム統合プロトタイプ  
  - (b) Token/Char レベル合流アルゴリズムの実装テスト  
  - (c) 動的トークナイゼーションのベンチマーク適用と高速化効果検証  

---

## 2. 議論が膨らんだ話題
1. **ビーム統合ロジック**  
   - 10 本ビームを logprob で一括ソートし，共通 prefix で出力を確定 → 残りを再生成  
2. **CharED と token 投票**  
   - サブワード差を吸収する文字レベル多数決が，日本語・中国語で有効かを検討  
3. **動的トークナイゼーションのメリット／懸念**  
   - トークン列短縮で推論高速化 vs. 語彙拡張による精度低下リスク  
4. **Twist Decoding の実装可否**  
   - 異なるトークナイザー同士が互いにガイドする交互ビームの設計ポイント  

---

## 3. 📚 論文一覧と要約

| # | 論文 (出版年・会議) | 1-2 行要約 |
|---|---------------------|-----------|
| 1 | **A Token-Level Decoding Algorithm for Ensembling Models Across Vocabulary Sizes** (ARR 2025) | 語彙サイズが異なるモデルを token-alignment でアンサンブルする新デコーダを提案。 |
| 2 | **Token-by-Token Election** (ICLR 2025) | 各ステップで複数モデルの予測を投票し協調推論を行う手法。 |
| 3 | **CharED** (arXiv 2024 Jun) | 文字単位投票で語彙差の壁を超えるアンサンブルデコード。 |
| 4 | **S2-MAD** (NAACL 2025) | 非同期エージェント間ディベートで token バリアを突破する協調推論。 |
| 5 | **Tree of Thoughts** (NeurIPS 2024 oral) | 思考ツリー探索で複雑問題を解く LLM 推論フレームワーク。 |
| 6 | **MTMT** (arXiv 2024 Dec) | 複数思考モードを統合した Thought Tree により推論強化。 |
| 7 | **Process Reward-Guided Tree Search** (NAACL 2025 long) | Reward モデルでビーム探索を再評価し高品質解を合成。 |
| 8 | **EBBS** (AAAI 2025) | 二層ビームで複数モデル翻訳を統合するゼロショット MT 手法。 |
| 9 | **Twist Decoding: Diverse Generators Guide Each Other** (EMNLP 2022) | 異なる生成器が互いのビームを距離ベースで誘導し性能向上。 |
|10 | **Language-agnostic BERT Sentence Embedding (LaBSE)** (ACL 2020) | 100+ 言語対応の汎言語文ベクトルをデュアルエンコーダで提供。 |
|11 | **Retrofitting LLMs with Dynamic Tokenization** (arXiv 2024 Nov) | バッチ依存のサブワード合成と HN 埋め込みでトークン列を短縮。 |

---

## 4. 📱 アプリアイデアと要約
- **Multi-Model Beam Explorer**: 2-3 モデルのビームを可視化し，prefix 一致で自動合流するデバッガ。  
- **Dynamic Tokenizer Profiler**: 動的トークナイゼーション導入前後でトークン長と速度をグラフ比較するツール。  
- **Token-Vote Reranker**: 各モデルの token logprob を集計し，多数決で次トークンを決めるプラグイン。  

---

## 5. 深掘り解説（特に興味を示した論文）

### ◇ CharED (2024 Jun, arXiv)
- **核心**: モデル間で語彙や BPE 境界が異なる問題を，最小単位「文字」へ写像し解決。  
- **仕組み**: 各モデルの logprob を文字列に再射影し，文字ごとに加重平均 → 最終分布。  
- **応用**: Qwen+BPE と LLM-JP+SentencePiece の組み合わせでも投票が可能になる。

### ◇ Twist Decoding (EMNLP 2022)
- **核心**: 交互ビームで互いの生成を「ねじり合う」ガイド。距離関数（例：Edit Dist.）で他モデルとの差をペナルティに加え，多様性と品質を同時確保。  
- **実装要点**: 2 Pass beam, output mapping, bidirectional guidance。推論コストは ≲2×。

### ◇ Dynamic Tokenization (2024 Nov, arXiv)
- **核心**: バッチごとに最適なサブワードを新規生成し，HN で埋め込みを即席生成。  
- **効果/制限**: 平均22%トークン短縮で推論高速化；一部タスクで最大 5–6 pt 性能減。ANN 検索の追加レイテンシが課題。

---


