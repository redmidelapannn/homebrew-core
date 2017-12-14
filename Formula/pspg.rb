class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/0.7.5.tar.gz"
  sha256 "1c33f41e5a023fe4b9b9be1039cf6b10e33de1d1958da7108a29068eed0db7a8"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "7d70e08663ef5e3da36ee6caceb6ae091c17246e9f4d9659b70eb18be448399e" => :high_sierra
    sha256 "62d34f9a3ae6208782375f4a0b2f5fd53663e03fe8254984323178b970c6a5d3" => :sierra
    sha256 "0ecc6658dc070da8f6404941720041feee8bb80f322861187f2b0a2c0e56d45e" => :el_capitan
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
    assert_match("pspg-#{version}", shell_output("#{bin}/pspg --version").chomp)
  end
end
