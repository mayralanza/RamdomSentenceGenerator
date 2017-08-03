# ************* GROUP 15 - RSG *****************
# AUTHORS : Mayra Lanza and Giovany Gonzalez

# Extracts just the definitions from the grammar file
# Returns an array of strings where each string is the lines for
# a given definition (without the braces)
def read_grammar_defs(filename)
  filename = 'grammars/' + filename unless filename.start_with? 'grammars/'
  filename += '.g' unless filename.end_with? '.g'
  contents = open(filename, 'r') { |f| f.read }
  contents.scan(/\{(.+?)\}/m).map do |rule_array|
    rule_array[0]
  end
end

# Takes data as returned by read_grammar_defs and reformats it
# in the form of an array with the first element being the
# non-terminal and the other elements being the productions for
# that non-terminal.
# Remember that a production can be empty (see third example)
# Example:
#   split_definition "\n<start>\nYou <adj> <name> . ;\nMay <curse> . ;\n"
#     returns ["<start>", "You <adj> <name> .", "May <curse> ."]
#   split_definition "\n<start>\nYou <adj> <name> . ;\n;\n"
#     returns ["<start>", "You <adj> <name> .", ""]
def split_definition(raw_def)
  arr = raw_def.scan(/(<\S+>)/)
  split_array = arr[0]
  raw_def[split_array[0]] = ""
  raw_def = raw_def.split(/;\n*/)
  for i in 0..(raw_def.size-1)
    split_array << raw_def[i]
  end
  split_array
end

# Takes an array of definitions where the definitions have been
# processed by split_definition and returns a Hash that
# is the grammar where the key values are the non-terminals
# for a rule and the values are arrays of arrays containing
# the productions (each production is a separate sub-array)
# Example:
# to_grammar_hash([["<start>", "The   <object>   <verb>   tonight."], ["<object>", "waves", "big    yellow       flowers", "slugs"], ["<verb>", "sigh <adverb>", "portend like <object>", "die <adverb>"], ["<adverb>", "warily", "grumpily"]])
# returns {"<start>"=>[["The", "<object>", "<verb>", "tonight."]], "<object>"=>[["waves"], ["big", "yellow", "flowers"], ["slugs"]], "<verb>"=>[["sigh", "<adverb>"], ["portend", "like", "<object>"], ["die", "<adverb>"]], "<adverb>"=>[["warily"], ["grumpily"]]}
def to_grammar_hash(split_def_array)
  grammar_hash = Hash.new
  for i in 0..(split_def_array.size-1)
    arr = split_def_array[i]
    key = arr[0]
    value = arr.drop(1).map{|x| x.split(" ")}
    grammar_hash[key] = value
  end
  grammar_hash
end

# Returns true iff s is a non-terminal
# a.k.a. a string where the first character is <
#        and the last character is >
def is_non_terminal?(s)
  if s[0] == "<" && s[-1] == ">"
    true
  end
end

# Given a grammar hash (as returned by to_grammar_hash)
# returns a string that is a randomly generated sentence from
# that grammar
#
# Once the grammar is loaded up, begin with the <start> production and expand it to generate a
# random sentence.
# Note that the algorithm to traverse the data structure and
# return the terminals is extremely recursive.
#
# The grammar will always contain a <start> non-terminal to begin the
# expansion. It will not necessarily be the first definition in the file,
# but it will always be defined eventually. Your code can
# assume that the grammar files are syntactically correct
# (i.e. have a start definition, have the correct  punctuation and format
# as described above, don't have some sort of endless recursive cycle in the
# expansion, etc.). The names of non-terminals should be considered
# case-insensitively, <NOUN> matches <Noun> and <noun>, for example.
def expand(grammar, non_term="<START>")
  grammar.each do |key, value|
    if key.casecmp(non_term) == 0
      non_term = key
    end
  end
  arr_sentence = grammar[non_term].sample
  random_sentence = ""
  for i in 0..(arr_sentence.size - 1)
    if is_non_terminal?(arr_sentence[i])
      random_sentence << expand(grammar, arr_sentence[i])
    else
      if arr_sentence[i][-1] == "."
        random_sentence << arr_sentence[i] << "\n"
      elsif arr_sentence[i][-1] == ":"
        random_sentence << arr_sentence[i] << "\n"
      else
        random_sentence << arr_sentence[i] << " "
      end
    end
  end
  random_sentence
end

# Given the name of a grammar file,
# read the grammar file and print a
# random expansion of the grammar
def rsg(filename)
  grammar = read_grammar_defs(filename)
  split_grammar = Array.new
  for i in 0..(grammar.size - 1)
    split_grammar << split_definition(grammar[i])
  end
  hash_grammar = to_grammar_hash(split_grammar)
  random_sentence = expand(hash_grammar)
  random_sentence
end

if __FILE__ == $0
  # TODO: your implementation of the following
  # prompt the user for the name of a grammar file
  # rsg that file
  puts "******************** RANDOM SENTENCE GENERATOR  ********************\n"
  print "Please enter filename >> "
  filename = gets.chomp
  puts "\nRandom sentence from #{filename}.g :\n\n"
  puts rsg(filename)
  puts "\n********************************************************************"
end
