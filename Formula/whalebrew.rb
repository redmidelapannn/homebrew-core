class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
    :tag      => "0.2.3",
    :revision => "7b371f6e0fa414e61761359441268b61c8a741ff"
  head "https://github.com/whalebrew/whalebrew.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e86b26fa3d0e9c47688a852fed4114b6d0015d7441fe7ccd279ee7bb13243b0e" => :mojave
    sha256 "d9c155789e76f2447a007fcf5f54f0c9d3fe0505cca2978240c823fbface9e9a" => :high_sierra
    sha256 "32e2591fd879ad347265d40dff05fecd3e6c36817365e2de5bc692443f5557b0" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"whalebrew", "."
  end

  test do
    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
