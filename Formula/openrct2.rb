class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      :tag      => "v0.2.3",
      :revision => "ac7a1ebf71566afb093befcb8293406c1a4025b4"
  revision 2
  head "https://github.com/OpenRCT2/OpenRCT2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "3b581684cfd3cdc211334f8d1c6c4a6189cb1b7a074eda5accd8e2eb859dbc35" => :catalina
    sha256 "9e631d94c77de91b358537c5ed0c071f28002d2e2442dc11e2ecccd8a2f96907" => :mojave
    sha256 "84d0b1c9b4a3fda29e5d02faac21632ed802a0ce209e7e1cb8cdf766f09fe0b6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype" # for sdl2_ttf
  depends_on "icu4c"
  depends_on "jansson"
  depends_on "libpng"
  depends_on "libzip"
  depends_on :macos => :high_sierra # "missing: Threads_FOUND" on Sierra
  depends_on "openssl@1.1"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "speexdsp"

  resource "title-sequences" do
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.1.2a/title-sequence-v0.1.2a.zip"
    sha256 "7536dbd7c8b91554306e5823128f6bb7e94862175ef09d366d25e4bce573d155"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/releases/download/v1.0.10/objects.zip"
    sha256 "4f261964f1c01a04b7600d3d082fb4d3d9ec0d543c4eb66a819eb2ad01417aa0"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/title").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    # By default macOS build only looks up data in app bundle Resources
    libexec.install bin/"openrct2"
    (bin/"openrct2").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
