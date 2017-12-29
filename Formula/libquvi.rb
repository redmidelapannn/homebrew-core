class Libquvi < Formula
  desc "C library to parse flash media stream properties"
  homepage "https://quvi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quvi/0.9/libquvi/libquvi-0.9.4.tar.xz"
  sha256 "2d3fe28954a68ed97587e7b920ada5095c450105e993ceade85606dadf9a81b2"

  bottle do
    sha256 "d6326d0dc29f604f221b5fc52070b802966330de43699295a2ce36c2ffa1ba5d" => :high_sierra
    sha256 "3d24bb0981cfda56bdb1c97d4e91a120ccb3a30b2a80584eb598578ebfca3a0d" => :sierra
    sha256 "098080208694b41910ec33d29b0c4326aed79fe1205507a6ec176f53b10a90e3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libproxy"
  depends_on "lua@5.1"

  resource "scripts" do
    url "https://downloads.sourceforge.net/project/quvi/0.9/libquvi-scripts/libquvi-scripts-0.9.20131130.tar.xz"
    sha256 "17f21f9fac10cf60af2741f2c86a8ffd8007aa334d1eb78ff6ece130cb3777e3"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua@5.1"].opt_libexec/"lib/pkgconfig"

    scripts = prefix/"libquvi-scripts"
    resource("scripts").stage do
      system "./configure", "--prefix=#{scripts}", "--with-nsfw"
      system "make", "install"
    end
    ENV.append_path "PKG_CONFIG_PATH", "#{scripts}/lib/pkgconfig"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
