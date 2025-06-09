# 🔧 2025-06-09 Variational-Autoencoder Stability & Experiment Log

## 1. **セッション全体の技術トピック一覧**
- Posterior Collapse と KL Annealing
- Free Bits 正則化の実装
- ミニバッチサイズと学習安定性
- Latent Dimensionality（2 ⇆ 4）と再構成品質
- 画像間補間（Latent Interpolation）
- 代表的安定化論文（δ-VAE, InfoVAE, BN-VAE 等）
- CIFAR / ImageNet における latent_dim の慣例値
- StyleGAN-VAE と InfoVAE の概要

## 2. **トピックごとの詳細解説**

### Posterior Collapse & KL Annealing
- **ユーザーの初期疑問**  
  > 「β=1 にしても KL が上がりませんねえ」  
- **アシスタントの回答要約**  
  - KL が 0 に張り付き decoder が z を無視＝collapse  
  - β を 0→目標値へ段階的に増やす “KL Annealing” を推奨  
- **発展的な話題・関連技術**  
  - Capacity Annealing, δ-VAE の下限 δ 制御  
- **重要な用語・背景知識**  
  - **ELBO**：再構成＋β×KL の総損失  
  - **β**：KL 正則化の重み  
- **ユーザーが得た理解・気づき**  
  > 「β を下げれば z に情報が通るが、生成品質も考慮が必要」  

---

### Free Bits 正則化
- **ユーザーの初期疑問**  
  > 「Free Bits ってどういうことなんですか？」  
- **アシスタントの回答要約**  
  - 各潜在次元の KL を ε 以上にクランプし、z を強制的に利用  
  - 実装は loss 関数で `torch.clamp(kl_mean, min=ε)`  
- **発展的な話題・関連技術**  
  - Adaptive Free Bits、KL-Warm-up との併用  
- **重要な用語・背景知識**  
  - **ε (free_bits_eps)**：1 dim あたりの最小情報量（nats）  
- **ユーザーが得た理解・気づき**  
  > 「collapse 回避のために“最低限の情報量”を保証できる」  

---

### バッチサイズと学習安定性
- **ユーザーの初期疑問**  
  > 「batch_size を下げたらモード崩壊が起きにくい？」  
- **アシスタントの回答要約**  
  - 小バッチは KL が滑らかに入りノイズも増えて collapse を防ぐ場合がある  
  - ただし収束速度・BN の安定性とのトレードオフ  
- **関連知見**  
  - ImageNet では δ-VAE が batch=1024 でも安定  

---

### Latent Dimensionality（2 vs 4）
- **ユーザーの初期疑問**  
  > 「latent 4 にしたら綺麗になるが 2 にこだわりたい」  
- **アシスタントの回答要約**  
  - dim=2 は可視化・解釈が直感的／情報量は限界が低い  
  - dim=4 で KL が自然に上がり再構成が改善  
- **ユーザーが得た理解・気づき**  
  > 「dim を増やせば質は上がるが、可視化の魅力を失う」  

---

### 画像間補間（Latent Interpolation）
- **ユーザーの初期疑問**  
  > 「画像間を滑らかに繋ぐ方法は？」  
- **アシスタントの回答要約**  
  - `z_interp = (1-α)z₁ + αz₂` → decoder に通す  
  - 高次元でも軸ごとに動かせば滑らかな遷移  
- **関連技術**  
  - Slerp 補間、β-VAE の disentangled 軸  

---

### 安定化論文 & 大規模データセット設定
- **ユーザー疑問**  
  > 「CIFAR の latent_dim はいくら？」 / 「StyleGAN-VAE, InfoVAE の年と会議は？」  
- **回答要約**  
  - CIFAR: 128–256、CelebA では 200–512  
  - StyleGAN-VAE: *WACV 2022* / InfoVAE: *AAAI 2019*  
- **ユーザー気づき**  
  > 「大規模画像ほど latent を 2 に絞るのは難しい」  

## 3. **総括**
- **得られた知見**  
  - β 調整だけでなく Free Bits や Warm-up など複合的手法が有効  
  - latent_dim=2 の強い圧縮では KL が上がらず collapse しやすい  
  - 高次元 latent では軸操作による意味的補間が実現しやすい  
- **視点の変化**  
  - 「モデルを弱める」だけでなく **損失側で情報量を保証する** 重要性を認識  
- **今後の探究ポイント**  
  - β-VAE / InfoVAE の公式設定を再現し、Free Bits との比較ベンチ  
  - Perceptual Loss 併用でシャープさを改善  
  - 2D latent の可視化ツール（グリッド生成・補間アニメ）の実装  

