require_relative 'employee.rb'

class Manager < Employee
  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees
  end

  def bonus(multiplier)
    employee_salaries = @employees.reduce(0) do |acc, employee|
      acc + employee.salary
    end
    @bonus = employee_salaries * multiplier
  end
end
