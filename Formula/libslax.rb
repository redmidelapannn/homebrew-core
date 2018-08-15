class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.22.0/libslax-0.22.0.tar.gz"
  sha256 "a32fb437a160666d88d9a9ae04ee6a880ea75f1f0e1e9a5a01ce1c8fbded6dfe"

  bottle do
    rebuild 1
    sha256 "061a1d07703cd346e780e5142a95c4f44f6cd462d5af100b852765a09ff878b1" => :high_sierra
    sha256 "c6dbcecf6cdfebcacd32dea3d3f034499b252d27346d117ae8a05a19140ce1e9" => :sierra
    sha256 "72f5d47dc59c8c3b23b97ce5b8f1f1517fd54cdf344cb050b89ad084d436b54f" => :el_capitan
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

  conflicts_with "genometools", :because => "both install `bin/gt`"

  def install
    # configure remembers "-lcrypto" but not the link path.
    ENV.append "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"

    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    system "sh", "./bin/setup.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make", "install"
  end

  test do
    (testpath/"hello.slax").write <<~EOS
      version 1.0;

      match / {
          expr "Hello World!";
      }
    EOS
    system "#{bin}/slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert_predicate testpath/"hello.xslt", :exist?
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end
