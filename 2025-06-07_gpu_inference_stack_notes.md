# 📚 技術メモ：LLM・GPU・推論最適化 総まとめ

## 1. セッション全体の技術トピック一覧

* CUDA バージョン・コンパイラ（`nvcc`, PTX, LLVM IR, SASS）
* FlashAttention（O(n²) → 高速化）
* vLLM & PagedAttention（KV キャッシュのページング）
* Triton *DSL* と Triton Inference Server の違い
* Sliding‑Window / Longformer 系 Attention
* World Model & VAE 圧縮・Symbol Grounding
* wheel 形式・ビルド/ホスティング手法（Transformers vs vLLM vs Triton）
* Ninja / CMake ビルドパイプライン
* 共用 GPU サーバー運用 & FastAPI タイムアウト

---

## 2. トピックごとの詳細解説

### ⚡ FlashAttention

* **ユーザーの初期疑問**

  > 「FF 層の方が大きいのでは？ Attention を高速化してもあまり効かないのでは？」

* **アシスタントの回答要約**

  * FF は **O(n)**、Self‑Attention は **O(n²)**。
  * FlashAttention は *ブロック分割 + fused CUDA kernel* で `scores` を保持せず計算⇢メモリ・帯域抜本削減。

* **発展的な話題・関連技術**

  * xFormers にも Flash 相当実装あり。
  * Longシーケンス→Sliding Window や BigBird などと併用可。

* **重要用語・背景知識**

  * *FLOPs*：演算回数
  * *fused kernel*：計算+メモリアクセスを 1 カーネルに統合

* **ユーザーが得た理解・気づき**

  > 「長文で O(n²) が支配的になるから Attention 最適化が重要だと納得。」

---

### 🚀 vLLM & PagedAttention

* **ユーザーの初期疑問**

  > 「Flash‑Attention と vLLM は共存？ どちらがどれぐらい速さに寄与？」

* **アシスタントの回答要約**

  * FlashAttention = *1 トークン毎の計算高速化*（20‑40 %）。
  * PagedAttention = *マルチリクエストのメモリ効率*（40‑60 % スループット向上）。
  * vLLM 内部で FlashAttention を有効にできる（`VLLM_USE_FLASH_ATTENTION=1`).

* **発展的な話題**

  * vLLM は推論専用。訓練は効率悪。
  * Transformers/FastAPI 直接推論との速度比較。

* **重要用語**

  * *KV キャッシュ*：過去トークンの Key/Value 行列を保持。
  * *ページング*：固定長ブロックに分けて再利用。

* **ユーザーの気づき**

  > 「モデル常駐ホスティングで毎回ロードせず実験が高速になる。」

---

### 🧰 CUDA バージョン・コンパイラまわり

* **ユーザーの初期疑問**

  > 「CUDA 11.7 と 12.1 の“狭間”って何？ GPU バージョン？ 互換性は？」

* **回答要約**

  * 数字は **CUDA Toolkit** バージョン。GPU 世代(CC)とは別。
  * 後方互換が壊れやすく、PyTorch もバージョンごとに紐づく。
  * `nvcc` が `.cu→PTX→SASS` を生成。LLVM IR は Triton が使う中間表現。

* **重要用語**

  * *PTX （Parallel Thread Execution）*: NVIDIA 仮想 GPU ISA。
  * *SASS*: GPU 実機の命令。
  * *ninja*: CMake が生成するビルドを高速に実行するツール。

---

### 📦 wheel・ビルド & ホスティング

* **ユーザーの初期疑問**

  > 「wheel って何？ 自分の環境に合わないと使えない？ pip install wheel すると動く理由は？」

* **回答要約**

  * `.whl` はビルド済みバイナリパッケージ。環境タグが一致しないと使えない。
  * `pip install wheel` は **wheel 製造ライブラリ**を入れるだけ。
  * vLLM・Triton をホスティングすれば wheel 再ビルドせず高速実験可能。

* **関連リンク**

  * Python Packaging PEP 425 / 517

---

### 🔄 Sliding Window & Long Context

* **ユーザー疑問**

  > 「Sliding Window だと遠距離の参照（1行目⇢100万行目）は無理では？」

* **回答要約**

  * Window だけでは無理。Global Token 付与 or Retrieval / Memory Networks 併用で可能。

---

### 🤖 World Model・VAE 圧縮 & Symbol Grounding

* **疑問**: 「VAE で latent に考えを圧縮→解釈は？」
* **回答**:

  * VAE latent は必ずしも interpretable でない。β‑VAE, Slot Attention など disentangle 研究が進行。
  * Symbol Grounding 問題と密接。Grounded latent + LLM probing が次の課題。

---

## 3. 総括

* **最大の学び**: GPU 大規模推論の高速化は「計算最適化（FlashAttention）」と「メモリ・並列効率（PagedAttention/vLLM）」の**二本柱**。
* **視点の変化**: FF層より Attention の O(n²) がボトルネック → だから Flash系が重要、と認識。
* **今後の探究ポイント**:

  1. vLLM + Triton Inference Server の統合オーケストレーション。
  2. Long Context モデルでの Retrieval や Memory Augmentation 実装。
  3. VAE latent と LLM hidden state を橋渡しする「Grounded latent probing」研究。

---

> *作成日時: 2025-06-07*

