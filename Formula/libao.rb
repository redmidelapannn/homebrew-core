class Libao < Formula
  desc "Cross-platform Audio Library"
  homepage "https://www.xiph.org/ao/"
  url "http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz"
  sha256 "03ad231ad1f9d64b52474392d63c31197b0bc7bd416e58b1c10a329a5ed89caf"

  bottle do
    revision 2
    sha256 "479ea56df4b49cf911dc7cb47b519720130d2f24956384e9958afb0852a119da" => :el_capitan
    sha256 "7d42e638b642282e42c6989ceb3d9e719ee71de0282409ecd10abbb7fe25c6f2" => :yosemite
    sha256 "b24042987ae45719e4df7ac18753c13d9a9fe17139735edd63c9203586d9c11c" => :mavericks
  end

  head do
    url "https://git.xiph.org/libao.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    if build.head?
      ENV["AUTOMAKE_FLAGS"] = "--include-deps"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ao/ao.h>
      int main() {
        ao_initialize();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lao", "-o", "test"
    system "./test"
  end
end
