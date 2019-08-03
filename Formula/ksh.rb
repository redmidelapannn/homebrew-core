class Ksh < Formula
  desc "KornShell, ksh93"
  homepage "http://www.kornshell.com"
  url "https://github.com/att/ast/releases/download/2020.0.0-alpha1/ksh-2020.0.0-alpha1.tar.gz"
  version "2020.0.0.1-alpha"
  sha256 "48b150392038b0592bd0b07817ff4838dc038f53bb564d4a73a35357fc88802e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8882183ea6964b3bbbe20dc2b648dafe9188e8c6d7fdc92fd43aa86edec01fc0" => :mojave
    sha256 "cc662f29a239e8282a7c2b2b1152244f424f125e46b5d57cdefd0919f3d98790" => :high_sierra
    sha256 "2f8c5c2d6f02e88e343fcdaaee21daa0ca216deeea2350136cde80800ec4dafb" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "init" do
    url "https://github.com/att/ast/releases/download/2020.0.0-alpha1/ksh-2020.0.0-alpha1.tar.gz"
    sha256 "48b150392038b0592bd0b07817ff4838dc038f53bb564d4a73a35357fc88802e"
  end

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def caveats
    <<~EOS
      We agreed to the Eclipse Public License 1.0 for you.
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/ksh -e 'echo Hello World!'").chomp
  end
end
