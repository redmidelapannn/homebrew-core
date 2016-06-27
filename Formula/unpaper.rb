class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.eu/projects/unpaper"
  revision 2

  stable do
    url "https://www.flameeyes.eu/files/unpaper-6.1.tar.xz"
    sha256 "237c84f5da544b3f7709827f9f12c37c346cdf029b1128fb4633f9bafa5cb930"

    resource "libav" do
      url "https://libav.org/releases/libav-11.7.tar.xz"
      sha256 "8c9a75c89c6df58dd5e3f6f735d1ba5448680e23013fd66a51b50b4f49913c46"
    end
  end

  bottle do
    sha256 "89904b40782a47cacbda1abf8ab7b56ec48f127f17007fed76bbaf76342d4507" => :el_capitan
    sha256 "69584d64f613a06c4c592cf218127d3ef9b51749bba9c9e39f6635d65e5326db" => :yosemite
    sha256 "5d5d824abb5aabdff44a1df6b192954d6478b464a4c897ad9061a0c280b63d9d" => :mavericks
  end

  head do
    url "https://github.com/Flameeyes/unpaper.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build

    resource "libav" do
      url "https://github.com/libav/libav.git"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  def install
    resource("libav").stage do
      system "./configure", "--prefix=#{libexec}", "--enable-shared"
      system "make", "install"
    end

    ENV.append "CFLAGS", "-I#{libexec}/include"
    ENV.append "LDFLAGS", "-L#{libexec}/lib"
    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/lib/pkgconfig"

    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.pbm").write <<-EOS.undent
      P1
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    system bin/"unpaper", testpath/"test.pbm", testpath/"out.pbm"
    File.exist? testpath/"out.pbm"
  end
end
