# LLM専用言語・CoT解釈性・潜在推論セッションまとめ

## 1. セッションの要約（時系列）
| 時間軸 | 主な話題 | 技術トピック |
|--------|----------|--------------|
| ▶️ **導入** | 「LLM専用の言語」を扱う最新文献を総覧 | DSL 生成・ドメイン特化LLM |
| ▶️ **URL提示** | DeepMind 記事を契機に “新語(Neologism)”・潜在思考・創発言語にフォーカス | Neologism, Coconut, Emergent Communication |
| ▶️ **個別深掘り** | 1) *We Can’t Understand AI…* <br>2) *Training LLMs to Reason in a Continuous Latent Space* <br>3) *Generative Emergent Communication* | 性能 vs 解釈性・潜在空間推論・語彙創発 |
| ▶️ **解釈性議論** | CoT の限界と Faithful / Self-Consistency / Mechanistic approaches | 忠実性・多様性・回路解析 |
| ▶️ **まとめ要請** | 本セッション全体を Markdown で整理 | 現在位置 |

## 2. 議論が膨らんだ話題
1. **Neologism を介した人-AI 共通語**：制御性と説明性を両立させる中間言語設計  
2. **Coconut (連続潜在思考)**：CoT 超の精度と引き換えに可視性を喪失するトレードオフ  
3. **CoT 解釈性向上策**：Faithful CoT・Self-Consistency・Circuit Tracing など多角的アプローチ  
4. **Emergent Communication**：LLM同士で自然発生する記号体系とその構造的進化  

## 3. 論文リスト（漏れなく列挙）
| # | 論文タイトル | 会議・出版年 | 1-2行要約 |
|---|--------------|--------------|-----------|
| 1 | Grammar Prompting for Domain-Specific Language Generation with LLMs | NeurIPS 2023 | BNF文法をプロンプトに与えDSLコードを高精度生成 |
| 2 | A Comparative Study of DSL Code Generation: Fine-Tuning vs RAG | arXiv 2024 | ファインチューニングとRAGのDSL性能を定量比較 |
| 3 | DSL-Xpert: LLM-driven Generic DSL Code Generation | ACM Conf. 2024 | DSL文法→AST→生成までを自動化するパイプライン |
| 4 | AutoDSL: Automated Domain-Specific Language Design for Structural … | ACL 2024 | LLMを用いたDSL設計自動化で5領域93%成功 |
| 5 | On the Effectiveness of LLMs in Domain-Specific Code Generation | ACM Conf. 2024 | DomCoderでAPI知識注入が生成品質を向上 |
| 6 | Injecting Domain-Specific Knowledge into LLMs | arXiv 2025 | 医療・法律等へ知識注入する総説 |
| 7 | Fine-tuning and Utilization Methods of Domain-specific LLMs | arXiv 2024 | 金融LLMの調整法と規制対応を調査 |
| 8 | Advancing LLMs for Code Using Code-Structure-Aware Methods | UC Berkeley Thesis 2025 | AST-T5で構文理解を強化しコード精度UP |
| 9 | Domain Specialization as the Key to Make LLMs Disruptive | arXiv 2023 | ドメイン適応技術を網羅した総説 |
| 10 | **We Can’t Understand AI Using our Existing Vocabulary** | ICML 2025 | 新語(neologism)導入で人-AI対話を再設計 |
| 11 | **Training LLMs to Reason in a Continuous Latent Space (Coconut)** | arXiv 2024 / ICLR 2025 | 潜在連続思考でCoT超え性能・BFS的探索 |
| 12 | **Generative Emergent Communication** | arXiv 2024 | ベイズ枠組でLLM間の語彙創発を理論化 |
| 13 | Searching for Structure: Investigating Emergent Communication with LLMs | COLING 2025 | リファレンシャルゲームで構造的人工語が出現 |
| 14 | Faithful Chain-of-Thought Reasoning | arXiv 2023 | 記号推論でCoTの忠実性を担保し精度+ |
| 15 | Self-Consistency Improves Chain-of-Thought Reasoning | NeurIPS 2022 | 多様CoT多数決でGSM8K+17.9% |
| 16 | Chain of Preference Optimization | NeurIPS 2024 | Tree-of-ThoughtをCoTに蒸留し軽量高精度 |
| 17 | Circuit Tracing for Large Language Models | Anthropic Tech Report 2024 | ニューロン回路単位でモデル機能を可視化 |
| 18 | Visual Chain-of-Thought | arXiv 2023 | 画像付き説明でマルチモーダルCoTを実現 |

## 4. アプリアイデアと要約
| アイデア | 目的・機能 |
|----------|-----------|
| 🛠️ **Neologism Prompt Builder** | GUIで新語を定義→プロンプト自動生成・効果検証 |
| 📊 **Latent Reasoning Projector** | Coconut の hidden‐state 変遷を低次元可視化 |
| 🔍 **CoT Faithfulness Auditor** | 出力CoTを記号ソルバで検証し忠実性スコア付与 |
| 🌐 **Emergent Language Playground** | 複数LLMを対話させ人工語の進化を観察・ログ化 |

## 5. ユーザーが特に関心を持っていた論文（詳細要約）

### 5-1. We Can’t Understand AI Using our Existing Vocabulary (ICML 2025)
人間語の曖昧さがAI制御を阻む点を指摘し、再利用可能で意味が一貫した“neologism”を設計する必要性を提唱。応答長や多様性を操作する新語でLLM出力を制御し、言語インターフェースをAPI化する方向性を示した。

### 5-2. Training LLMs to Reason in a Continuous Latent Space (Coconut) (ICLR 2025)
自然言語CoTを介さず hidden state だけで思考を連鎖させる“Chain of Continuous Thought”を導入。BFS的潜在探索でGSM8K等を大幅に更新しつつ推論トークン数を削減。解釈性低下という新たな課題も提示。

### 5-3. Generative Emergent Communication (arXiv 2024)
分散ベイズ推論で複数LLMが共有世界モデルを形成しつつ共通記号体系が自ずと立ち上がる現象を数理的に定式化。語彙意味の収束メカニズムと圧縮‐表現力トレードオフを理論・シミュレーション両面で検証。

### 5-4. Faithful Chain-of-Thought Reasoning (arXiv 2023)
CoTの各ステップを記号推論に変換しソルバで妥当性を保証する“faithful CoT”を提案。従来CoTより5-20%精度向上し、説明と推論の整合性を同時達成することで実運用での信頼性を高めた。

### 5-5. Searching for Structure: Investigating Emergent Communication with LLMs (COLING 2025)
リファレンシャルゲーム実験で無構造トークン列が世代を経て語彙-意味対応を獲得する過程を追跡。TopSimやLevenshtein解析で構造化の進行を計量し、人間には読みづらい縮退語彙が実用通信に適合する様子を明らかにした。

