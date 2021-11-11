require "./policy"

class PolicyEvaluator
  getter policy : Policy
  getter password : String

  def initialize(@policy, @password)
  end

  def valid?
    policy.evaluate(password)
  end
end
