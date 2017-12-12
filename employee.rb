class Employee
  attr_accessor :name, :title, :salary, :boss, :bonus

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
    @bonus = 0
  end

  def bonus(multiplier)
    @bonus = @salary * multiplier
  end
end
