class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.4.1.tar.gz"
  sha256 "c4476aff0ced52eec334eae1e8d3fdaaebdd90f5ecd0b57cf2a92a6fd220d1bb"
  revision 1

  bottle do
    rebuild 1
    sha256 "a569e89004dbeaed39546c3fc3b67bd99f6f3ca05e023aa6cea0f968bbb554fb" => :sierra
    sha256 "4c8f9585f87507e0be9c76b7fe058f55ebd7f9775b761ec50ce5b6dc76492e54" => :el_capitan
    sha256 "cc36234c265a75dd685d6901caa545a5707176993b9c73e9e9c948d37abef1b5" => :yosemite
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
