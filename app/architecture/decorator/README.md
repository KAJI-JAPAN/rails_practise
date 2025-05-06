# Decoratorパターン
- 既存の処理を汚さずに動的に処理を追加する
- 基本的にはログなどが多い

# 図
**Decoratorじゃないパターン**
- それぞれのクラスにログを追加する必要がある
![スクリーンショット 2025-05-06 18 23 19](https://github.com/user-attachments/assets/234c21e0-c096-4ad8-a4ca-778f5e48d839)

**Decoratorパターン**
- 使う側が動的にログを追加していく
- superなどで親クラスの処理自体はそのまま返してログを追加する。
- ログクラスではログだけを追加する
![スクリーンショット 2025-05-06 18 24 07](https://github.com/user-attachments/assets/1cfe47ef-031e-47a3-91a2-b39267bfb8c4)
