class UnitConverter
    def scale
    end

    def offset
    end

    def inverse
    end

    def linear
    end

    def linear_pow
    end

    def convert
    end

    def concatenate
    end
end

class Factor
    def dim
    end

    def numerator
    end

    def denominator
    end

    def power
    end
end

class Unit < Factor

    def get_converter_to
    end

    def to_base
    end

    def shift
    end

    def scale_multiply
    end

    def scale_divide
    end

    def factor
    end
end

class FundamentalUnit < Unit

    def to_base
    end
end

class TransformedUnit < Unit

    def to_reference
    end

    def reference
    end

    def to_base
    end
end

class DerivedUnit < Unit

    def definition
    end

    def to_base
    end
end