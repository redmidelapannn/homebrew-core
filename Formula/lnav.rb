class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  # lnav.org has an SSL issue: https://github.com/tstack/lnav/issues/401
  homepage "https://github.com/tstack/lnav"
  url "https://github.com/tstack/lnav/releases/download/v0.8.3/lnav-0.8.3.tar.gz"
  sha256 "33808b07f6dac601b57ad551d234b30c8826c55cb8138bf221af9fedc73a3fb8"

  bottle do
    rebuild 1
    sha256 "86123bdb0d9aaa2ab743b31bfc35bd63d53bb481088d8b3037e5fa652ea2844a" => :high_sierra
    sha256 "c3e0c85c6829e39d2cca31c138c445f0c1f4bcbb4bc3466ffdcf306634e09aa5" => :sierra
    sha256 "457283ab2079939659d39aa541853a03f8ab4f27b9fa9960abe74ed90eb8c3ef" => :el_capitan
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "readline"
  depends_on "pcre"
  depends_on "sqlite" if MacOS.version < :sierra

  def install
    # Fix errors such as "use of undeclared identifier 'sqlite3_value_subtype'"
    ENV.delete("SDKROOT")

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
