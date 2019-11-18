class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.5.3.tar.gz"
  sha256 "1a85d2a60959122f48ae6a38d8666a3a47f9d14f0bec95f355cd225f5ecaaf50"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d55c685c33132a5afd9e2d60d57880329c66eb777b573dec29c820101ecb3d8b" => :catalina
    sha256 "1f8645d8d55c4a82992a8c7a5c6435c2f0fa8aaf512fde1e1b4116abdb1d409d" => :mojave
    sha256 "421979f7bfb24d03c7db34aeb668aa16e51404c304cc691ceb92799ca535df25" => :high_sierra
  end

  depends_on "ncurses"
  depends_on "readline"
  depends_on "libpq"

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
