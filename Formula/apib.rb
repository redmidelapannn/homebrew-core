class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/APIB_1_0.tar.gz"
  sha256 "1592e55c01f2f9bc8085b39f09c49cd7b786b6fb6d02441ca665eef262e7b87e"
  revision 1

  head "https://github.com/apigee/apib.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "57d7ecc050cd74b71a17ac315de98b5115979040b48d3b1717a8dbeeff96c251" => :sierra
    sha256 "350492a866d40fb1666dddd49dd375e9a690de425205594b16830ecbdf86ca7b" => :el_capitan
    sha256 "b85df14195832a3ae6f928c11f3002c959fd292018a5520e79b8c38a000d248a" => :yosemite
  end

  depends_on "apr"
  depends_on "openssl"

  def install
    # Upstream hardcodes finding apr in /usr/include. When CLT is not present
    # we need to fix this so our apr requirement works.
    # https://github.com/apigee/apib/issues/11
    unless MacOS::CLT.installed?
      inreplace "configure" do |s|
        s.gsub! "/usr/include/apr-1.0", "#{Formula["apr"].opt_libexec}/include/apr-1"
        s.gsub! "/usr/include/apr-1", "#{Formula["apr"].opt_libexec}/include/apr-1"
      end
      ENV.append "LDFLAGS", "-L#{Formula["apr-util"].opt_libexec}/lib"
      ENV.append "LDFLAGS", "-L#{Formula["apr"].opt_libexec}/lib"
      ENV.append "CFLAGS", "-I#{Formula["apr"].opt_libexec}/include/apr-1"
      ENV.append "CFLAGS", "-I#{Formula["apr-util"].opt_libexec}/include/apr-1"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "apib", "apibmon"
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "https://www.google.com"
  end
end
