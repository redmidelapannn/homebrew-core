class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/v0.61.tar.gz"
  sha256 "b8e19743cd499436dce58af67479997e621fe50e21e31f08f440d2303e11f5d6"
  revision 1
  head "https://github.com/CorsixTH/CorsixTH.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e318ed949f2acc550382c44f829df09c744c4ad80032f3c77098e07e6aad3f86" => :high_sierra
    sha256 "766e7065032b674e20b64fa7015587f56a6477ca2567bd3a6aba3759d220da82" => :sierra
    sha256 "c66e3c8cb74db6ea95cd997cf9e5aa49892b19b10cfbf2069eb1a5bf8b00dcb4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :xcode => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  resource "lpeg" do
    url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/lpeg-1.0.1.tar.gz"
    mirror "https://ftp.heanet.ie/mirrors/ftp.openbsd.org/distfiles/lpeg-1.0.1.tar.gz"
    sha256 "62d9f7a9ea3c1f215c77e0cadd8534c6ad9af0fb711c3f89188a8891c72f026b"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v_1_6_3.tar.gz"
    sha256 "5525d2b8ec7774865629a6a29c2f94cb0f7e6787987bf54cd37e011bfb642068"
  end

  def install
    ENV["TARGET_BUILD_DIR"] = "."
    ENV["FULL_PRODUCT_NAME"] = "CorsixTH.app"

    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/5.3/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

    resources.each do |r|
      r.stage do
        system "luarocks", "build", r.name, "--tree=#{luapath}"
      end
    end

    system "cmake", ".", "-DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}/lua",
                         "-DLUA_LIBRARY=#{Formula["lua"].opt_lib}/liblua.dylib",
                         "-DLUA_PROGRAM_PATH=#{Formula["lua"].opt_bin}/lua",
                         *std_cmake_args
    system "make"
    prefix.install "CorsixTH/CorsixTH.app"

    env = { :LUA_PATH => ENV["LUA_PATH"], :LUA_CPATH => ENV["LUA_CPATH"] }
    (bin/"CorsixTH").write_env_script(prefix/"CorsixTH.app/Contents/MacOS/CorsixTH", env)
  end

  test do
    app = prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
    assert_includes MachO::Tools.dylibs(app),
                    "#{Formula["lua"].opt_lib}/liblua.5.3.dylib"
  end
end
