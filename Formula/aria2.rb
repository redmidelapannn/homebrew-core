class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/tatsuhiro-t/aria2/releases/download/release-1.21.0/aria2-1.21.0.tar.xz"
  sha256 "225c5f2c8acc899e0a802cdf198f82bd0d3282218e80cdce251b1f9ffacf6580"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "1a1d69c40d9162b71175376a3cd2edc5b795de575750b185fbee4b0803d5c687" => :el_capitan
    sha256 "090ba94534a4d416e662b0e2308519d558581c74e33d0f28cb8749ba561da973" => :yosemite
    sha256 "c9fb8cf69e28e68abb89001483456bcb823f82f09cf80ad174be6ecbde3e9da8" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2" => :optional

  needs :cxx11

  def install

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-appletls
      --without-openssl
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]

    args << "--with-libssh2" if build.with? "libssh2"

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "http://brew.sh"
    assert File.exist? "index.html"
  end
end
