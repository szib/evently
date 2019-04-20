class Terminal
  def self.clear_terminal
    if Gem.win_platform?
      system('cls')
    else
      system('clear')
    end
  end

  def self.display_logo(text)
    clear_terminal
    font = TTY::Font.new('doom')
    title = font.write(text)
    puts Pastel.new.yellow(title)
  end

  def self.welcome(guest_name)
    message "Welcome, #{guest_name}!"
  end

  def self.bye
    font = TTY::Font.new('doom')
    title = font.write('Bye')
    puts Pastel.new.yellow(title)
  end

  def self.message(msg)
    puts Pastel.new.bright_cyan("\n==> #{msg}\n")
  end

  def self.show_in_box(content)
    box = TTY::Box.frame(
      width: 80,
      height: 15,
      align: :left,
      padding: [1, 3, 1, 3],
      border: :thick,
      style: {
        fg: :bright_cyan,
        bg: :black,
        border: {
          fg: :bright_cyan,
          bg: :black
        }
      }
    ) do
      content
    end
    puts box
  end
end
