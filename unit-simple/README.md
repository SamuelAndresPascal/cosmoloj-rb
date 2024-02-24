# Simple Unit (implémentation Ruby)


## Utilisation

Utilisation des unités transformées :

```rb

metre = FundamentalUnit.new()
k_metre = metre.scale_multiply(1000)
c_metre = metre.scale_divide(100)
cm_to_km = c_metre.get_converter_to(k_metre)

cm_to_km.convert(3.0) # 0.00003
cm_to_km.inverse().convert(0.00003) # 3.0
```

Utilisation des unités dérivées :

```rb

metre = FundamentalUnit.new()
k_metre = metre.scale_multiply(1000)

km2 = DerivedUnit.new(k_metre.factor(2))
c_metre = metre.scale_divide(100)
cm2 = DerivedUnit.new(c_metre.factor(2))
km2_to_cm2 = km2.get_converter_to(cm2)

km2_to_cm2.convert(3.0) # 3e10
km2_to_cm2.inverse().convert(30000000000.0) # 3.0
```

Utilisation des unités dérivées en combinant les dimensions :

```rb

metre = FundamentalUnit.new()
k_gram = FundamentalUnit.new()
gram = k_gram.scale_divide(1000)
ton = k_gram.scale_multiply(1000)
g_per_m2 = DerivedUnit.new(gram, metre.factor(-2))
k_metre = metre.scale_multiply(1000)
ton_per_km2 = DerivedUnit.new(ton, k_metre.factor(-2))
c_metre = metre.scale_divide(100)
ton_per_cm2 = DerivedUnit.new(ton, c_metre.factor(-2))
g_per_m2_to_ton_per_km2 = g_per_m2.get_converter_to(ton_per_km2)
g_per_m2_to_ton_per_cm2 = g_per_m2.get_converter_to(ton_per_cm2)

g_per_m2_to_ton_per_km2.convert(1.0) # 1.0
g_per_m2_to_ton_per_km2.inverse().convert(3.0) # 3.0
g_per_m2_to_ton_per_cm2.convert(1.0) # 1e-10
g_per_m2_to_ton_per_cm2.convert(3.0) # 3e-10
g_per_m2_to_ton_per_cm2.offset() # 0.0
g_per_m2_to_ton_per_cm2.scale() # 1e-10
g_per_m2_to_ton_per_cm2.inverse().offset() # -0.0
g_per_m2_to_ton_per_cm2.inverse().convert(3e-10), # 3.0
```

Utilisation des températures (conversions affines et linéaires) :

```rb

kelvin = FundamentalUnit.new()
celcius = kelvin.shift(273.15)
k_to_c = kelvin.get_converter_to(celcius)

k_to_c.convert(0) # -273.15
k_to_c.inverse().convert(0) # 273.15

# en combinaison avec d'autres unites, les conversions d'unites de temperatures doivent devenir lineaires
metre = FundamentalUnit.new()
c_per_m = DerivedUnit.new(celcius, metre.factor(-1))
k_per_m = DerivedUnit.new(kelvin, metre.factor(-1))
k_per_m_to_c_per_m = k_per_m.get_converter_to(c_per_m)

k_per_m_to_c_per_m.convert(3.0) # 3.0
k_per_m_to_c_per_m.inverse().convert(3.0) # 3.0
```

Utilisation des conversions non décimales :

```rb

metre = FundamentalUnit.new()
k_metre = metre.scale_multiply(1000.0)

second = FundamentalUnit.new()
hour = second.scale_multiply(3600.0)

metre_per_second = DerivedUnit.new(metre, second.factor(-1))
kmh = DerivedUnit.new(k_metre, hour.factor(-1))

ms_to_kmh = metre_per_second.get_converter_to(kmh)

ms_to_kmh.convert(100.0) # 360.0
ms_to_kmh.inverse().convert(18.0) # 5.0
```

