class Nudoku < Formula
  desc "ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/1.0.0.tar.gz"
  sha256 "80fb9996c28642920951c20cfd5ca6e370d75240255bc6f11067ae68b6e44eca"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "586d0ba1f241bef372af8949072291853935348961359b8c7d628b984d129b6d" => :mojave
    sha256 "9531c54323ff62c45c5fbd7ae44d158c41140303d5961d911d809569f9f02ce1" => :high_sierra
    sha256 "7b30992f5733e1d757ab920b24a4bc8f1db71cf2b6e170e8730d40de15fefc86" => :sierra
  end

  head do
    url "https://github.com/jubalh/nudoku.git"

    depends_on "gettext" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
