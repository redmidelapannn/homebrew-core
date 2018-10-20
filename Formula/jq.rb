class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
  sha256 "c4d2bfec6436341113419debf479d833692cc5cdab7eb0326b5a4d4fbe9f493c"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "9f8b4af5b218e448e44684258590383c11a83faaa948ab45c49db8a1b269afaf" => :mojave
    sha256 "09785166767057c884646b1b05a16c473ef74ede317a0f40443fe0dcf8486fc2" => :high_sierra
    sha256 "f45766caf3f217de977090c0e5ac764cc86b87419005a366aba48cb440f0f8a3" => :sierra
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma" # jq depends > 1.5

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-maintainer-mode",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
