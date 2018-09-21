class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-3.0.0.tar.xz"
  sha256 "68a0137e0e15061ee7dec53a2e424aa3266611720db3843853c6e7774a414f40"
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  bottle do
    rebuild 1
    sha256 "8acec33b8a9370344b763f30fc29942e1fc337e6a87e75a997870902f168dde0" => :mojave
    sha256 "808e340a9848385ae5a2d6442abb90e51743188af0fe4481d0111f9e74b6861a" => :high_sierra
    sha256 "7f3c19fdb796bab19d84be024f7a9aadb786df1e18e70b4d072979fbc4880c2a" => :sierra
    sha256 "cb44299fcd817a49ffa67b698100579c01d41078687bb060e31899fe60fb8fc9" => :el_capitan
  end

  depends_on "cmocka" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit"
  depends_on "nettle"

  def install
    # Since we don't run `make install` or `make etc-install`, we need to
    # install root.hints manually before running `make check`.
    cp "etc/root.hints", buildpath
    (etc/"kresd").install "root.hints"

    %w[all lib-install daemon-install client-install modules-install
       check].each do |target|
      system "make", target, "PREFIX=#{prefix}", "ETCDIR=#{etc}/kresd"
    end

    cp "etc/config.personal", "config"
    inreplace "config", /^\s*user\(/, "-- user("
    (etc/"kresd").install "config"

    (etc/"kresd").install "etc/root.hints"

    (buildpath/"root.keys").write(root_keys)
    (var/"kresd").install "root.keys"
  end

  # DNSSEC root anchor published by IANA (https://www.iana.org/dnssec/files)
  def root_keys; <<~EOS
    . IN DS 19036 8 2 49aac11d7b6f6446702e54a1607371607a1a41855200fd2ce1cdde32f24e8fb5
    . IN DS 20326 8 2 e06d44b80b8f1d39a95c0b0d7c65d08458e880409bbc683457104237c7f8ec8d
  EOS
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>WorkingDirectory</key>
      <string>#{var}/kresd</string>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{sbin}/kresd</string>
        <string>-c</string>
        <string>#{etc}/kresd/config</string>
      </array>
      <key>StandardInPath</key>
      <string>/dev/null</string>
      <key>StandardOutPath</key>
      <string>/dev/null</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/kresd.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    system sbin/"kresd", "--version"
  end
end
