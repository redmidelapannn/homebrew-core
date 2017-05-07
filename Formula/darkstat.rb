class Darkstat < Formula
  desc "Network traffic analyzer"
  homepage "https://unix4lyfe.org/darkstat/"
  url "https://unix4lyfe.org/darkstat/darkstat-3.0.719.tar.bz2"
  sha256 "aeaf909585f7f43dc032a75328fdb62114e58405b06a92a13c0d3653236dedd7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2e5c5dc0412b544835c8e84bccc8bce9b07b40267da255dff0ec9aeeaba57131" => :sierra
    sha256 "39bd8a48b448cdfb0998bc222ab40e91afdeea0da5097cb6d02ece2d67aedf57" => :el_capitan
    sha256 "9b1cd336bed92c630aa1f3fdb6ebff617b8e0293b3dfba8064b65d2ba2073cfa" => :yosemite
  end

  head do
    url "https://www.unix4lyfe.org/git/darkstat", :using => :git
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    # Fix clockid_t redefinition on Sierra and later
    if MacOS.version >= :el_capitan
      inreplace "now.c", "__MACH__", "__TOTO__"
    end

    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"darkstat", "--verbose", "-r", test_fixtures("test.pcap")
  end
end
