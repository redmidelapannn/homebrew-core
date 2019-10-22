class Ekg2 < Formula
  desc "Multiplatform, multiprotocol, plugin-based instant messenger"
  homepage "https://github.com/ekg2/ekg2"
  url "https://src.fedoraproject.org/lookaside/extras/ekg2/ekg2-0.3.1.tar.gz/68fc05b432c34622df6561eaabef5a40/ekg2-0.3.1.tar.gz"
  mirror "https://web.archive.org/web/20161227025528/pl.ekg2.org/ekg2-0.3.1.tar.gz"
  sha256 "6ad360f8ca788d4f5baff226200f56922031ceda1ce0814e650fa4d877099c63"
  revision 4

  bottle do
    rebuild 1
    sha256 "46be9b8ed9c938f8ff1f092a41c2294cce59c98c1a5a24a5e112b59bc4b1489c" => :catalina
    sha256 "bfc26f410e2d4ee6e73b2c5e5e07ebfa1c7a3a94c6a20a38de83c944f7b6a013" => :mojave
    sha256 "8ca0df3430434a58fb9496c91e68b7db6eda97496038c18ded8f9dd59915f943" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  # Fix the build on OS X 10.9+
  # bugs.ekg2.org/issues/152 [LOST LINK]
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/ekg2/0.3.1.patch"
    sha256 "6efbb25e57581c56fe52cf7b70dbb9c91c9217525b402f0647db820df9a14daa"
  end

  # Upstream commit, fix build against OpenSSL 1.1
  patch do
    url "https://github.com/ekg2/ekg2/commit/f05815.diff?full_index=1"
    sha256 "5a27388497fd4537833807a0ba064af17fa13d7dd55abec6b185f499d148de1a"
  end

  def install
    readline = Formula["readline"].opt_prefix

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-unicode
      --with-readline=#{readline}
      --without-gtk
      --without-libgadu
      --without-perl
      --without-python
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/ekg2", "--help"
  end
end
