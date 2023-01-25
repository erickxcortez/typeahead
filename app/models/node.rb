class Node
  attr_reader   :value, :next
  attr_accessor :word, :weight
  def initialize(value)
    @value = value
    @word  = false
    @weight = 0
    @next  = []
  end
end