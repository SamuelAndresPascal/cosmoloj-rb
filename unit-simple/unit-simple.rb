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

  def ~
    @inverse
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
    if (dim.is_a? Unit)
      @dim = dim
      @numerator = numerator
      @denominator = denominator
    else
      @dim = dim.dim
      @numerator = numerator * dim.numerator
      @denominator = denominator * dim.denominator
    end
  end

  def power
    @numerator.to_f / @denominator
  end

  def *(value)
    DerivedUnit.new(this, value)
  end

  def /(value)
    DerivedUnit.new(this, Factor.new(value, -1))
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

  def +(value)
    shift(value)
  end

  def -(value)
    shift(-value)
  end

  def *(value)
    if value.is_a? Factor
      DerivedUnit.new(self, value)
    else
      scale_multiply(value)
    end
  end

  def /(value)
    if value.is_a? Factor
      DerivedUnit.new(self, Factor.new(value, -1))
    else
      scale_divide(value)
    end
  end

  def >>(target)
    get_converter_to(target)
  end

  def <<(source)
    source.get_converter_to(self)
  end

  def **(value)
    DerivedUnit.new(Factor.new(self, value))
  end

  def ~
    return self ** -1
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
