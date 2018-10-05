class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.7.tar.gz"
  sha256 "8210dfcadc6d63f8415f25ff266e4fd437f448c7ce3179a5ec2769195c207bf5"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4825fcfe0c8e5073f34e758c53d3c654e3f1670217acc282536f89ae845a1dc1" => :mojave
    sha256 "fed450ae4bf96923a8e346cf1a46bbdc5aa23b0e00af05c6fc9d65c0361d9b1b" => :high_sierra
    sha256 "fed450ae4bf96923a8e346cf1a46bbdc5aa23b0e00af05c6fc9d65c0361d9b1b" => :sierra
  end

  depends_on "python"

  def install
    system "make", "disable-self-upgrade"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
