class GlobusToolkit < Formula
  desc "Toolkit used for building grids"
  homepage "https://www.globus.org/toolkit/"
  # Note: Stable distributions have an even minor version number (e.g. 5.0.3)
  url "https://downloads.globus.org/toolkit/gt6/stable/installers/src/globus_toolkit-6.0.1531931206.tar.gz"
  sha256 "ef7b127174016627e1e161a99a95a4558b1c47fc0d368c4c3e84320924f14081"

  bottle do
    rebuild 1
    sha256 "baa1348ee4ab97800c147e72b6421e7cc88de7ffbe203d36f8132502dbd212b5" => :mojave
    sha256 "85898f0644651dd6d404dcb37723ec429498e71a011fd805ba0cc01d10fe32fe" => :high_sierra
    sha256 "2d3b5706ff4661b1f7f68cf4983a527ad94cd16fdd60ae277f40a24b9b18a0d8" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "openssl"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    man.mkpath
    system "./configure", "--prefix=#{libexec}",
                          "--mandir=#{man}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
    bins = Dir["#{libexec}/bin/*"].select { |f| File.executable? f }
    bin.write_exec_script bins
  end

  test do
    system "#{bin}/globusrun", "-help"
  end
end
