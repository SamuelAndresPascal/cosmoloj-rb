class UnitConverter

    def initialize(scale, offset = 0, inverse = nil)
        @scale = scale
        @offset = offset
        if inverse == nil
            @inverse = UnitConverter.new(1.0 / @scale, -@offset.to_f / @scale, self)
        else
            @inverse = inverse
        end
    end

    def scale
        @scale
    end

    def offset
        @offset
    end

    def inverse
        @inverse
    end

    def linear
        UnitConverters.linear(@scale)
    end

    def linear_pow(power)
        UnitConverters.linear(@scale ** power)
    end

    def convert(value)
        @scale * value + @offset
    end

    def concatenate(converter)
        UnitConverter.new(converter.scale() * @scale, convert(converter.offset()))
    end
end

class UnitConverters
    IDENTITY = UnitConverter.new(1)

    def self.linear(scale)
        UnitConverter.new(scale)
    end

    def self.offset(offset)
        UnitConverter.new(1.0, offset)
    end
end

class Factor

    def initialize(dim, numerator, denominator = 1)
        @dim = dim
        @numerator = numerator
        @denominator = denominator
    end

    def dim
        @dim
    end

    def numerator
        @numerator
    end

    def denominator
        @denominator
    end

    def power
        @numerator.to_f / @denominator
    end
end

class Unit < Factor

    def initialize()
        super(self, 1, 1)
    end

    def get_converter_to(target)
        target.to_base().inverse().concatenate(self.to_base())
    end

    def to_base
        raise 'not implemented abstract method to_base()'
    end

    def shift(value)
        TransformedUnit.new(UnitConverters.offset(value), self)
    end

    def scale_multiply(value)
        TransformedUnit.new(UnitConverters.linear(value), self)
    end

    def scale_divide(value)
        scale_multiply(1.0 / value)
    end

    def factor
        Factor.new(self, @numerator, @denominator)
    end
end

class FundamentalUnit < Unit

    def to_base
        UnitConverters::IDENTITY
    end
end

class TransformedUnit < Unit

    def initialize(to_reference, reference)
        @to_reference = to_reference
        @reference = reference
    end

    def to_reference
        @to_reference
    end

    def reference
        @reference
    end

    def to_base
        reference().to_base().concatenate(to_reference())
    end
end

class DerivedUnit < Unit

    def definition
    end

    def to_base
    end
end

u = UnitConverter.new(2, 5)
puts u.convert(3)
v = u.concatenate(u)
# puts v.convert(3)
# w = UnitConverter.new(5, 1, u)
puts u.inverse().convert(11)
puts u
puts u.inverse()
puts u.inverse().inverse()

m = FundamentalUnit.new()
km = m.scale_multiply(1000)
cm = m.scale_divide(100)
cv = km.get_converter_to(cm)
puts cv.convert(3)