class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.4.tar.gz"
  sha256 "bfc04124d2fde7924e6b5c3a11fdce7fbd2fdb1819c0b78c3fd0a7d36e330164"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6428018075997c8c2afc0fb23b38e3fb338f507e7008b6557f87b994a2111acf" => :sierra
    sha256 "6428018075997c8c2afc0fb23b38e3fb338f507e7008b6557f87b994a2111acf" => :el_capitan
    sha256 "6428018075997c8c2afc0fb23b38e3fb338f507e7008b6557f87b994a2111acf" => :yosemite
  end

  depends_on "fribidi"
  depends_on "gawk"
  depends_on "rlwrap"

  def install
    system "make"
    bin.install "build/trans"
    man1.install "man/trans.1"
  end

  def caveats; <<-EOS.undent
    By default, text-to-speech functionality is provided by macOS's builtin
    `say' command. This functionality may be improved in certain cases by
    installing one of mplayer, mpv, or mpg123, all of which are available
    through `brew install'.
    EOS
  end

  test do
    assert_equal "hello\n",
      shell_output("#{bin}/trans -no-init -b -s fr -t en bonjour").downcase
  end
end
