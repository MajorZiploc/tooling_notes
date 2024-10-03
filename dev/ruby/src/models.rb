module Models
  class Customer
    @@no_of_customers = 0
    attr_reader :name, :age
    def initialize(name, age)
      @no = @@no_of_customers + 1
      @name = name
      @age = age
      @@no_of_customers += 1
    end

    def say
      "Hello, my name is #{@name} and I am #{@age} years old\nI am #{@no} of #{@@no_of_customers}"
    end
end

end
