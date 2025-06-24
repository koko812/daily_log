# OT・KL・NeRF・PDE 連続対話まとめ

## 1. セッション全体の流れ
| 時系列 | 主な話題 | 技術タグ |
|--------|----------|-----------|
| ⌚ ① OT vs. KL 基礎 | Wasserstein距離の強み／JS・KLの勾配消失 | #OptimalTransport #GAN |
| ⌚ ② Gaussian例でのOT写像 | サポート重なり・KL計算可否 | #MeasureTheory |
| ⌚ ③ RL・模倣学習での距離選択 | WIL, WPG, DPO 正則化 | #ReinforcementLearning |
| ⌚ ④ MMD導入 | サンプルベース分布比較 | #KernelMethods |
| ⌚ ⑤ Disentanglement | β-VAE、FactorVAE、弱教師あり軸割り当て | #RepresentationLearning |
| ⌚ ⑥ NeRF × Diffusionでの3D再構成 | NerfDiff, Zero-1-to-3, ReconFusion | #NeuralRendering |
| ⌚ ⑦ NeRFとラドン変換の数理 | Fourier特性・逆問題安定性 | #InverseProblems |
| ⌚ ⑧ PDEを解くNN | PINNs, FNO など | #PhysicsML |

---

## 2. 議論が深まったトピック
- **OT と KL の違い・適材適所**  
  - GAN 安定化・サポートズレ・計算量を多角的に比較  
- **Disentanglement の実用性**  
  - β-VAE の軸不定性と弱教師あり手法 (Gated-VAE, SW-VAE) の有効性  
- **NeRF とラドン変換の理論的接続**  
  - フィルタ付き逆射影とニューラルリッジ関数の可逆性  
- **拡散モデルによる少⾯数 3D 再構成**  
  - NerfDiff / ReconFusion の prior 補完戦略  
- **PDE ソルバ NN の応用範囲**  
  - PINNs の逆問題適用と FNO の高速汎化

---

## 3. 論文リスト（完全網羅）

| タイトル | 年・会議 | 1〜2行要約 |
|----------|---------|-----------|
| Sinkhorn Distances: Lightspeed Computation of Optimal Transport | 2013 NeurIPS | エントロピー正則化で OT を GPU 可能に。 |
| Wasserstein GAN | 2017 ICML | JS の勾配消失を解決、1-Lipschitz 制約。 |
| Computational Optimal Transport | 2019 F&TML | OT 理論と応用の決定版チュートリアル。 |
| Wasserstein Imitation Learning | 2020 NeurIPS | GAIL を OT 距離で安定化。 |
| Wasserstein Policy Gradient | 2021 NeurIPS | 方策更新に Wasserstein 正則化。 |
| Preference Matching via Optimal Transport | 2022 arXiv | OT 距離で人間嗜好をマッチング。 |
| β-VAE: Learning Basic Visual Concepts with a Constrained Variational Framework | 2017 ICLR | KL に β 重みを乗せ disentanglement を誘導。 |
| FactorVAE | 2018 ICLR | Total-Correlationペナルティで軸分離を強化。 |
| DIP-VAE II | 2018 ICLR | 共分散対角化で隠れ変数独立性を促進。 |
| Gated-VAE | 2019 ICLR | ペア教師付きで特定因子を軸固定。 |
| SW-VAE | 2022 CVPR | Factor swapping による weak supervision。 |
| Locatello et al. Weakly-Supervised Disentanglement without Compromises | 2020 ICML | 変更要因数だけの弱教師で理論保証。 |
| NerfDiff: Single-image View Synthesis with NeRF-guided Distillation from 3D-aware Diffusion | 2023 ICML | 拡散 prior で隠れ面を補完し単眼NeRFを高精細化。 |
| Zero-1-to-3: Zero-shot One Image to 3D Object | 2023 ICCV | 回転条件付き Diffusion でゼロショット 3D。 |
| ReconFusion | 2024 CVPR | 少数写真＋拡散 prior でNeRF品質向上。 |
| Difix3D+ | 2025 CVPR | シングルステップDiffusionで高速3D補正。 |
| GS-Diff | 2025 arXiv | Gaussian Splatting + Diffusion で大規模屋外再構成。 |
| FourieRF | 2025 arXiv | 周波数カリキュラムで few-shot NeRF を安定化。 |
| BANF: Band-limited Neural Fields | 2024 arXiv | 多解像度正則化で逆問題を安定化。 |
| Ridges, Neural Networks, and the Radon Transform | 2023 JMLR | ReLUネットをラドン理論で解析し可逆性を証明。 |
| Tomographic Inverse Problems: Mathematical Challenges and Stability | 2023 Oberwolfach Report | ラドン系逆問題の安定性とニューラル応用を総覧。 |
| PINNs | 2019 JCP | PDE解に物理損失を課す NN ソルバ。 |
| DeepONet | 2021 Nature Machine Intelligence | 関数→関数写像を学ぶ演算子 NN。 |
| Fourier Neural Operator | 2021 NeurIPS | スペクトル畳み込みで高速 PDE 予測。 |
| Meta-PDE | 2023 ICLR | 複数PDEをメタ学習で高速適応。 |

---

## 4. アプリ／ツールアイデア

| 名前 | 目的 | 機能概要 |
|------|------|----------|
| OT vs. KL Visualizer | 距離比較学習 | Gaussian例で移動マップと数値比較を即表示 |
| β-VAE Disentangle Lab | 潜在軸可視化 | 軸ごとのKLを棒グラフ＋スライダーで操作 |
| NeRF-Radon Inspector | 理論可視化 | ラドン投影・逆射影とNeRFレンダの対応を並列表示 |
| PDE-PINN Notebook | 物理NNデモ | 熱方程式／Navier-StokesをPINN/FNOで解く比較 |

---

## 5. ユーザーが特に関心を示した論文（詳細要約）

### β-VAE (Higgins et al., ICLR 2017)
制約付きELBOでKL項をβ倍にするだけのシンプル改良で、潜在次元ごとに独立した意味軸を形成。大きなβは情報容量を絞り、独立要因が一軸に集約されやすくなる。教師なし disentanglement のベースラインとして広範に採用され、後続理論解析（TCVAE 等）の出発点となった。

### NerfDiff (Gu et al., ICML 2023)
単一画像からのNeRF合成を改善するため、3D-aware拡散モデルで仮想ビューを生成→NeRFを逆蒸留。拡散priorで裏面情報を補い、従来のsingle-view NeRFの“ぼやけ”問題を大幅に解決。few-shot 3D生成の品質向上に大きく寄与した。

### Zero-1-to-3 (Liu et al., ICCV 2023)
画像1枚だけを入力し、カメラ回転ベクトルを条件にStable Diffusion派生モデルが任意視点像を生成。生成結果を用いて自動的に3Dフィールドを再構成できるゼロショットパイプラインを提案し、データ収集コストを激減させた。

### Ridges, Neural Networks, and the Radon Transform (Unser, JMLR 2023)
ReLUネットの出力をリッジ関数集合として解析し、ラドン変換の逆射影とネットワーク構造の等価性を数学的に証明。NeRFなど射影型ニューラルレンダリングの理論的可逆性・情報損失評価に新しい道を拓く。

### Tomographic Inverse Problems: Mathematical Challenges and Stability (Oberwolfach 2023)
ラドン変換を核とするCT/PET逆問題の最新数学課題を俯瞰し、動的シーン・少数射影・ノイズ環境での安定化手法を整理。NeRFやDiffusion-NeRFなど機械学習系再構成の理論的基盤づくりに重要なインサイトを提供。

