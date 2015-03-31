require_relative './fixture_loader'

module FormHelper
  include FixtureLoader

  def complete_form(pricing_pkg, options = {})
    user = load_fixture('subscribers.yml').new_user
    visit(pricing_pkg)
    find('#email').set user.email
    find('#first_name').set user.first_name
    find('[name="user[][last_name]"]').set user.last_name # what the world is going on here?
    if options.delete(:multiple_properties)
      # TODO: not implemented yet
      user.properties.each_with_index do |(key, property_info), index|
        fill_in_property(index + 1, property_info)
        unless index + 1 > user.properties.count
          find('[role="add-property"]').click
        end
      end
    else
      fill_in_property(1, user.properties.values.first)
    end
    find("#subscribe").click
  end

  def fill_in_property(property_number, property = {})
    find("[name='properties[][address]']").set property.address
    find("[name='properties[][city]']").set property.city
    find("[name='properties[][zip_code]']").set property.zip_code
    find("[name='properties[][nickname]']").set property.nickname
  end
end
