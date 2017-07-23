class Anyenv < Formula
  desc "Simple wrapper for rbenv style environment managers"
  homepage "https://github.com/riywo/anyenv#readme"
  url "https://github.com/riywo/anyenv/archive/master.zip"
  version "3cb8ad1b0dfd89ed5a53fcc9e076b371f6baabfc"
  sha256 "93ba15828fdb2fc88371eb4afa5bbe953e0a172dd8ef280f8c4e7d74e497cfcf"
  head "https://github.com/riywo/anyenv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ca297d528c90fb33bb3f70167a6e1148427aeb8beb03a83ad262daff726573d" => :sierra
    sha256 "c6a9347f3c587a6ab36206dd1c689661a4931789f145b060d5c527973c72f940" => :el_capitan
    sha256 "c6a9347f3c587a6ab36206dd1c689661a4931789f145b060d5c527973c72f940" => :yosemite
  end

  option "without-completions", "Disable bash/fish/zsh completions"

  def install
    inreplace "libexec/anyenv", "ANYENV_ROOT=\"${HOME}/.anyenv\"", "ANYENV_ROOT=\"#{prefix}\""
    prefix.install Dir["*"]

    if build.with? "completions"
      bash_completion.install prefix/"completions/anyenv.bash"
      fish_completion.install prefix/"completions/anyenv.fish"
      zsh_completion.install prefix/"completions/anyenv.zsh" => "_anyenv"
    end
  end

  def caveats; <<-EOS.undent
    Add the following to the ~/.bashrc or ~/.zshrc file:
      echo 'eval "$(anyenv init -)"' >> ~/.your_profile
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/anyanv init -)\" && anyenv versions")
  end
end
