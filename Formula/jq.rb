class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz"
  sha256 "5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72"

  bottle do
    cellar :any
    rebuild 2
    sha256 "98596308bc64e53254bfe0cae52f008df355150fb2c6f9f3be5c22e416603aa1" => :mojave
    sha256 "e520fb88fcde55866747d0701b821eceb23908bb40f2c462426791b088e3389c" => :high_sierra
    sha256 "e887702d9b5c8abe27226b1106fb529bffbe1798618537c1ab50ed1d63d4f5f3" => :sierra
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-maintainer-mode",
                          "--disable-docs",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
