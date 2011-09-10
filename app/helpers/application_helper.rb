# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TronprintHelper if Rails.env.production?

  def next_event
    @next_event ||= Event.next
  end

  def referral_link(attendee)
    accept_url(attendee.invite.code)
  end

  def all_released?
    Time.zone.now >= next_event.excess_at
  end

  def team
    ['Aida', 'Pat'].sort_by { rand }
  end

  def team_string
    array = team.clone
    if array.length == 2
      array.join(' and ')
    else
      array[0..-2].join(', ') + " and #{array.last}"
    end
  end

  def paypal_form_options(attendee)
    {
      'cmd'           => '_xclick',
      'business'      => IPNotification::Business,
      'item_name'     => 'Trampoline Ticket',
      'currency_code' => 'AUD',
      'amount'        => '25.00',
      'no_shipping'   => '1',
      'no_note'       => '1',
      'return'        => confirmed_attendee_url(attendee),
      'rm'            => '1',
      'cancel_return' => cancelled_attendee_url(attendee),
      'custom'        => attendee.id,
      'notify_url'    => ipns_url,
      'cbt'           => 'Return to Trampoline'
    }
  end
end
