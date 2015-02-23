class Installer
  def self.full_install
    ruby_bot = Installer.new
    ['git', 'npm', 'bower'].each do |program|
      ruby_bot.install_program(program)
    end
  end

  def install_program(program, noisy=true)
    if program_exists?(program)
      puts "#{program} is already installed" if noisy
      # TODO version check
    else
      puts "Installing #{program}" if noisy
      check_prerequisites(program, noisy)
      run_install_script(program, noisy)
    end
  end

  protected

  def program_exists?(program)
    system("which #{ program} > /dev/null 2>&1")
  end

  def check_prerequisites(program, noisy=true)
    prerequisites = find_prerequisites(program)
    prerequisites.each do |program|
      install_program(program, false)
    end
  end

  def run_install_script(program, noisy=true)
    case program
    when 'git'
      system('brew update') # TODO Move this check
      system('brew install git')
    when 'brew'
      system('ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
    when 'bower'
      system('npm install -g bower')
    when 'npm'
      system('brew update') # TODO Move this check
      system('brew install node')
    else
      # TODO?
    end
  end

  def find_prerequisites(program)
    case program
    when 'git'
      ['brew']
    when 'bower'
      ['npm']
    when 'npm'
      ['brew']
    else
      []
    end
  end
end

Installer.full_install