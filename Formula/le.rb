class Le < Formula
  desc "Text editor with block and binary operations"
  homepage "https://github.com/lavv17/le"
  url "https://github.com/lavv17/le/releases/download/v1.16.7/le-1.16.7.tar.gz"
  sha256 "1cbe081eba31e693363c9b8a8464af107e4babfd2354a09a17dc315b3605af41"

  bottle do
    sha256 "6db2ec78a4311d4a9dec8b1e2ea64cbc1013835aaecb1cac1569cc04044cb5b2" => :high_sierra
  end

  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/le --help", 1)
  end
end
