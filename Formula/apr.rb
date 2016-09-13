class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-1.5.2.tar.bz2"
  sha256 "7d03ed29c22a7152be45b8e50431063736df9e1daa1ddf93f6a547ba7a28f67a"
  revision 3

  bottle do
    cellar :any
    sha256 "7e354b3fe4a8bd6f60260a0d33182809772da33bf91e92f796328e974b924e6d" => :el_capitan
    sha256 "287f2571faf54d7be3730df97806c744e6713dc2a47e9549ea3bd60955678110" => :yosemite
    sha256 "6f205860a3b32236d92e3e14decdd45280abb3d62bd9eada66ae363b1dc57d01" => :mavericks
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr."

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apr-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apr-1-config --prefix")
  end
end
