# VAE 学習安定化セッション (2025-06-09)

---

## 1. セッションの要約
- **目的**：MNIST で latent_dim=2 の Conv-VAE を安定学習させる  
- **試行**：β アニーリング → バッチサイズ縮小 → Decoder 弱化 → Free Bits 導入  
- **観測**：KL が 0 に張り付き collapse、Free Bits で改善するも画質限界  
- **調査**：δ-VAE・InfoVAE 等の論文、CIFAR/ImageNet の latent_dim 慣例値  
- **展望**：お手本実装（β-VAE, InfoVAE, StyleGAN-VAE）の再現と比較ベンチ

---

## 2. 議論が膨らんだ話題
| 話題 | 深掘りポイント |
|------|---------------|
| Posterior Collapse | 原因分析、βの役割、KLアニーリングの実装方法 |
| Free Bits 正則化 | ε の選び方、実装箇所、βとの共存、効果測定 |
| Latent Dimensionality | dim=2 へのこだわり vs 再構成品質、可視化の利点 |
| 画像間補間 | 低次元補間グリッド、Slerp、意味軸操作 |
| 大規模画像データ | CIFAR・CelebA での latent_dim 128+ 慣行と理由 |
| 論文再現 | δ-VAE, InfoVAE, StyleGAN-VAE を次ステップ候補に選定 |

---

## 3. 📚 論文一覧と要約

| # | 論文タイトル | 会議 / 年 | 要約 |
|---|--------------|-----------|------|
| 1 | Preventing Posterior Collapse with **δ-VAE** | ICLR 2019 | KL に下限 δ を設け、強力 decoder でも collapse を原理的に防止 |
| 2 | **The Usual Suspects?** Reassessing Blame for VAE Posterior Collapse | ICML 2020 | collapse 要因を体系的に再評価し、学習設定の影響を検証 |
| 3 | **InfoVAE**: Balancing Learning and Inference in VAEs | AAAI 2019 | 相互情報量最大化項を追加し、潜在表現の情報損失を抑制 |
| 4 | **BN-VAE**: A Batch Normalized Inference Network Keeps the KL Vanishing Away | arXiv 2020 | Encoder に BatchNorm を導入し KL 消失を軽減 |
| 5 | AE-StyleGAN / **StyleGAN-VAE** | WACV 2022 | StyleGAN Generator＋Encoder をエンドツーエンド訓練、復元・生成を両立 |
| 6 | Lagging Inference Networks and Posterior Collapse | ICLR 2019 | “推論ネットワークの遅れ” を特定し、warm-up で対応 |
| 7 | Preventing Oversmoothing in VAE via Generalized Variance Parameterization | arXiv 2021 | 出力分散のパラメータ化で過度な平滑化を抑え、シャープさ維持 |

---

## 4. 📱 アプリアイデアと要約
- **Latent Interpolation Viewer**  
  2 つの入力画像を選び、latent 空間補間をスライダーで可視化・GIF 生成
- **Adaptive ε Tuner**  
  Free Bits ε を学習曲線に応じて自動調整するコールバックライブラリ
- **VAE Bench Dashboard**  
  β-VAE / InfoVAE 等をワンクリック比較、再構成・FID を自動レポート

---

## 5. 興味深い論文 5 本の詳解

1. **δ-VAE (ICLR 2019)**  
   KL に「硬い下限」を設ける設計。decoder が z を無視できず、batch=1024 の ImageNet でも collapse 無し。

2. **InfoVAE (AAAI 2019)**  
   ELBO に相互情報量項を追加。KL を弱めても潜在表現が豊富になり、生成・推論が安定。

3. **StyleGAN-VAE (WACV 2022)**  
   StyleGAN の高品質生成を維持しつつエンコーダを同時学習。再構成精度と編集性が両立。

4. **The Usual Suspects? (ICML 2020)**  
   “decoder の強さ” だけが悪者では無いと実証。学習率・バッチサイズも collapse に影響。

5. **BN-VAE (arXiv 2020)**  
   BatchNorm を encoder に入れるだけで KL が消えにくくなるシンプル手法。実装コストが低い点が魅力。

