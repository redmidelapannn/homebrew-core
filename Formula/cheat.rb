class Cheat < Formula
  include Language::Python::Virtualenv

  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.2.3.tar.gz"
  sha256 "adedab2d8047b129e07d67205f5470c120dbf05785f2786520226c412508d9ee"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "622a940fb40b7db321cef79aec2ded2f0345a6d6b25699e0c06c524db214e47b" => :high_sierra
    sha256 "d0e5467b7bf296d665a8fa51962dfcf85bcfeaf60122ee627a933612eecdb127" => :sierra
    sha256 "16c5ce916b640515530160b38c46e440104ac45d7436fc324876b262a0a0768f" => :el_capitan
  end

  depends_on "python@2"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "cheat/autocompletion/cheat.bash"
    zsh_completion.install "cheat/autocompletion/cheat.zsh" => "_cheat"
  end

  test do
    system bin/"cheat", "tar"
  end
end
