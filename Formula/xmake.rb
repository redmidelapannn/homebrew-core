class Xmake < Formula
  desc "A make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/waruqi/xmake/archive/v2.0.2.tar.gz"
  sha256 "e7a832d407a52a3eb290b5465eb01d1c1d5567eecb6fc627393093b9d6f84bae"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2460d364d40d934efdc0293faa3986e0914c93fedb484d2bf9a275e982ba58d2" => :el_capitan
    sha256 "ef7e6706a95d2b85e26bc3e2fc274485a4d0ee01809a514d6cb3dc75ffc5ba62" => :yosemite
    sha256 "3a09eb6c875ae78f7aeff924e297dd94c2db167db564761370e796ac067b3342" => :mavericks
  end

  def install
    system "./install", "output"
    pkgshare.install Dir["xmake/*"]
    bin.install "output/share/xmake/xmake"
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR => pkgshare)
  end

  test do
    system bin/"xmake", "create", "-P", testpath
    assert_match "build ok!", pipe_output(bin/"xmake")
  end
end
