class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftpmirror.gnu.org/libidn/libidn-1.32.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn-1.32.tar.gz"
  sha256 "ba5d5afee2beff703a34ee094668da5c6ea5afa38784cebba8924105e185c4f5"

  bottle do
    cellar :any
    revision 1
    sha256 "3bb629d6163b4101c76dbacdf1add4699864cada0ba645bcf0e744a2ffabfab3" => :el_capitan
    sha256 "30cbfae95d470fd7f1aeae15fc889a85f4e8f82da327b1b1aa0f7d56000d606a" => :yosemite
    sha256 "ae1c3130f67a0a5e7ed8f815a78405948ff93451e508457cfcb8272247c5a84c" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{share}/emacs/site-lisp/#{name}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system "#{bin}/idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
