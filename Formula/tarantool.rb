class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/2.2/src/tarantool-2.2.1.1.tar.gz"
  sha256 "42c6c61b7d9a2444afd96e4f5e1828da18ea2637d1e9d61dc543436ae48dd87f"
  revision 2
  head "https://github.com/tarantool/tarantool.git", :branch => "2.1", :shallow => false

  bottle do
    cellar :any
    sha256 "9c79f9f5087f0c5a03b4504442ffc83f67490ad3541bef3fe1ade8a1f657d147" => :catalina
    sha256 "18e7723b51c69bd3bcc15c979517dadd5745c7202982997d86adeebfacfb8019" => :mojave
    sha256 "3d1771fa528fcd2391efcc071cb54f08d5b35a3a339bb45335bde4624d13b137" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    # Necessary for luajit to build on macOS Mojave (see luajit formula)
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    args = std_cmake_args
    args << "-DCMAKE_INSTALL_MANDIR=#{doc}"
    args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    args << "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}"
    args << "-DENABLE_DIST=ON"
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
    args << "-DREADLINE_ROOT=#{Formula["readline"].opt_prefix}"
    args << "-DCURL_INCLUDE_DIR=#{sdk}/usr/include"
    args << "-DCURL_LIBRARY=/usr/lib/libcurl.dylib"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  def post_install
    local_user = ENV["USER"]
    inreplace etc/"default/tarantool", /(username\s*=).*/, "\\1 '#{local_user}'"

    (var/"lib/tarantool").mkpath
    (var/"log/tarantool").mkpath
    (var/"run/tarantool").mkpath
  end

  test do
    (testpath/"test.lua").write <<~EOS
      box.cfg{}
      local s = box.schema.create_space("test")
      s:create_index("primary")
      local tup = {1, 2, 3, 4}
      s:insert(tup)
      local ret = s:get(tup[1])
      if (ret[3] ~= tup[3]) then
        os.exit(-1)
      end
      os.exit(0)
    EOS
    system bin/"tarantool", "#{testpath}/test.lua"
  end
end
