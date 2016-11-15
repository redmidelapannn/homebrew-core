class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.20.1/libslax-0.20.1.tar.gz"
  sha256 "59f8aace21fb7e02091da3b84de7e231d5d02af26401985b109d2b328ab3f09d"

  bottle do
    rebuild 1
    sha256 "a514ef983b86b9f8b6e7eb0f180f8de6c948819a94d85184a8dff808bc9832ec" => :sierra
    sha256 "e5a4045695e68191fd95f556b32dee560f68d831acb726a4602fc89d90c7b91e" => :el_capitan
    sha256 "84353720ef5c6c61007b8b3a257302224f7cb562282d7679c26c25fadead8763" => :yosemite
  end

  head do
    url "https://github.com/Juniper/libslax.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  if MacOS.version <= :mountain_lion
    depends_on "libxml2"
    depends_on "libxslt"
    depends_on "sqlite" # Needs 3.7.13, which shipped on 10.9.
  end

  depends_on "libtool" => :build
  depends_on "curl" if MacOS.version <= :lion
  depends_on "openssl"

  def install
    # configure remembers "-lcrypto" but not the link path.
    ENV.append "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"

    system "sh", "./bin/setup.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make", "install"
  end

  test do
    (testpath/"hello.slax").write <<-EOS.undent
      version 1.0;

      match / {
          expr "Hello World!";
      }
    EOS
    system "#{bin}/slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert File.exist?("hello.xslt")
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end
