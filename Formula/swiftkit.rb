class Swiftkit < Formula
  desc "Start your next Open-Source Swift Framework"
  homepage "https://github.com/SvenTiigi/SwiftKit"
  url "https://github.com/SvenTiigi/SwiftKit/archive/1.0.0.tar.gz"
  sha256 "e30269929901c75d2f0f20a188336cf4e6b18e41eeb38fb45b10c73dd6c91944"
  head "https://github.com/SvenTiigi/SwiftKit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac78335b8ed487f05fb8c898a85914bbec73d84233ca4b6ab0c8412336f59d06" => :mojave
  end

  depends_on :xcode => ["8.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swiftkit"
  end

  test do
    system "#{bin}/swiftkit", "--version"
  end
end
