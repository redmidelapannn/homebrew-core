class Einstein < Formula
  desc "Remake of the old DOS game Sherlock"
  homepage "https://web.archive.org/web/20120621005109/games.flowix.com/en/index.html"
  url "https://web.archive.org/web/20120621005109/games.flowix.com/files/einstein/einstein-2.0-src.tar.gz"
  sha256 "0f2d1c7d46d36f27a856b98cd4bbb95813970c8e803444772be7bd9bec45a548"

  bottle do
    cellar :any
    rebuild 1
    sha256 "18a7a75507f2c1c621be477e41fabcfbfbae53838842fbe55ed2b78332420d87" => :catalina
    sha256 "c3e9ee2977b4a378c1b93bb4da44df1c232a0646c77929ca97eda54e6a8dbb4a" => :mojave
    sha256 "e99287612918dbb9ca6a2d26eef0d1c6d9aac53c8d155e47d731f27536be624f" => :high_sierra
  end

  depends_on "sdl"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  # Fixes a cast error on compilation
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/einstein/2.0.patch"
    sha256 "c538ccb769c53aee4555ed6514c287444193290889853e1b53948a2cac7baf11"
  end

  def install
    system "make"

    bin.install "einstein"
    (pkgshare/"res").install "einstein.res"
  end
end
