class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.6.0.tar.gz"
  sha256 "512e7d2ee69dad0b35ca011076405e56e0f10963a02d4859dbcc4faf53ca68e2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e11949e2f78bab10718ef34f146f2569dedf5be743c4047f0eece622c463eed7" => :sierra
    sha256 "6b8bda62ecc7824c5c9502fc2ebfb28e1f2d41200ddc4cbe9638b3c8b3dbfcf3" => :el_capitan
    sha256 "4bf3897ef9d2abb6d68f81a514231d06453ceda9845c244e231cbe777dc2e3a1" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "libtool" => :build
  depends_on "readline"

  conflicts_with "freeling", :because => "both install 'analyze' binary"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui",
                          "--with-readline"
    system "make"
    system "make", "check"
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
