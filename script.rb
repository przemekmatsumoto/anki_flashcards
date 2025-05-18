input_file = "input.txt"
output_file = "korean_flashcards/test.csv"

def sanitize(text)
  text.to_s.gsub(/"/, '""').strip
end

skipped_lines = []
line_counter = 0
valid_cards = 0

File.open(output_file, "w:utf-8") do |csv|
  csv.puts '"Front","Back"'
  
  File.foreach(input_file, chomp: true) do |line|
    line_counter += 1
    next if line.empty? || line.strip.empty?
    
    parts = line.split("\t")
    
    if parts.size < 3
      warning = "Linia #{line_counter}: '#{line.strip[0..50]}'..."
      skipped_lines << warning
      puts "UWAGA: Pomijam linię - nieprawidłowy format: #{warning}"
      next
    end
    
    korean = sanitize(parts[0])
    polish = sanitize(parts[1])
    english = sanitize(parts[2])
    
    front = "#{polish} (#{english})"
    back = korean
    
    csv.puts "\"#{front}\",\"#{back}\""
    valid_cards += 1
  end
end

puts "\n--------------------------------------------------"
puts "SUKCES! Wygenerowano plik: #{output_file}"
puts "Liczba poprawnych kart: #{valid_cards}"

if skipped_lines.any?
  puts "\nOSTRZEŻENIA - POMINIĘTE LINIE (#{skipped_lines.size}):"
  skipped_lines.each { |warning| puts " • #{warning}" }
  puts "Upewnij się, że te linie mają format: koreański\tpolski\tangielski"
end

puts "\nINSTRUKCJA IMPORTU DO ANKI:"
puts "1. Otwórz Anki"
puts "2. Wybierz 'Import File' z menu głównego"
puts "3. Znajdź plik '#{output_file}'"
puts "4. Ustaw opcje importu:"
puts "   - Type: 'Basic' (lub wybrany przez Ciebie typ)"
puts "   - Deck: wybierz istniejącą lub utwórz nową talię"
puts "   - Field separator: 'Comma'"
puts "   - Allow HTML: unchecked"
puts "   - Fields enclosed by: '\"'"
puts "5. Upewnij się, że mapowanie pól wygląda tak:"
puts "   - Front → Front"
puts "   - Back → Back"
puts "6. Kliknij 'Import'"
puts "--------------------------------------------------"
