class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.31.0/aria2-1.31.0.tar.xz"
  sha256 "7b85619048b23406f241e38a5b1b8b0bc2cae9e80fd117810c2a71ecca813f8c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ee143a5b63997b6a7c89ad78c89b587e087ff53c9318faec7f16f6f0020966b6" => :sierra
    sha256 "dcfa629d511fc7932c45c971a2166c3d4f765b97a53835aa8d061370df60a3e7" => :el_capitan
    sha256 "ffea8625990d567d4f8a10cf58011fe5fc41b5d7d6966684367f3ec67335597f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2" => :optional

  needs :cxx11

  def install
    ENV.cxx11

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
    system "#{bin}/aria2c", "https://brew.sh/"
    assert File.exist?("index.html"), "Failed to create index.html!"
  end
end
