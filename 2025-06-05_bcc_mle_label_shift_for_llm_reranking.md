# 🧠 考察メモ: Label Shift 下における Bias-Corrected Calibration の活用と応用可能性

## 🔍 対象論文

* **論文名**: Maximum Likelihood with Bias-Corrected Calibration is Hard-To-Beat at Label Shift Adaptation
* **著者**: Amr M. Alexandari, Anshul Kundaje, Avanti Shrikumar
* **会議**: ICML 2020
* **リンク**: [https://proceedings.mlr.press/v119/alexandari20a.html](https://proceedings.mlr.press/v119/alexandari20a.html)

---

## 🎯 問題設定：Label Shift

\*\*Label Shift（ラベルシフト）\*\*とは、

* 訓練時とテスト時で **ラベルの分布 P(y)** が異なり、
* **条件付き分布 P(x|y)** は変化しない（共変量シフトなし）

という仮定の下で、分類モデルを適応させる問題である。

例えば：

* 学習時：猫50%, 犬50%
* テスト時：猫20%, 犬80%

このような状況では、訓練されたモデルの出力確率（事後分布）にバイアスが生じ、性能が劣化する。

---

## 📌 論文の主張と貢献

### ✅ 主張

> ラベルシフト下での適応は、モデルの予測確率を **バイアス補正キャリブレーション（BCC）** した上で、
> **テストラベル分布 q(y)** を最大尤度推定（MLE）するという非常にシンプルな手法でも競合手法に匹敵 or 優越する。

### ✅ 提案手法の構成（BCC + MLE）

1. **BCC（Bias-Corrected Calibration）**：

   * バリデーションセット上で、各ラベル $y$ に対するモデルの予測分布 $p(y|x)$ の平均をとり、
     モデルの出力分布を補正（温度スケーリングなどと併用可能）。
2. **MLE によるラベル分布の推定**：

   * テストデータ $\{x_i\}_{i=1}^{n}$ における log-likelihood：

     $$
     \max_{q(y)} \sum_{i=1}^n \log\left( \sum_y q(y) \hat{p}(y|x_i) \right)
     $$
   * これは凸最適化問題であり、簡易な EM や固定点反復でも解ける。

### ✅ 実証結果

* **MNIST**, **CIFAR-10/100**, **網膜症分類**などの実験で、
  他のラベルシフト適応手法（BBSE, RLLSなど）より一貫して良好 or 同等の性能。

---

## 🔎 応用に向けた考察（LLM + Beam Outputs + Calibration）

### ⚠️ LLMにおける log probability の比較問題

* 複数の LLM が異なるスケール・温度・tokenization に基づいて対数尤度を出力する。
* したがって、**出力 logprob による単純な比較にはバイアスがある**。

### 💡 アナロジー：LLM = classifier, 出力 = soft prediction

* モデル $M_k$ が、プロンプトに対して複数の出力ビーム $\{y_j\}$ を出力し、それぞれに log probability を割り当てる。
* 各モデルに対して：

  * Validation-like セットで出力分布 $p_k(y)$ を取得
  * その分布と比べて、テスト出力の logprob を補正（＝キャリブレーション）

### 🧠 LLM適用の擬似的定式化

1. 各モデルごとに、プロンプトセット $\{x_i\}$ を使って出力分布を取得。
2. 各出力について：

   * **log probability を温度スケーリング / BCC によって補正**
3. 複数モデルの全出力候補 $\{y_j\}$ に対し：

   * **共通のスケールで logprob 比較・ランク付けが可能に**

---

## 📚 関連アイデア・補助技術

* Platt Scaling / Temperature Scaling（校正方法）
* Expected Calibration Error（ECE）による評価指標
* Multi-model ensembling における Soft Voting 正規化

---

## 📝 今後の応用案

1. LLM出力の対数尤度に対する BCC 変換層の導入
2. モデルごとの尤度特性を予め推定し、対数尤度の変換係数を学習
3. 複数モデル×複数ビームのランク統合処理で BCCベースの再ランク手法の導入

---

## ✍️ 結論

本論文が提案する **Bias-Corrected Calibration + MLE** の枠組みは、複数の LLM 出力を比較・ランク付けする場面においても有望。
特に、**異なるモデル・スケールの log probability を比較するための補正戦略**として導入することで、
単純な softmax 出力のスコア比較に潜むバイアスを低減し、より公正な reranking やアンサンブル選定が実現可能となる。

