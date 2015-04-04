require_relative './fixture_loader'

module FormHelper
  include FixtureLoader

  def complete_form(pricing_pkg)
    user = load_fixture('subscribers.yml').new_user

    visit(pricing_pkg)

    find('#first_name').set user.first_name
    find('#last_name').set user.last_name # what the world is going on here?
    find('#email').set user.email
    find('#company').set user.email

    fill_in_property(user.properties['property_1'])
    fill_in_with_vald_credit_card(user)

    find("#subscribe").click
  end

  def fill_in_property(property = {})
    find('#address').set property.address
    find('#zip_code').set property.zip_code
  end

  def fill_in_with_vald_credit_card(user = {})
    find('#number').set user.valid_card_number
    find('#month').set 8
    find('#year').set Time.now.year + 1
    find('#cvv').set user.cvv
  end
end
