class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.4.1.tar.gz"
  sha256 "0346a0e0df1091e16e6504154e7da15a98fa3fb9e76df6497c37ac76acf19924"

  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "41e0ec94cc348ee3078a0b29f8e328d05866a74c69261ea8b10c559f2e0fe6d9" => :el_capitan
    sha256 "7c15188176d4d4389d7775da621ec13fc6a38860bc15352fe749ba0a09927b5b" => :yosemite
    sha256 "a9b5d12e214b6c39bc1872b7a6826a575e49824840c6d65b47383b446f26f453" => :mavericks
  end

  depends_on :python3

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match /Homebrew/, shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
