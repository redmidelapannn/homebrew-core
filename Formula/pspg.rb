class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.7.2.tar.gz"
  sha256 "d657c53d9571ce97553295f407ae6c041705663c6b0e78bc01ac37d2868b513e"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "5999baa95e558d01847288277d0619c28cd8bf816916515fadad8a22502caa22" => :catalina
    sha256 "dea6e4114c2671797725de8415dcd97f5e2dd604ed8c65597a18ee33a96c9075" => :mojave
    sha256 "916b644ad413a1f68b47b6fe869b816f809967516744255840bdd84da079bc95" => :high_sierra
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
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
