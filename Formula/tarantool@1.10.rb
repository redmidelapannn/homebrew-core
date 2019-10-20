class TarantoolAT110 < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/1.10/src/tarantool-1.10.4.1.tar.gz"
  sha256 "dc99562840512151beca46d5618e6659b61e0749a99345750b14702f59a868fb"

  bottle do
    cellar :any
    sha256 "24aae67db50dd0b3ba006b93af098d718efa6d3ea1e20a43efb01cdf38d50638" => :catalina
    sha256 "289ec4012eac64ded4a6ffbe0bcf6f9fcecb4b080c3e7629dc54dd5aa937265a" => :mojave
    sha256 "73837d6ba97bc7601f2c048bb8084fc1221e1dcf9a672ec14bf7928734f9bfa8" => :high_sierra
  end

  keg_only :versioned_formula

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
