class Defusal
  def initialize
    @running = true
  end

  def run
    puts '                   - Desarmar a bomba 💣 -                      '
    puts "\n"
    puts "\n"

    while @running
      display_instructions
      defusal_sequence = gets.chomp
      print `clear`
      parsed_sequence = sequence_parser(defusal_sequence)
      action(parsed_sequence)
    end
  end

  private

  def action(parsed_sequence)
    # stop app
    return stop if parsed_sequence.one? && parsed_sequence[0] == 'sair'

    available_colors = %w[branco vermelho preto laranja verde roxo]

    # check errors in unput sequence
    parsed_sequence.each do |color|
      next if available_colors.include? color

      return puts "#{color} não é uma cor válida. \n \n"
    end

    defusal(parsed_sequence)
  end

  def defusal(sequence)
    return puts 'Bomba desarmada' if sequence.one?

    # check if next wire meets conditions
    case sequence[0]
    when 'branco'
      %w[preto branco].include? sequence[1] ? failure : next_wire(sequence)
    when 'vermelho'
      sequence[1] == 'verde' ? next_wire(sequence) : failure
    when 'preto'
      %w[branco verde laranja].include? sequence[1] ? failure : next_wire(sequence)
    when 'laranja'
      %w[vermelho preto].include? sequence[1] ? next_wire(sequence) : failure
    when 'verde'
      %w[branco laranja].include? sequence[1] ? next_wire(sequence) : failure
    when 'roxo'
      %w[vermelho preto].include? sequence[1] ? next_wire(sequence) : failure
    end
  end

  def next_wire(sequence)
    # move to the next wire
    remaining_wires = sequence.drop(1)
    defusal(remaining_wires)
  end

  def failure
    puts "\n"
    puts 'Bomba explodiu'
    puts "\n"
  end

  def sucess
    puts "\n"
    puts 'Bomba desarmada'
    puts "\n"
    puts '---------------'
  end

  def sequence_parser(defusal_sequence)
    # split the string, remove whitespace and downcase
    defusal_sequence.split(',').map { |sequence| sequence.gsub(/\s+/, '').downcase }
  end

  def stop
    @running = false
  end

  def display_instructions
    puts 'Introduza a sequência de cores dos fios, separadas por virgula e'
    puts 'com o seguinte formato: "cor, cor, cor"'
    puts 'cores disponíveis:'
    puts '          branco, preto, vermelho, laranja, verde, roxo          '
    puts '                                                                 '
    puts 'Para terminar a aplicação digite "sair"'
    puts "\n"
  end
end
