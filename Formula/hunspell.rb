class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.4.2.tar.gz"
  sha256 "b6a0b23d083e0130f8c561cca8c980814ba65740ccfa52f47159f9141089946d"

  bottle do
    sha256 "1750a864f909f5d17c42ebc00fc6986980e792efd14b98e78ebca8a8210e1f8e" => :sierra
    sha256 "3fdc29e380a1f56cffc6b044527db067dbbc683a063ad713bb8d292b232ccbae" => :el_capitan
    sha256 "9139d0a4e71ddf4fe621801ee46868ba1b2990876b50dc904d96fb2fd5b6256e" => :yosemite
  end

  depends_on "readline"

  conflicts_with "freeling", :because => "both install 'analyze' binary"

  # hunspell does not prepend $HOME to all USEROODIRs
  # https://github.com/hunspell/hunspell/issues/32
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/684440d/hunspell/prepend_user_home_to_useroodirs.diff"
    sha256 "456186c9e569c51065e7df2a521e325d536ba4627d000ab824f7e97c1e4bc288"
  end

  def install
    ENV.deparallelize

    # The following line can be removed on release of next stable version
    inreplace "configure", "1.4.0", "1.4.1"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui",
                          "--with-readline"
    system "make"
    system "make", "install"

    pkgshare.install "tests"
  end

  def caveats; <<-EOS.undent
    Dictionary files (*.aff and *.dic) should be placed in
    ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
    provides no dictionaries for Hunspell, but you can download
    compatible dictionaries from other sources, such as
    https://wiki.openoffice.org/wiki/Dictionaries .
    EOS
  end

  test do
    cp_r "#{pkgshare}/tests/.", testpath
    system "./test.sh"
  end
end
