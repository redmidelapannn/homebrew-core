class Xmake < Formula
  desc "A cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/archive/v2.2.3.tar.gz"
  sha256 "c73d34805ab26d214f22fee74bf033942f91ce43bfc028663ffb910ad22c2c5d"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4e70376c655c7664353cfbdaffa68b60570753dde3d70bde42deca49c2824dfd" => :mojave
    sha256 "9e1dcff4b39975c28e646a0c41711c029406d9b228f246755ac8c7330c339589" => :high_sierra
    sha256 "23f0404c3e31bd12495d6c419a2a8ffe3f80a1f8ce62382f3c4edcdcd1eb008d" => :sierra
  end

  def install
    system "./install", "output"
    pkgshare.install Dir["xmake/*"]
    bin.install "output/share/xmake/xmake"
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR => pkgshare)
  end

  test do
    system bin/"xmake", "create", "-P", testpath
    system bin/"xmake"
    assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
  end
end
