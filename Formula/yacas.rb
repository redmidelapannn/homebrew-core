class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "http://yacas.sourceforge.net"
  url "https://downloads.sourceforge.net/project/yacas/yacas-source/1.3/yacas-1.3.4.tar.gz"
  sha256 "18482f22d6a8336e9ebfda3bec045da70db2da68ae02f32987928a3c67284233"

  bottle do
    revision 2
    sha256 "d45c9001d827730afb65a55fda860f45c70fe61abbfb843388891340b8674115" => :el_capitan
    sha256 "2b643b01c2c61057e8dfe1e52e7874ad982f337c9bb03da8a006e57a259abc6f" => :yosemite
    sha256 "99bf1442053c6bf1acea386f718322a48b6e755bada30eadc8c77f19335a9667" => :mavericks
  end

  option "with-server", "Build the network server version"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-server" if build.with? "server"

    system "./configure", *args
    system "make", "install"
    system "make", "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yacas -v")
  end
end
