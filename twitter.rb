class Twitter
  include Enumerable

  def initialize
    @tweets = []
  end

  def tweet(message)
    final_message = []
    message_chars = message.split("")

    0.upto(143) do |index|
      final_message << message_chars[index]
    end

    @tweets << final_message.join("")
  end

  def each(proc = nil)
    @tweets.each do |tweet|
      if block_given?
        yield(tweet)
      else
        proc.call(tweet)
      end
    end
  end

  def map(proc = nil)
    final_tweet = []
    @tweets.each do |tweet|
      if block_given?
        final_tweet << yield(tweet)
      else
        final_tweet << proc.call(tweet)
      end
    end

    final_tweet
  end

end