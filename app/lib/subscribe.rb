class Subscribe
  def initialize(list_id)
    @list_id = list_id
  end

  def call(email, name = '')
    members.create(
      :body => {
        :email_address => email,
        :status        => 'pending',
        :merge_fields  => {:FULLNAME => name}
      }
    )
  rescue Gibbon::MailChimpError => error
    raise error unless error.title == 'Member Exists'
  end

  private

  attr_reader :list_id

  def gibbon
    Gibbon::Request.new
  end

  def members
    gibbon.lists(list_id).members
  end
end
