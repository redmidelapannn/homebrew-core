class Tcc < Formula
  desc "Tiny C compiler"
  homepage "https://bellard.org/tcc/"
  url "https://download.savannah.gnu.org/releases/tinycc/tcc-0.9.26.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/tcc-0.9.26.tar.bz2"
  sha256 "521e701ae436c302545c3f973a9c9b7e2694769c71d9be10f70a2460705b6d71"

  bottle do
    rebuild 1
    sha256 "b0db8138c9b776af33d962a84d6655de787dbd8ba1214a15aaf528e432f7556c" => :sierra
    sha256 "88fa5a0c11ec2c1c1450c16d42d9a641d25b8796c8dd4bbdb35455d41a375e12" => :el_capitan
    sha256 "fe0baf5fe054745102bc2d13176a4bb8000d3f9e246ae34ad4a2b42df0bb0a54" => :yosemite
  end

  option "with-cross", "Build all cross compilers"

  def install
    args = %W[
      --prefix=#{prefix}
      --source-path=#{buildpath}
      --sysincludepaths=/usr/local/include:#{MacOS.sdk_path}/usr/include:{B}/include
    ]

    args << "--enable-cross" if build.with? "cross"

    ENV.deparallelize
    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "test"
  end

  test do
    (testpath/"hello-c.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/tcc -run hello-c.c")
  end
end
