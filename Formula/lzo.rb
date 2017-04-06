class Lzo < Formula
  desc "Real-time data compression library"
  homepage "https://www.oberhumer.com/opensource/lzo/"
  url "https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz"
  sha256 "c0f892943208266f9b6543b3ae308fab6284c5c90e627931446fb49b4221a072"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9f7030a51201e6d36b48238c5d50f6cdc089af10e2aef10de35d27abcb9a3a46" => :sierra
    sha256 "7dac8b6a48c41899fc442d972503062c999ceba3920ddec4d04e51bba32afddd" => :el_capitan
    sha256 "8eb92ab49cdcc32f76197d80e404a6b4aa7b06bd8714519b2568d93a5e84d2f5" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <lzo/lzoconf.h>
      #include <stdio.h>

      int main()
      {
        printf("Testing LZO v%s in Homebrew.\\n",
        LZO_VERSION_STRING);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_match "Testing LZO v#{version} in Homebrew.", shell_output("./test")
  end
end
