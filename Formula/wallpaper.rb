class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.0.0.tar.gz"
  sha256 "49ab6121dcc78d17aae3219ceeeb1846792855179f11021192e5c42e500b166c"
  head "https://github.com/sindresorhus/macos-wallpaper.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "70ae7bb0f58ef1cc0f404ce21b41f00b534e194e4009ff79844650553bf69a27" => :catalina
    sha256 "767885c9e85cf40bef0b8be718ee0995562c38800f4074f41e9fbb2044cb10ab" => :mojave
    sha256 "cd0e09e632dce70927f6a6c94cb7eae470076175951948db9f4f5410b12686f5" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :macos => :sierra

  def install
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib", "--disable-sandbox"
    bin.install ".build/release/wallpaper"
  end

  test do
    system "#{bin}/wallpaper", "get"
  end
end
