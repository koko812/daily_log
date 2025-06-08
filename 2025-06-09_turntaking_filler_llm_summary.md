# 音声対話におけるターンテイキング・相槌・フィラー生成 ― チャットセッションまとめ

## 1. セッションの要約（話題の流れ・登場技術・論文・今後の方針）
- **VAP (Voice Activity Projection)** を起点にターンテイキング予測の基礎と多言語・マルチモーダル発展を把握。  
- **TurnGPT 系**で文法情報だけでもターン予測が可能なことを確認し，RC-TurnGPT で「応答内容を条件にする」拡張を検討。  
- **Incremental VAP + LLM** によるリアルタイム応答生成システムの可能性を議論。  
- **相槌（バックチャネル）専用モデル**（リアルタイム VAP 派生，DA マルチタスクなど）で応答生成なし・タイミング最適化を深掘り。  
- **LLM音声生成におけるフィラー挿入**（FillerSpeech，Disfluency Insertion，SLIDE）を調査し，自然さ向上の指標・手法を整理。  
- **音声言語モデル (SLM) vs CLAP** を比較し，生成タスク⇄検索タスクでの主流モデルを整理。  
- **今後**：VAP/SLM/LLM 統合パイプラインの試作，フィラー音響特徴の自動抽出精度向上，文化依存ターンタイミングの適応が課題。

## 2. 議論が膨らんだ話題
- **ターン予測における文法 vs 音響プロソディー** の寄与比率とアブレーション手法  
- **応答候補を事前に持つ RC-TurnGPT** の柔軟性限界と，動的応答生成＋ターンタイミング統合案  
- **相槌タイミングの連続予測（VAP 派生）** と対話行為ラベルを併用した種類選択  
- **フィラー音声の音響的特徴**（持続時間・音高・フォルマント）と自動ラベリングの妥当性  
- **SLM と CLAP の目的差**（生成 vs 検索）と応用ドメイン

## 3. 論文一覧（タイトル / 年 / 会議 + 1-2 行要約）
| # | 論文 | 年 / 会議 | 概要 |
|---|------|-----------|------|
| 1 | Voice Activity Projection: Self-supervised Learning of Turn-taking Events | 2022 / **INTERSPEECH** | 過去3 sの音声から 2 s 先の VAD を連続予測し，ターン交代を高精度に推定する自己教師ありモデル。 |
| 2 | How Much Does Prosody Help Turn-taking? | 2022 / **SIGDIAL** | ピッチ操作などの摂動実験で，VAP が特に F0 変動を手がかりにしていると示す。 |
| 3 | Real-time and Continuous Turn-taking Prediction Using VAP | 2024 / **IWSDS** | VAP を CPU でリアルタイム動作させる実装を提示。 |
| 4 | Multilingual Turn-taking Prediction Using VAP | 2024 / **LREC-COLING** | 英・中・日の多言語モデルでターン予測性能を向上。 |
| 5 | Voice Activity Projection Model with Multimodal Encoders | 2025 / **arXiv** | 音声＋顔表情のエンコーダ統合で VAP 精度を底上げ。 |
| 6 | TurnGPT: A Transformer-based LM for Predicting Turn-taking | 2020 / **INTERSPEECH** | テキストのみで文法的完結性を学習し，ターン終端を 0.81 Acc で予測。 |
| 7 | Response-conditioned Turn-taking Prediction | 2023 / **ACL Findings** | 応答候補を条件にした TurnGPT 拡張で自然なターン交代を実現。 |
| 8 | Investigating the Impact of Incremental Processing and VAP on SDS | 2025 / **COLING** | Incremental ASR＋VAP で応答遅延を短縮しつつ自然さを検証。 |
| 9 | Sparrow-0: Transformer-based Turn-taking | 2025 / Tavus (Tech blog) | BERT系モデルで 100 ms ポーズ検出，動画エージェント応用。 |
| 10 | Yeah, Un, Oh: Continuous & Real-time Backchannel Prediction | 2024 / **arXiv** | VAP を微調整し，相槌適性スコアを 20 ms 解像度で連続出力。 |
| 11 | Dialogue Act-Aided Backchannel Prediction via MTL | 2023 / **EMNLP** | DA分類と相槌タイミングを同時学習し F1 +2 pt。 |
| 12 | Backchannel Generation Model for a Third-Party Listener Agent | 2022 / **ICMI** | タイミング＋形式予測を組み合わせた連続相槌生成。 |
| 13 | Backchannel Prediction Based on Who, When, What | 2024 / **INTERSPEECH** | 話者属性・進行状況・トピックで相槌 F1 +4 pt（韓国語）。 |
| 14 | Backchannel Prediction for Conversational Speech Using RNNs | 2017 / **IWSDS** | 早期 RNN ベースの相槌タイミングモデルとオープン実装。 |
| 15 | FillerSpeech: Human-Like TTS with Filler Prediction | 2025 / **ICLR** | LLM でフィラー位置＋種類＋スタイルを予測し，TTS へ統合。 |
| 16 | Enhancing Naturalness via Disfluency Insertion | 2024 / **ACL** | LoRA 微調整 LLM でフィラー/言い直しを挿入，自発性向上。 |
| 17 | SLIDE: Integrating SLM with LLM for Spoken Dialogue | 2025 / **ICASSP** | LLM→音素列→dGSLM で自然対話音声を生成し N-MOS/M-MOS 改善。 |
| 18 | Large-scale Contrastive Language–Audio Pretraining (CLAP) | 2022 / **NeurIPS** | 音声とテキストを対で表現学習し，検索・分類に強い。 |
| 19 | HuBERT: Self-Supervised Speech Representation Learning | 2021 / **ICASSP** | マスク予測で音声潜在トークンを学習；SLM の基盤表現。 |
| 20 | Generative / discrete GSLM | 2021 / **NeurIPS** | 音声トークンを自己回帰生成し，テキスト不要で会話を合成。 |
| 21 | AudioLM | 2022 / **arXiv** | マルチレベル離散化＋LM で長距離音声・音楽生成。 |
| 22 | VALL-E | 2023 / **arXiv** | HuBERT+GPT によるゼロショット音声クローン。 |
| 23 | SpeechLM | 2022 / **ACL** | 音声とテキストを統合学習し ASR/TTS 双方に活用。 |
| 24 | Fraundorf et al., Disfluency & Memory | 2014 / **Cognition** | フィラー/ポーズ位置が記憶に与える影響を実験検証。 |
| 25 | Shriberg, Phonetics of Disfluencies | 1999 / **Ph.D. Thesis / UCSB** | フィラーの音響時間統計を大規模分析。 |

## 4. セッション中に出たアプリ／ツールのアイデア
- **Whisper → TurnGPT/VAP → 相槌選択器**：リアルタイム相槌エージェント。
- **LLM+VAP エラー可視化ダッシュボード**：ターン予測失敗箇所のヒートマップ。
- **フィラー挿入 TTS プラグイン**：文章を人間らしく読み上げるブラウザ拡張。
- **文化適応ターンタイミング API**：国別パラメータで無音しきい値を可変。

## 5. ユーザーが特に興味を示した論文 2〜3 本の解説
| 論文 | キーアイデア | 意義 |
|------|--------------|------|
| **Voice Activity Projection** (INTERSPEECH 2022) | 3 s 音声から 2 s 先の発話確率カーブを自己教師ありで予測。GRU 版は軽量でリアルタイム向き。 | ターンテイキング連続予測を初めて定式化し，後続研究の基盤となった。 |
| **Response-conditioned Turn-taking Prediction** (ACL Findings 2023) | TurnGPT に「用意した応答」を条件付け，その応答を言うのに最適な取得タイミングをスコアリング。 | 応答内容とターンタイミングの結合を実現し，人間らしい割り込み制御に前進。 |
| **FillerSpeech** (ICLR 2025) | LLM でフィラー位置・種類・スタイルを予測 → TTS に統合。自動ラベリングで 50 k h コーパスからフィラー抽出。 | 音声合成に非流暢性を導入する初の大規模枠組み。自発性を損なわず自然さ向上を定量化。 |

## 6. 今後の方針（抜粋）
- VAP / TurnGPT / SLM を統合した **“発話生成＋タイミング制御” パイプライン**のプロトタイプ作成  
- フィラー検出精度向上のため，自動ラベラの誤検出分析と改良  
- 文化依存ターンタイミング・相槌間隔のパラメータ化と A/B テスト  


