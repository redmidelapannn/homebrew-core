class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.27.0/aria2-1.27.0.tar.xz"
  sha256 "166538f3460e405e9812981a4748799fb191ab0bd68e9b38a8e6be0553f9248c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a5b95532ebcf764f09016b11b78f12c31e2e00b16e5698bf789bdae3ee4a7d3" => :el_capitan
    sha256 "252c20347a09a6ae24702e423d5d9540d12a4e1bfacc6907a4b1efab24ee9582" => :yosemite
    sha256 "055c3e581380ed8639d0e0e1ab8899c002e9a1986e3440c13445c9294ad54c50" => :mavericks
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
    system "#{bin}/aria2c", "http://brew.sh"
    assert File.exist?("index.html"), "Failed to create index.html!"
  end
end
