# 🔧 2025-06-10 VAE Latent-Space Explorer & 内在次元考察

## 1. **セッション全体の技術トピック一覧**
- ConvVAE の学習設定（β, free bits, latent_dim=2）
- 潜在空間可視化（scatter, grid decode, latent walk GIF）
- Streamlit でのスライダー付き GUI 実装
- 主成分分析 (PCA)・パレート仮定・TWO-NN による内在次元推定
- StyleGAN の latent walk／意味軸
- 固有次元を扱う代表論文（ICLR 2021, CVPR 2019, SciRep 2017）
- README / CHANGELOG 自動生成フロー

---

## 2. **トピックごとの詳細解説**

### ConvVAE 学習 & 可視化

- **ユーザーの初期疑問**  
  > 「latent_dim = 2 だと数字がボヤけるのでは？」  
  > 「再構成がまともに見える設定が知りたい」

- **アシスタントの回答要約**  
  - β=1 だと情報ボトルネックでぼやけやすい。Free Bits & β warm-up を導入して安定化。  
  - 2 次元 latent をそのまま scatter、高次元は PCA/UMAP を推奨。  
  - `visualize_latent_grid.py` で \[-3,3\]² をデコード→グリッド画像生成。

- **発展的な話題・関連技術**  
  - β-VAE / FactorVAE で disentangle  
  - latent_dim を 4 → 256 に上げ、PCA 主軸をスライダーに割り当てる案

- **重要な用語・背景知識**  
  - *Free Bits*：KL 1 次元あたり ε までノーカウントにして collapse を防ぐ  
  - *Posterior Collapse*：KL 項が強くて z が無意味になる現象

- **ユーザーが得た理解・気づき**  
  > 「latent_dim=2 でもクラスクラスタが綺麗に分かれる！」  
  > 「Free Bits で再構成を犠牲にせず KL を制御できるのか」

---

### Streamlit スライダー UI

- **ユーザーの初期疑問**  
  > 「scatter 上で自分の点を動かして、横に生成画像を出したい」  
  > 「画像とグラフを横並び・同サイズで配置したい」

- **アシスタントの回答要約**  
  - `st.slider` ×2 で z1,z2 を操作 → `model.decode` で即時画像更新。  
  - `st.columns([1,1], gap="large")` で左右均等レイアウト。  
  - `.npy` キャッシュ (`Z`, `labels`) を読み込み 1 万点 scatter でも高速。

- **発展的な話題・関連技術**  
  - Gradio/Dash との比較、HuggingFace Spaces へのデプロイ  
  - お気に入り z のスナップショット保存 & GIF 出力

- **重要な用語・背景知識**  
  - `@st.cache_resource`: GPU メモリを保持したまま再実行を高速化  
  - Streamlit `set_page_config` は **最初の 1 行目で呼ぶ** 制約

- **ユーザーが得た理解・気づき**  
  > 「GUI で z を動かすと学習した manifold が直感的にわかる！」

---

### 内在次元推定 & パレート仮定

- **ユーザーの初期疑問**  
  > 「画像を ‘何次元まで’ 落とせるか語っている論文は？」  
  > 「TWO-NN のパレート仮定って何？」

- **アシスタントの回答要約**  
  - ICLR 2021 *Random Subspace Training*、CVPR 2019 *DeepMDS*、SciRep 2017 *TWO-NN* を紹介。  
  - TWO-NN：最近傍距離比 μ=r₂/r₁ がパレート分布になるという局所幾何仮定。  
  - パラメータ α の逆数で内在次元を推定。

- **発展的な話題・関連技術**  
  - InfoMax-VAE / Total-Correlation VAE で有効次元を圧縮  
  - 高次元表現の ISOMap / LocalMDS 系

- **重要な用語・背景知識**  
  - *パレート分布*：ロングテール分布 f(x)=α xᵐᵢₙᵅ / xᵅ⁺¹  
  - *Intrinsic Dimension*: 多様体が実際に占める最小座標自由度

- **ユーザーが得た理解・気づき**  
  > 「TWO-NN は距離計算だけで次元が出せるのね、軽い！」

---

## 3. **総括**

- **Latent 2D でもクラス分離が可能**：free bits + β 調整が鍵。  
- **Streamlit UI によって研究デモが即戦力化**：操作→結果のフィードバックが圧倒的に早い。  
- **内在次元推定の理論的背景**を押さえたことで、**latent_dim 設計の指針**が得られた。  
- 次ステップは **latent_dim 拡張 + PCA 射影 UI** と **外部画像→z 推定**。GUI と理論がつながり、探索サイクルが高速化した一日だった。

