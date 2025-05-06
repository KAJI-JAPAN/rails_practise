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

# strategyパターンへリファクタ
class TaxCalculatorAbstract
  def calculateTax(region)
    raise "Unknown notification region"
  end
end

class Japan < TaxCalculatorAbstract
  def calculateTax(price)
    price * 1.1  # 10% 消費税
  end
end

class Us < TaxCalculatorAbstract
  def calculateTax(price)
    price * 1.07 # 7% Sales tax
  end
end

class Eu < TaxCalculatorAbstract
  def calculateTax(price)
    price * 1.2  # 20% VAT
  end
end

# 選択する
class SelectedTaxCalculator
  def self.build(region)
    case region
    when :japan
      Japan.new
    when :us
      Us.new
    when :eu
      Eu.new
    else
      raise "Unknown region"
    end
  end
end

# 使う
class StrategyRefactoring2
  def initialize(strategy_type)
    @strategy_type = strategy_type
  end
  def calculateTax(price)
    @strategy_type.calculateTax(price)
  end
end