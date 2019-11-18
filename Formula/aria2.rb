class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0.tar.xz"
  sha256 "1e2b7fd08d6af228856e51c07173cfcf987528f1ac97e04c5af4a47642617dfd"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bafe441400874c17459cbb31d04f83028519c08eefcca6415fe99b071ea5348c" => :catalina
    sha256 "f6f6959790646d0eae8993284c7eb310173bd1512eee5276f94eb10a04c0cebf" => :mojave
    sha256 "2165188a50724bf8e8dc712894dfc94817448a84e2c18b5dad46870763f28997" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2"
  uses_from_macos "libxml2"

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-appletls
      --with-libssh2
      --without-openssl
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "https://brew.sh/"
    assert_predicate testpath/"index.html", :exist?, "Failed to create index.html!"
  end
end
