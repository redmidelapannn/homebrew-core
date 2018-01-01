class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.3.4.tar.gz"
  sha256 "b414a785e3954a305b63a70f58f8b4c9cd6d94d80228be8ebf88a0268cf0ab0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b75285eb6342766b71a4aba51c4900cc6693036b4e38654a6d6b5614c2755db9" => :high_sierra
    sha256 "517f4cdc961a196aeba7cd5aecb5d08ff8b5f3c645e56f619f02b4697a550e56" => :sierra
  end

  depends_on :xcode => ["7.3", :build]

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 10)
  end
end
