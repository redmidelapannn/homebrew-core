class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.xz"
  sha256 "3a44a802631606e138a9e172a3e9f5bcbaac43ce2895c1d8e2b46f30487e77a3"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "879a32c5fc67a5270b5ca8ab9230705f162d0fda12e22f87a7107b11f63a1b02" => :mojave
    sha256 "3bfca06d1c542d5656e214ca71c05562f40ef18b8f6e076133e4873ce3241368" => :high_sierra
    sha256 "eea0d0408f34399e7940fb046802d4d3b1c6d631aa196916a84dbdf6afff7290" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    # Fix "error: use of undeclared identifier 'make_unique'"
    # Reported upstream 15 May 2018 https://github.com/aria2/aria2/issues/1198
    inreplace "src/bignum.h", "make_unique", "std::make_unique"
    inreplace "configure", "-std=c++11", "-std=c++14"

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

  def caveats; <<~EOS
    aria2 requires a config file to start as daemon.
    Please create #{etc}/aria2.conf and add a configuration.
  EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/aria2/bin/aria2c --conf-path=#{HOMEBREW_PREFIX}/etc/aria2.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/aria2c</string>
          <string>--conf-path=#{etc}/aria2.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/aria2c", "https://brew.sh/"
    assert_predicate testpath/"index.html", :exist?, "Failed to create index.html!"
  end
end
