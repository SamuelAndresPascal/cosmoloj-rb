require_relative "unit-simple"
require "test/unit"

class TestSimpleUnit < Test::Unit::TestCase

  def test_transformed

    metre = FundamentalUnit.new()
    k_metre = metre.scale_multiply(1000)
    c_metre = metre.scale_divide(100)
    cm_to_km = c_metre.get_converter_to(k_metre)

    assert_in_delta(0.00003, cm_to_km.convert(3.0), 1e-10)
    assert_in_delta(3.0, cm_to_km.inverse().convert(0.00003), 1e-10)
  end

end