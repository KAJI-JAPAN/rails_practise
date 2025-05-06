# Strategyパターンの考え方
## 目的
- 拡張性を持たせたい
- コードの変更を最小限にする
- テストしやすくする

## 実装
- クラスに分ける
- どれを使用するかを「選択する」クラスを作る
- クラスにアクセスして「実装する」インターフェースを別で準備する
## 図
**Strategyではない**
- 実際にはelsifなどで通知クラス内でそれぞれのSlack、Email、SMSなどの通知処理を切り替えて行なっている
- Teamsクラスなどを追加する場合に通知クラス全部をいじるためSlack、Email、SMSクラス全てに影響が出る
- Teamsクラスを追加した際に全てのSlack、Email、SMSの項目をテストする必要がある
![スクリーンショット 2025-05-06 17 54 39](https://github.com/user-attachments/assets/2dc53dc7-869d-41ef-beeb-30c3fe8e2725)

**Strategy後**
- SMSクラス、Slackクラス、Emailクラスを作成
- Teamsクラスなどが追加されても変更が少ない。使う側が変更すれば良いだけ
- それぞれのクラスごとにテストもかけるので以前と違って通知クラス全体をテストする必要がない
![スクリーンショット 2025-05-06 17 57 31](https://github.com/user-attachments/assets/cab2cee6-ead4-41b9-b522-a10e2f6c639f)
