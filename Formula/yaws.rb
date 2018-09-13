class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "http://yaws.hyber.org/download/yaws-2.0.6.tar.gz"
  sha256 "69f96f8b9bb574b129b0f258fb8437fdfd8369d55aabc2b5a94f577dde49d00e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4a40dcf999949038dabef0322eeba48e823d39efe94ea0192d379510eb2da961" => :mojave
    sha256 "dd50200019ec346c98253aad839aa0427d709f2bb83784b337175d438c3d89e9" => :high_sierra
    sha256 "7e12f90e23b43910fc79749e991165d10ff95e37ff616845b2d2f09b3f145c56" => :sierra
    sha256 "5becd1fa42c0494e9efd52924cb90764dbbcf5866b32b451d9202c822dd022e0" => :el_capitan
  end

  head do
    url "https://github.com/klacke/yaws.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "erlang@20"

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          # Ensure pam headers are found on Xcode-only installs
                          "--with-extrainclude=#{MacOS.sdk_path}/usr/include/security"
    system "make", "install"

    cd "applications/yapp" do
      system "make"
      system "make", "install"
    end

    # the default config expects these folders to exist
    (lib/"yaws/examples/ebin").mkpath
    (lib/"yaws/examples/include").mkpath
  end

  def post_install
    (var/"log/yaws").mkpath
    (var/"yaws/www").mkpath
  end

  test do
    system bin/"yaws", "--version"
  end
end
