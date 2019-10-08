class TarantoolAT1 < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/1.10/src/tarantool-1.10.4.5.tar.gz"
  sha256 "b416bc33d5067c4053f159e8274480c2bdf19d5f07399c6ad8b6bc1311d9d928"
  head "https://github.com/tarantool/tarantool.git", :branch => "1.10", :shallow => false

  bottle do
    cellar :any
    sha256 "b73f79e43ca30c820086f937ffbf2c714c7df3a4718cd9f72027f5fe60b384b8" => :catalina
    sha256 "79305e9f8a203d07ac7af5b42bf899d5a00cdb03aa0b1ca9807ae47714204522" => :mojave
    sha256 "b448b102d61b1788b0937f781baf3d6e3e0bf290b5fc82184e32d7e50a5351f8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "autoconf"
  depends_on "automake"
  depends_on "icu4c"
  depends_on "libtool"
  depends_on "openssl"
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
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
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
