# Token-wise Cooperative Decoding – Slide Preparation Session

## 1. セッションの要約
| 時間帯 | 話題の流れ & 技術トピック |
|-------|---------------------------|
| 1️⃣ 初期 | 8枚→10枚のスライド構成を検討し、**Overview / Background / Motivation / Method / Results / Future / Related Work** の流れを策定 |
| 2️⃣ タイトル調整 | “Token-wise Cooperative Decoding across **Heterogeneous** Language Models” へ変更し、異系統LLMの強調・英語表記の自然さを議論 |
| 3️⃣ スライド本文 | 「利点と課題」を1行箇条書きで整理、**Experimental Method**（線形結合）、**Experimental Settings** を簡潔化 |
| 4️⃣ グラフ作成 | Matplotlib で **en-zh / en-ja COMET** スコア棒グラフを作成（透明背景・フォント調整・背景色統一） |
| 5️⃣ Future Directions | ビームサーチ・Top-k サンプリング・動的モデル切替などを含む今後の展望を整理 |
| 6️⃣ 英文例作成 | 中国と日本を対比した複合文を生成し、協調デコーディングの説明例として採用 |
| 7️⃣ 発表完了 | 発表終了の報告と総括、本セッションの Markdown まとめ依頼 |

## 2. 議論が膨らんだ話題
- **トークン単位協調の利点と難しさ**  
  - 微細制御・局所修正 vs. トークナイザ不一致・確率整合
- **異系統LLMの協調**  
  - 小型・多様なモデルを組み合わせるモジュラリティの可能性
- **デコーディング戦略の比較**  
  - ビームサーチ / Top-k サンプリング × Token-wise で挙動を網羅的に検証予定
- **視覚化とスライドデザイン**  
  - 背景色統一、フォント拡大、透明PNG出力で研究発表スライドに即投入可能なグラフを作成

## 3. 論文リスト（本セッション内で登場した論文）
| # | タイトル | 会議・年 | 1〜2行要約 |
|---|----------|---------|------------|
| － | 今回のセッションでは新規論文名の提示なし | ― | ― |

> 📚 **注**：当セッションはスライド作成に集中しており、具体的な論文引用は出てこなかったためリストは空欄です。  
> 過去セッションで扱った論文が必要な場合は別途まとめをご依頼ください。

## 4. アプリ／ツールのアイデア
| アイデア | 目的・機能 |
|----------|------------|
| 🚀 Token-wise Decoding Dashboard | モデルごとのトークン貢献度、確率スケール、語彙整合性を可視化しながら協調デコーディングを試行・比較 |
| 📊 Slide-Ready Graph Exporter | Matplotlib で生成した研究用グラフをワンクリックで透明背景＋設定済みフォントに整形し、PNG/SVG で即出力 |
| 🧩 Model Router Prototype | 文脈特徴に基づき文中セグメントを動的に異系統LLMへルーティングし、生成をリアルタイムに再構成 |

## 5. ユーザーが特に関心を示した論文（過去セッションより抜粋）
> ※本セッションに論文は出てこなかったため、直近でユーザーが強調していた論文を再掲しています。

1. **Mahaut & Franzon, “Repetitions Are Not All Alike: Distinct Mechanisms Sustain Repetition in Language Models” (arXiv 2025)**  
   - repetition の発生機構をタイプ別に分析し、トークナイザ・デコーディング手法が与える影響を詳細に実験。協調デコーディングが repetition をどう変えるかのベースラインに。  
2. **“Calibration-Tuning: Teaching Large Language Models to Know What They Don’t Know” (ACL 2024)**  
   - 温度スケーリングと追加損失で LLM の不確実性を校正。Token-wise 融合時の確率整合性課題に直結。  
3. **Wang et al., “What Makes a Good Argument?” (ACL 2021)**  
   - 議論構造解析を示す古典的研究。マルチモデル協調で生成される多様表現の評価軸になり得る。  
4. **Zhang et al., “Task-Oriented Dialogue as Dataflow Synthesis” (EMNLP 2020)**  
   - データフロー合成としての対話生成を提案。モデル分業型の token-wise 生成イメージと親和性。  
5. **Roman Vershynin, *High-Dimensional Probability* (2nd ed., 2025)**  
   - 高次元確率論の包括的解説。確率スケール整合の理論的バックボーンとしてユーザーが継続的に参照。


