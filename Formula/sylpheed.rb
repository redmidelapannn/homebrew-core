class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.5/sylpheed-3.5.1.tar.bz2"
  sha256 "3a5a04a13a0e2f32cdbc6e09d92b5143ca96df5fef23425cd81d96b8bd5b1087"

  bottle do
    rebuild 1
    sha256 "21036b5bf569cb83df00f33d42a89ad214131fcf74160ea4ff0f4ff6c72ac035" => :sierra
    sha256 "36c7097fff74c527b082a412810367fefc95e0529b2e01e4136cc2a0e2c1a26e" => :el_capitan
    sha256 "7eff6ef48d27783046d173656d35c814205210776966bcd77a6a3a060e57456a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-updatecheck"
    system "make", "install"
  end

  test do
    system "#{bin}/sylpheed", "--version"
  end
end
