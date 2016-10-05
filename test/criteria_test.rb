require 'minitest/autorun'
require 'backframe'

class CriteriaTest < Minitest::Test

  def test_map_maps_the_fields
    fields = [
      { code: 'first_name', data_type: 'textfield' },
      { code: 'last_name', data_type: 'textfield' },
      { code: 'role', data_type: 'select' },
    ]
    mapped = {
      first_name: 'textfield',
      last_name: 'textfield',
      role: 'select'
    }
    assert_equal mapped, Backframe::Criteria.map(fields)
  end

end
