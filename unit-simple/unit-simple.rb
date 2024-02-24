class UnitConverter

  attr_reader :scale
  attr_reader :offset
  attr_reader :inverse

  def initialize(scale, offset = 0, inverse = nil)
    @scale = scale
    @offset = offset
    if inverse == nil
      @inverse = UnitConverter.new(1.0 / @scale, -@offset.to_f / @scale, self)
    else
      @inverse = inverse
    end
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

  attr_reader :dim
  attr_reader :numerator
  attr_reader :denominator

  def initialize(dim, numerator, denominator = 1)
    @dim = dim
    @numerator = numerator
    @denominator = denominator
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
    target.to_base().inverse().concatenate(to_base())
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

  def factor(numerator, denominator = 1)
    Factor.new(self, numerator, denominator)
  end
end

class FundamentalUnit < Unit

  def to_base
    UnitConverters::IDENTITY
  end
end

class TransformedUnit < Unit

  attr_reader :to_reference
  attr_reader :reference

  def initialize(to_reference, reference)
    super()
    @to_reference = to_reference
    @reference = reference
  end

  def to_base
    reference().to_base().concatenate(to_reference())
  end
end

class DerivedUnit < Unit

  attr_reader :definition

  def initialize(*definition)
    super()
    @definition = definition
  end

  def to_base
    transform = UnitConverters::IDENTITY
    @definition.each do |factor|
      transform = factor.dim().to_base().linear_pow(factor.power()).concatenate(transform)
    end
    transform
  end
end
