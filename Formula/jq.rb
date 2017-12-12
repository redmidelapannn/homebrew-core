class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
  sha256 "c4d2bfec6436341113419debf479d833692cc5cdab7eb0326b5a4d4fbe9f493c"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "0c3fd998fd8bedf9048bf0e66406ef919406f2fbbd1bb0c0f28464d70efc3efc" => :high_sierra
    sha256 "3c5f80a6580b77696bfb4e61825d87b84aa315392dd1a1f4faa50fbe8b3a365e" => :sierra
    sha256 "f28deda5e8f05ff24364d2285dec5d5899c9a9c7f36637a5a101621b70c37413" => :el_capitan
  end

  devel do
    url "https://github.com/stedolan/jq.git", :tag => "jq-1.6rc1"
    version "1.6rc1"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma" # jq depends > 1.5

  def install
    system "autoreconf", "-iv" unless build.stable?
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
