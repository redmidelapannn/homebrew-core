class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.6.2.tar.gz"
  sha256 "28f9218aea0bd0b390bb8129aa6ac2724b7444c0e0c62e21df8d3aabdb896b18"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    revision 1
    sha256 "385fbbd9b1784151455ec0bd4f4606c38146d46f028336a548bf3f4fea3614d1" => :el_capitan
    sha256 "c25f389a1eee78d91f8128c1e17fac4a135b95333f24e35549cd23d1222df149" => :yosemite
    sha256 "854e04788db11d1bb1b25b0086b4275b9edced1933d607d603ac559ddda73f4c" => :mavericks
  end

  option :universal
  option "with-libev", "Build libev plugin"
  option "without-libevent", "Do not build libevent plugin"

  deprecated_option "with-libev-plugin" => "with-libev"
  deprecated_option "without-libevent-plugin" => "without-libevent"

  depends_on "libev" => :optional
  depends_on "libuv" => :optional
  depends_on "libevent" => :recommended
  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DLCB_NO_TESTS=1"

    ["libev", "libevent", "libuv"].each do |dep|
      args << "-DLCB_BUILD_#{dep.upcase}=" + (build.with?(dep) ? "ON" : "OFF")
    end
    if build.universal?
      args << "-DLCB_UNIVERSAL_BINARY=1"
      ENV.universal_binary
    end
    if build.without?("libev") && build.without?("libuv") && build.without?("libevent")
      args << "-DLCB_NO_PLUGINS=1"
    end

    mkdir "LCB-BUILD" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
