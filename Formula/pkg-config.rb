class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://freedesktop.org/wiki/Software/pkg-config/"
  url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.1.tar.gz"
  mirror "https://fossies.org/linux/misc/pkg-config-0.29.1.tar.gz"
  sha256 "beb43c9e064555469bd4390dcfd8030b1536e0aa103f08d7abf7ae8cac0cb001"
  revision 2

  bottle do
    sha256 "215a572573b435e2c74120ff87beee10f1e4a09454a1cd67423fc6727b74029b" => :el_capitan
    sha256 "8e2c73ba5aac54e61343633e961faf4c5e3e4b1c92306f1fcff737e7e581d3cc" => :yosemite
    sha256 "a70f8c930dba36b6a858b3ee2c162b46c0907823b7e3ffb24a962a96122e9334" => :mavericks
  end

  def install
    mkdir_p lib/"pkgconfig"
    cp Dir["#{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}/*"], lib/"pkgconfig"
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
      /usr/local/lib/pkgconfig
      /usr/lib/pkgconfig
      #{lib}/pkgconfig
    ].uniq.join(File::PATH_SEPARATOR)

    ENV.append "LDFLAGS", "-framework Foundation -framework Cocoa"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-host-tool",
                          "--with-internal-glib",
                          "--with-pc-path=#{pc_path}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pkg-config", "--libs", "openssl"
  end
end
