class Trie
  def initialize
    @root = Node.new("*")
  end

  def add_word(word, weight)
    base = @root
    word.chars.each do |letter|
      base = add_or_find_node(letter, base.next)
    end
    base.word = true
    base.weight = weight
  end

  def find_word(word)
    base = @root
    found = word.chars.all? do |letter|
      base = find_node(letter, base.next)
    end
    yield found, base if block_given?
    base
  end

  def add_or_find_node(character, nodes)
    nodes.find { |node| node.value == character } || add_node(character, nodes)
  end

  def find_node(character, nodes)
    nodes.find { |node| node.value.downcase == character.downcase }
  end

  def add_node(character, nodes)
    Node.new(character).tap { |new_node| nodes << new_node }
  end

  def include?(word)
    find_word(word) { |found, base| return found && base.word }
  end

  def find_words_starting_with(prefix, limit, update_weight = false)
    stack = [find_word(prefix)]
    prefix_stack = []
    if prefix.empty?
      stack = [@root]
    else
      prefix_stack << prefix.chars.take(prefix.size - 1)
    end
    return [] unless stack.first
  
    words = []
    until stack.empty?
      node = stack.pop
      prefix_stack.pop and next if node == :guard_node
      prefix_stack << node.value
      stack << :guard_node
      if node.word
        node.weight += 1 if prefix_stack.join == prefix && update_weight == true
        words << { 
            name: clean_word( prefix_stack.join ), 
            times: node.weight 
        }
      end
      node.next.sort_by! { |n| -n.weight }.each { |n| stack << n }
    end
  
    words.sort do |a, b|
      if a[:name] == prefix
        -1
      elsif b[:name] == prefix
        1
      elsif a[:times] == b[:times]
        a[:name] <=> b[:name]
      else
        b[:times] <=> a[:times]
      end
    end.take(limit)
  end

  def clean_word(word)
    word = word[1..-1] if word.first == "*"
    if word.include?("-") 
      words = word.split("-")
      word = words[0].first.upcase + words[0][1..-1] +"-"+  words[1].first.upcase + words[1][1..-1]
    end
    if word.include?(" ") 
      words = word.split(" ")
      word = words[0].first.upcase + words[0][1..-1] +" "+ words[1].first.upcase + words[1][1..-1]
    end
    word =  word = word.first.upcase + word[1..-1]
  end
  
end
