class TaxCalculator
  def calculate(price, region)
    if region == :japan
      price * 1.1  # 10% 消費税
    elsif region == :us
      price * 1.07 # 7% Sales tax
    elsif region == :eu
      price * 1.2  # 20% VAT
    else
      raise "Unknown region"
    end
  end
end

calculator = TaxCalculator.new
puts calculator.calculate(1000, :japan) # => 1100
puts calculator.calculate(1000, :us)    # => 1070
puts calculator.calculate(1000, :eu)    # => 1200