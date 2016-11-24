class Bp4o < Formula
  desc "Better P4 Output"
  homepage "http://zachwhaleys.website/bp4o/"
  head "https://github.com/zachwhaley/bp4o.git"
  url "https://github.com/zachwhaley/bp4o/archive/v0.4.0.tar.gz"
  sha256 "224dc3a95bf966d4a4cd7b9b34c966cfa5347143c50235f4adde2537521eacf3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f23f6f7c1def8fe9da759af5c21bdebca612a57c3eaca3e03d3fff5cf5becbb5" => :sierra
    sha256 "f23f6f7c1def8fe9da759af5c21bdebca612a57c3eaca3e03d3fff5cf5becbb5" => :el_capitan
    sha256 "f23f6f7c1def8fe9da759af5c21bdebca612a57c3eaca3e03d3fff5cf5becbb5" => :yosemite
  end

  def install
    bin.install Dir["bin/*"]
    (prefix+"etc/profile.d").install "bp4o.bash" => "bp4o.sh"
    (share+"zsh/site-functions").install "bp4o.zsh" => "bp4o"
    (share+"fish/vendor_functions.d").install "bp4o.fish" => "p4.fish"
  end

  def caveats
    if File.basename(ENV["SHELL"]) == "zsh"
      init = <<-EOS.undent
        Zsh users, add the following to your ~/.zshrc file:

          autoload -Uz bp4o
          bp4o
      EOS
      init
    end
  end
end
