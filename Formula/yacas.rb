class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "http://yacas.sourceforge.net"
  url "https://downloads.sourceforge.net/project/yacas/yacas-source/1.3/yacas-1.3.4.tar.gz"
  sha256 "18482f22d6a8336e9ebfda3bec045da70db2da68ae02f32987928a3c67284233"

  bottle do
    revision 2
    sha256 "9a4b0d6646b0d0c75a88db1c6e531b178a570206eb264b32d12cd54092059111" => :el_capitan
    sha256 "d98524a67a73624072aabad8e9b0edda608f5d40f6e99f1522e9ba36f3ec9188" => :yosemite
    sha256 "0da1d2ceac1ddc2ad29dc3be3a1a746e950b59410c0475d61f74e756088dbdcf" => :mavericks
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
    system "#{bin}/yacas", "--version"
  end
end
