class Unsubscribe
  def initialize(list_id)
    @list_id = list_id
  end

  def call(email)
    members(md5(email)).update(:body => {:status => "unsubscribed"})
  rescue Gibbon::MailChimpError => error
    raise error unless error.title == 'Member Exists'
  end

  private

  attr_reader :list_id

  delegate :members, :to => :list

  def gibbon
    Gibbon::Request.new
  end

  def list
    gibbon.lists(list_id)
  end

  def md5(text)
    Digest::MD5.hexdigest text.downcase
  end
end
