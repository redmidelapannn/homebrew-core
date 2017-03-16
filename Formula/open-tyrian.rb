class OpenTyrian < Formula
  desc "Open-source port of Tyrian"
  homepage "https://bitbucket.org/opentyrian/opentyrian"
  url "https://www.camanis.net/opentyrian/releases/opentyrian-2.1.20130907-src.tar.gz"
  sha256 "f54b6b3cedcefa187c9f605d6164aae29ec46a731a6df30d351af4c008dee45f"
  head "https://bitbucket.org/opentyrian/opentyrian", :using => :hg

  bottle do
    rebuild 1
    sha256 "ddecc10f4e9017869bfabf4d3a3b44d140f0c988ea6303120fe56a9501ed5998" => :sierra
    sha256 "e145b7414f1f5122f33749f4eef800a9f1ce7b8c279eb1838c527a2f2f90ae79" => :el_capitan
    sha256 "f141def542b69dd5bdf4be2eb2d3b5bc1d8e9120edf4c072137ee91711093d53" => :yosemite
  end

  depends_on "sdl"
  depends_on "sdl_net"

  resource "data" do
    url "https://camanis.net/tyrian/tyrian21.zip"
    sha256 "7790d09a2a3addcd33c66ef063d5900eb81cc9c342f4807eb8356364dd1d9277"
  end

  def install
    datadir = pkgshare/"data"
    datadir.install resource("data")
    args = []
    if build.head?
      args << "TYRIAN_DIR=#{datadir}"
    else
      inreplace "src/file.c", "/usr/share/opentyrian/data", datadir
    end
    system "make", *args
    bin.install "opentyrian"
  end

  def caveats
    "Save games will be put in ~/.opentyrian"
  end

  test do
    system "#{bin}/opentyrian", "--help"
  end
end
