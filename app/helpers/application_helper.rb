# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TronprintHelper if Rails.env.production?

  def referral_link(attendee)
    event_accept_url(attendee.event, attendee.invite.code)
  end

  def team_string(event)
    array = event.organisers.split(/[\s,]+/)
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
      'return'        => confirmed_event_attendee_url(attendee.event, attendee),
      'rm'            => '1',
      'cancel_return' => cancelled_event_attendee_url(attendee.event, attendee),
      'custom'        => attendee.id,
      'notify_url'    => ipns_url,
      'cbt'           => 'Return to Trampoline'
    }
  end
end
