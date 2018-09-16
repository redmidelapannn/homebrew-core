class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  url "https://luajit.org/download/LuaJIT-2.0.5.tar.gz"
  sha256 "874b1f8297c697821f561f9b73b57ffd419ed8f4278c82e05b48806d30c1e979"

  bottle do
    rebuild 2
    sha256 "2049965540d4fe09e8477b628e25858027e38364838e7e7df948c20a634f2fdb" => :mojave
    sha256 "92032361264d1991c7a746abb30fe18bd12d79bd80f0887aab5b42b20210907e" => :high_sierra
    sha256 "ba9de090771087c31d74b7c25016616ddb0df8c5f002f5747e061fc8287a95ee" => :sierra
    sha256 "c2d022c81dff67407f9e2e8a499e818359597a50d4825b3103282e4b2dcee473" => :el_capitan
  end

  devel do
    url "https://luajit.org/download/LuaJIT-2.1.0-beta3.tar.gz"
    sha256 "1ad2e34b111c802f9d0cdf019e986909123237a28c746b21295b63c9e785d9c3"
  end

  head do
    url "https://luajit.org/git/luajit-2.0.git", :branch => "v2.1"
  end

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.change_make_var! "CCOPT_x86", ""
    end

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    ENV.O2 # Respect the developer's choice.

    args = %W[PREFIX=#{prefix}]

    # Build with 64-bit support
    args << "XCFLAGS=-DLUAJIT_ENABLE_GC64" unless build.stable?

    # The development branch of LuaJIT normally does not install "luajit".
    args << "INSTALL_TNAME=luajit" if build.devel?

    system "make", "amalg", *args
    system "make", "install", *args

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https://github.com/Homebrew/homebrew/issues/45854.
    lib.install_symlink lib/"libluajit-5.1.dylib" => "libluajit.dylib"
    lib.install_symlink lib/"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib/"pkgconfig/luajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}/share/lua/${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}/share/lua/${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}/${multilib}/lua/${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}/${multilib}/lua/${abiver}"
      if build.stable?
        s.gsub! "Libs:",
                "Libs: -pagezero_size 10000 -image_base 100000000"
      end
    end

    # Having an empty Lua dir in lib/share can mess with other Homebrew Luas.
    %W[#{lib}/lua #{share}/lua].each { |d| rm_rf d }
  end

  test do
    system "#{bin}/luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end
