input_file = "input.txt"
output_file = "korean_flashcards/pronouns_particles_and_practice_uestions.csv"

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
      warning = "Line #{line_counter}: '#{line.strip[0..50]}'..."
      skipped_lines << warning
      puts "WARNING: Skipping line - invalid format: #{warning}"
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
puts "SUCCESS! Generated file: #{output_file}"
puts "Number of valid cards: #{valid_cards}"

if skipped_lines.any?
  puts "\nWARNINGS - SKIPPED LINES (#{skipped_lines.size}):"
  skipped_lines.each { |warning| puts " • #{warning}" }
  puts "Make sure these lines follow the format: korean\tpolish\tenglish"
end

puts "\nANKI IMPORT INSTRUCTIONS:"
puts "1. Open Anki"
puts "2. Select 'Import File' from the main menu"
puts "3. Locate the file '#{output_file}'"
puts "4. Set import options:"
puts "   - Type: 'Basic' (or your preferred type)"
puts "   - Deck: select existing or create new deck"
puts "   - Field separator: 'Comma'"
puts "   - Allow HTML: unchecked"
puts "   - Fields enclosed by: '\"'"
puts "5. Ensure field mapping is:"
puts "   - Front → Front"
puts "   - Back → Back"
puts "6. Click 'Import'"
puts "--------------------------------------------------"