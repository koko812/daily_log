# LLM推論・ツール利用・信頼性評価 ― セッションまとめ

## 1. セッションの流れと主要トピック
| 時系列 | 話題の主軸 | 技術キーワード |
|--------|------------|----------------|
| ① 序盤 | **曖昧性に敏感な次トークン予測** | Ambiguity-Sensitive Loss, Meta-Learning |
| ② 中盤 | **ツール利用エージェント**（ReAct・Toolformer・Reflexion） | Tool-use supervision, Self-reflection, RLHF |
| ③ 中盤 | **未知検出・拒否応答** | R-Tuning, US-Tuning, Calibration-Tuning |
| ④ 後半 | **推論過程の評価・最適化** | CoT, Self-Consistency, MBR, Step-wise reward |
| ⑤ 終盤 | **数学特化モデル & RL型事前学習** | WizardMath, Reinforcement Pre-Training |
| ⑥ 周辺話題 | 否定・語順感度、ICLの暗黙勾配、Selective Decoding |

## 2. 議論が深まったトピック
- **曖昧性対応 Next-Token**：唯一解前提を崩し、分布の広がりを保つ学習が必要。
- **ツール呼出し判断**：Toolformer & ReAct で「いつ検索か」を学習。Reflexionで自己反省型ループへ拡張。
- **拒否チューニング**：R-Tuning／Self-Align が “I don’t know” を教える。PRM付きWizardMathも同系統。
- **推論ステップ最適化**：Self-Consistency, CPO, PoT, Step-KTO で中間思考を評価・強化。
- **推論構造の計測**：FineLogic, Frodo, KG-Eval で CoT の faithfulness を可視化。
- **RL型 Pretraining**：RPT が MLE を超えるゼロショット性能を初めて報告。

## 3. 論文リスト（漏れなく列挙）
| # | タイトル／会議・年 | 1-2行要約 |
|---|-------------------|-----------|
| 1 | *Next-Token Prediction Should be Ambiguity-Sensitive* (ICLR 2024) | 1語正解主義を緩和し、曖昧文脈で分布を広げるメタ学習損失を提案。 |
| 2 | *ReAct: Synergizing Reasoning and Acting in Language Models* (NeurIPS 2022) | Thought→Action ループでツールを呼び出し、QA/ALFWorld成功率を大幅改善。 |
| 3 | *Toolformer: LMs Can Teach Themselves to Use Tools* (ICLR 2023) | 自己注釈でAPI呼出し位置を学習し、小モデルでも大型並み精度を達成。 |
| 4 | *R-Tuning* (ArXiv 2023) | 低リスク質問で「I don't know」を出力させる指示チューニング。 |
| 5 | *US-Tuning* (ACL Workshop 2024) | 未知質問検出を2段階SFTで強化、拒否率＋34.7 %。 |
| 6 | *Self-Align* (EMNLP 2024) | 拒否＋理由説明を生成できるよう誘導。 |
| 7 | *Calibration-Tuning* (UncertaiNLP 2024) | 信頼度ECEをタスク横断で改善する少量FT法。 |
| 8 | *A Study on the Calibration of In-context Learning* (EMNLP 2023) | ICLでショット数とキャリブ精度の逆転現象を分析。 |
| 9 | *ReSearch: LLMs Can Learn Self-Restraint…* (TMLR 2024) | 自己反省ループで hallucination を減らし検索誘導率を向上。 |
| 10 | *Beyond Accuracy: Evaluating Reasoning Behavior of LLMs* (COLM 2024) | 精度だけでなく groundedness/validity で推論を多角評価。 |
| 11 | *FineLogic: Dissecting Logical Reasoning in LLMs* (ArXiv 2025) | Stepwise soundness＋内部表現を3軸評価し、自然言語 vs シンボリックFTを比較。 |
| 12 | *LLMs Know More Than They Show* (ArXiv 2024) | 隠れ層プローブで「内部に正解だが出力しない」ギャップを検証。 |
| 13 | *Chain-of-Thought Prompting Elicits Reasoning* (NeurIPS 2022) | Few-shot CoTでGSM8K精度を57 %に引上げ。 |
| 14 | *Self-Consistency Improves CoT Reasoning* (ICLR 2023) | 多パスCoT＋投票で数学タスクを+18 pt改善。 |
| 15 | *SymbCoT* (ArXiv 2024) | シンボリック推論をCoTに統合し論理問題を強化。 |
| 16 | *Chain of Preference Optimization* (NeurIPS 2024) | ToT探索を微調整に利用しHotpotQA+3 pt。 |
| 17 | *Self-Eval Guided Beam Search* (ArXiv 2023) | ステップ自己評価でGSM8K+6 pt。 |
| 18 | *Program of Thoughts (PoT)* (ArXiv 2022) | プログラム化CoT＋実行検証で数学精度+12 %。 |
| 19 | *Step-KTO* (ArXiv 2024) | ステップ&解答両方への報酬でMATH Pass@1大幅増。 |
| 20 | *Evaluating Step-by-step Reasoning Traces* (Survey 2025) | Reasoning評価を rooted/valid/coherent/utility で整理。 |
| 21 | *FRODO: Measuring & Improving Faithfulness of CoT* (EMNLP 2024) | 因果メディエーションで CoT の真因性を強化。 |
| 22 | *Hardness of Faithful CoT* (ICLR 2025) | 高難度タスクで CoT faithfulness 改善が難しいと示す。 |
| 23 | *KG-based CoT Evaluation* (ArXiv 2024) | 知識グラフ整合でステップ真偽を自動判定。 |
| 24 | *ThinkFirst* (ArXiv 2025) | 自然CoTをブロック分割し視覚タスク性能↑。 |
| 25 | *DLCoT* (ArXiv 2025) | 長文CoTをセグメント化＋簡素化で数学効率↑。 |
| 26 | *COT-SEP* (ArXiv 2024) | プロンプト記号で思考／回答を分離し安定化。 |
| 27 | *WizardMath* (ArXiv 2023) | PRM+IRM報酬で7BモデルがGSM8K 83.2 %。 |
| 28 | *Reinforcement Pre-Training* (ArXiv 2025) | 次トークン一致を報酬にPPO pretrain→ARC +4.5 pt。 |
| 29 | *Transformers Learn ICL via Gradient Descent* (NeurIPS 2022) | attention が暗黙GDを模倣すると示唆。 |
| 30 | *Implicit Gradient Descent in ICL* (ICLR 2023) | MLP層に潜む暗黙勾配を解析。 |
| 31 | *Meta-Learning & Memory in Transformers* (2022) | ICLをメタ学習的に説明。 |
| 32 | *Negation: A Pink Elephant in the LLMs' Room?* (ArXiv 2025) | 否定文は依然苦手と報告。 |
| 33 | *Word Order Does Matter* (EMNLP 2022) | 語順シャッフルで性能低下を定量化。 |
| 34 | *When Does Word Order Matter?* (ArXiv 2024) | 冗長文では影響小と分析。 |
| 35 | *High-Quality N-best Lists for MBR* (ACL 2022) | MTでN≈20が最適と実証。 |
| 36 | *Is MAP Decoding All You Need?* (EMNLP 2020) | MBRとMAPを比較しN50が十分と示す。 |
| 37 | *SGen: Selective Generation* (ArXiv 2023) | Entailment判定で誤出力を拒否。 |
| 38 | *Reflection-Window Decoding* (ICML 2025) | 自己検証ウィンドウで品質↑計算↓。 |
| 39 | *Self-Evaluation Decoding* (ArXiv 2024) | Chaotic 点を自己評価して再探索。 |
| 40 | *AdaDec* (ArXiv 2025) | エントロピー閾値でadaptive再探索、Pass@1 +15.5 %. |
| 41 | *Collaborative Decoding of Critical Tokens* (ArXiv 2024) | 重要語だけ別モデルが検証し幻覚減。 |
| 42 | *ELLM: Exploring with LLMs* (ICML 2023) | LLM生成ゴールでRLエージェント探索を強化。 |
| 43 | *Self-Rewarding Language Models* (OpenReview 2024) | LLMが自身の出力を報酬化してDPO学習。 |
| 44 | *AmbigNLI* (EMNLP 2020) | 多義的文で複数正解アノテ。 |

## 4. アプリ／ツールアイデア
| 🛠️ アイデア | 目的 / 機能 |
|--------------|-------------|
| 「速報＋深掘り」二段階LLM | 即席サマリを返し、裏でo3系エージェントが詳細調査→後追い通知 |
| Tool-use Hybrid Assistant | 通常LLMで高速応答→不確実性高ならo3/Toolformer fallback |
| PRM付きMath Tutor | WizardMath方式PRMで学習過程を自動評価しフィードバック |
| ICL暗黙勾配可視化ツール | 入力few-shot例とattention差分をヒートマップ表示 |

## 5. ユーザーが特に関心を示した論文（詳細解説）

### 1. *Next-Token Prediction Should be Ambiguity-Sensitive* (ICLR 2024)
自然言語の曖昧性を踏まえ「唯一正解」を強制する損失を再考。曖昧トークン集合に対し確率質量を分散させるAmbiguity-Sensitive Lossと、曖昧文脈でのメタ学習ループを提案し、多候補分布の保持とBLEU維持を両立。ユーザーは「トークン以外を予測？」と深掘り。

### 2. *ReAct: Synergizing Reasoning and Acting in Language Models* (NeurIPS 2022)
Thought→Action→Observation ループをLLMに実装。検索・環境操作タスクでAct-onlyより最大+26pt。ユーザーはツール呼出し判断や強化学習拡張の可能性を重点議論。

### 3. *Reflexion: Language Agents with Verbal RL* (NeurIPS 2023)
失敗後に言語で“反省”し戦略を更新するエージェント枠組み。ALFWorld成功率45→92%。ユーザーはSelf-Consistencyとの違いを質問し、自己改善能力に興味。

### 4. *WizardMath: Empowering Mathematical Reasoning for LLMs* (ArXiv 2023)
Process Reward ModelがCoTステップを評価、PPOで強化。7BモデルながらGSM8K 83.2 %・MATH 33%。推論ステップの区切りとPRM作成法を詳細に議論。

### 5. *Reinforcement Pre-Training* (ArXiv 2025)
事前学習にトークン一致報酬を導入しPPOで最適化。ARC-Challenge +4.5 ptと初のRL型Pretraining成果を報告。ユーザーは「事前学習でRL？」と強く関心。


