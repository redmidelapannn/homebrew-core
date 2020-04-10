class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      :tag      => "v3.1.1",
      :revision => "2c8d2af0e7b9456ee5e2fe1d20673be245818f62"
  head "https://github.com/zeek/zeek.git"

  bottle do
    rebuild 1
    sha256 "b836dd839d45774560bbdfc50c62c5314be7d1893bfb9d4165f565561127a200" => :catalina
    sha256 "f055be99744b7723c537f9a31e81d0977e1e271bdcbca5ccb23b0b4f87743776" => :mojave
    sha256 "7966b82c3fd83154ad59b377e05d13a83aa6efef7de0054920bc5cf524af361f" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on :macos # Due to Python 2 (https://github.com/zeek/zeek/issues/706)
  depends_on "openssl@1.1"

  uses_from_macos "flex"
  uses_from_macos "libpcap"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DDISABLE_PYTHON_BINDINGS=on",
                      "-DBROKER_DISABLE_TESTS=on",
                      "-DBUILD_SHARED_LIBS=on",
                      "-DINSTALL_AUX_TOOLS=on",
                      "-DINSTALL_ZEEKCTL=on",
                      "-DCAF_ROOT_DIR=#{Formula["caf"].opt_prefix}",
                      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                      "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                      "-DZEEK_LOCAL_STATE_DIR=#{var}"
      system "make", "install"
    end
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/zeek --version")
    assert_match "ARP Parsing", shell_output("#{bin}/zeek --print-plugins")
  end
end
