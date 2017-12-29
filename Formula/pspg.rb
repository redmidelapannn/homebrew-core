class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/0.9.0.tar.gz"
  sha256 "e5997294e7295cf829eeb6e8e8d890c7c49fb7491079977384af8a395f60155d"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "1ff87bdf2d5c5f6c89cbc7936e195d16fd4b01394b638025f9dbd604cf2ba4c9" => :high_sierra
    sha256 "e36e8f982433beb26d8f5b30c6248abbafac50d812e370b07822f3cd1a43acf3" => :sierra
    sha256 "5026f19ada32a6e517f3bf30cab6a8c360e112cf5b1f1214bdd066d39bef2777" => :el_capitan
  end

  depends_on "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following line to your psql profile (e.g. ~/.psqlrc)
      \\setenv PAGER pspg
      \\pset border 2
      \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version")
  end
end
