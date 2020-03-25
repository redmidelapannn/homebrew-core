class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.02/tintin-2.02.02.tar.gz"
  sha256 "c5d8b6c930ec0beb9f45de434e079dddb17b48f8a3acff08acbc9d1bd15dd487"

  bottle do
    cellar :any
    sha256 "12a80e4d68e43205bd36691dd494cf9f4204520276370a1d795a979a700ccec1" => :catalina
    sha256 "3b0a45d32b3c221b35927fae39afe22549b320f24bc337e00f87cd217dd42fa8" => :mojave
    sha256 "7449d8d9ab2d55d731013567cdcf2a83b7f04bdc8f3fcd63040571e8364e4805" => :high_sierra
  end

  depends_on "gnutls"
  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    shell_output("#{bin}/tt++ -e \"#nop; #info system; #end;\"")
  end
end
