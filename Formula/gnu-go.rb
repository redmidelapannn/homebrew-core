class GnuGo < Formula
  desc "GNU Go"
  homepage "https://www.gnu.org/software/gnugo/gnugo.html"
  # latest release should be v3.9.1 (released on Dec/21/2010)
  # gnu ftp server does not have v3.9.1 though
  url "https://gentoo.c3sl.ufpr.br/distfiles/8c/gnugo-3.9.1.tar.gz"
  sha256 "b80bde5b31bf1e90f78ffc11f49c65ee866bf007ea3f210ce1ce652cd5484794"
  head "https://git.savannah.gnu.org/git/gnugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fed73daa047ff01750c45255035bb63b7790987c4084c8552ed546259e3b88ce" => :catalina
    sha256 "02d91f7a18710455fe65a83fa4a3774491b359c19a64c426bf75d46a4def92c0" => :mojave
    sha256 "a899b21c7fdcf095041025012829f1922629ae9e60abf4ef98fdc34dbb7e1d8f" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline"
    system "make", "install"
  end

  test do
    assert_match /GNU Go #{version}$/, shell_output("#{bin}/gnugo --version")
  end
end
