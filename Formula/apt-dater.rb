class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v1.0.4.tar.gz"
  sha256 "a4bd5f70a199b844a34a3b4c4677ea56780c055db7c557ff5bd8f2772378a4d6"
  revision 1
  version_scheme 1

  bottle do
    rebuild 1
    sha256 "e67985af4bc9dfb5a5aa2b70b921664d981964a64af5b0f13e38202885aed3f3" => :mojave
    sha256 "2dfc2146cc3913ab8204b26d5a68b5e16011b6521dde908afd58ab200e0d7811" => :high_sierra
    sha256 "5605da018bd0ac2dfb7c69055dbe1fded1ed4dca47ad80344f5676dea7a49bcf" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"
  uses_from_macos "libxml2"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    # Global config overrides local config, so delete global config to prioritize the
    # config in $HOME/.config/apt-dater
    (prefix/"etc").rmtree
  end

  test do
    system "#{bin}/apt-dater", "-v"
  end
end
