# observer
# observerパターンの考え方
# PostPublisherのsubscribeで通知を貯める
# publish内で通知を出力
# その際に通知を持つだけのクラスに分ける
# 通知の管理を別のクラスに分ける

class PostPublisher
  def initialize
    @observers = []
  end

  def subscribe(observer)
    @observers << observer
  end

  def published(post)
    puts "通知を送ります"
    notify_observer(post)
  end

  class EmailNotifer
    def updatePost(post)
      puts "[Email]#{post.title}が投稿されました"
    end
  end

  class SlackNotifer
    def updatePost(post)
      puts "[Slack]#{post.title}が投稿されました"
    end
  end
end

  private
  def notify_observer(post)
    observers.each { |observer| observer.update(post) }
  end


#使用例
publisher = new PostPublisher
publisher.subscribe(EmailNotifer.new)
publisher.published(SlackNotifer.new)

Post = Struct.new(:title)
post = Post.new

publisher.published(post)

#=>
# 投稿された: Observerパターン理解！
# [Email] Observerパターン理解！ が投稿されました
# [Slack] Observerパターン理解！ が投稿されました