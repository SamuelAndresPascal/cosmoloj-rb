require_relative "unit-simple"
require "test/unit"

class TestSimpleUnit < Test::Unit::TestCase

  def test_transformed

    metre = FundamentalUnit.new()
    k_metre = metre * 1000
    c_metre = metre / 100
    cm_to_km = c_metre >> k_metre

    assert_in_delta 0.00003, cm_to_km.convert(3.0), 1e-10
    assert_in_delta 3.0, (~cm_to_km).convert(0.00003), 1e-10
  end

  def test_derived

    metre = FundamentalUnit.new()
    k_metre = metre * 1000

    km2 = k_metre ** 2
    c_metre = metre / 100
    cm2 = c_metre ** 2
    km2_to_cm2 = km2 >> cm2

    assert_in_delta 30000000000.0, km2_to_cm2.convert(3.0), 1e-10
    assert_in_delta 3.0, (~km2_to_cm2).convert(30000000000.0), 1e-10
  end

  def test_combined_dimension_derived

    metre = FundamentalUnit.new()
    k_gram = FundamentalUnit.new()
    gram = k_gram / 1000
    ton = k_gram * 1000
    g_per_m2 = gram / metre ** 2
    k_metre = metre * 1000
    ton_per_km2 = ton * ~k_metre ** 2
    c_metre = metre / 100
    ton_per_cm2 = ton * ~(c_metre ** 2)
    g_per_m2_to_ton_per_km2 = g_per_m2 >> ton_per_km2
    g_per_m2_to_ton_per_cm2 = ton_per_cm2 << g_per_m2

    assert_in_delta 1.0, g_per_m2_to_ton_per_km2.convert(1.0), 1e-10
    assert_in_delta 3.0, (~g_per_m2_to_ton_per_km2).convert(3.0), 1e-10
    assert_in_delta 1e-10, g_per_m2_to_ton_per_cm2.convert(1.0), 1e-20
    assert_in_delta 3e-10, g_per_m2_to_ton_per_cm2.convert(3.0), 1e-20
    assert_equal 0.0, g_per_m2_to_ton_per_cm2.offset()
    assert_equal 1e-10, g_per_m2_to_ton_per_cm2.scale()
    assert_equal -0.0, (~g_per_m2_to_ton_per_cm2).offset()
    assert_in_delta 3.0, (~g_per_m2_to_ton_per_cm2).convert(3e-10), 1e-10
  end

  def test_temperatures

    kelvin = FundamentalUnit.new()
    celcius = kelvin + 273.15
    k_to_c = kelvin >> celcius

    assert_in_delta -273.15, k_to_c.convert(0), 1e-10
    assert_in_delta 273.15, (~k_to_c).convert(0), 1e-10

    # en combinaison avec d'autres unites, les conversions d'unites de temperatures doivent devenir lineaires
    metre = FundamentalUnit.new()
    c_per_m = celcius / metre
    k_per_m = kelvin / metre
    k_per_m_to_c_per_m = k_per_m >> c_per_m

    assert_in_delta 3.0, k_per_m_to_c_per_m.convert(3.0), 1e-10
    assert_in_delta 3.0, (~k_per_m_to_c_per_m).convert(3.0), 1e-10
  end

  def test_speed

    metre = FundamentalUnit.new()
    k_metre = metre * 1000.0

    second = FundamentalUnit.new()
    hour = second * 3600.0

    metre_per_second = metre / second
    kmh = k_metre / hour

    ms_to_kmh = metre_per_second >> kmh

    assert_in_delta 360.0, ms_to_kmh.convert(100.0), 1e-10
    assert_in_delta 5.0, (~ms_to_kmh).convert(18.0), 1e-10
  end
end
