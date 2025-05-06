
# strategyパターン
class TaxCalculatorAbstract
  def calculateTax(region)
    raise "Unknown notification region"
  end
end

class Japan < TaxCalculatorAbstract
  def calculate_tax(price)
    price * 1.1  # 10% 消費税
  end
end

class Us < TaxCalculatorAbstract
  def calculate_tax(price)
    price * 1.07 # 7% Sales tax
  end
end

class Eu < TaxCalculatorAbstract
  def calculate_tax(price)
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
  def calculate_tax(price)
    @strategy_type.calculate_tax(price)
  end
end

# ログを追加して処理を実行したい
# Decorationパターン

class DecorationStrategy
  def initialize(decoration_type)
    @decoration_type = decoration_type
  end

  def calculate_tax(price)
    @decoration_type.calculate_tax(price)
  end
end

class DecoratorStrategyAddLog < DecorationStrategy
  def calculate_tax(price)
    puts "Tax log#{price}"
    super
  end
end

# ログを追加して関数を実行、他のstrategyパターンのクラスはよごさない
