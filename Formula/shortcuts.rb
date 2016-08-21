class Shortcuts < Formula
  desc "CLI manager for your text replacements on macOS"
  homepage "https://github.com/rodionovd/shortcuts"
  url "https://github.com/rodionovd/shortcuts/archive/v1.0.0.tar.gz"
  sha256 "74d1d123947d249b9695bdcd613a3977cebd6759d22fb78f3b33d5e4be8af2e3"

  head "https://github.com/rodionovd/shortcuts.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d91ad597442c20321b25b5deb880e53de52713452167edd83cfae25be24adff" => :el_capitan
  end

  depends_on :xcode => :build
  depends_on :macos => :el_capitan

  def install
    xcodebuild "-target", "shortcuts", "-configuration", "Release", "SYMROOT=symroot", "OBJROOT=objroot", "CODE_SIGN_IDENTITY="
    bin.install "symroot/Release/shortcuts"
  end

  test do
    system "#{bin}/shortcuts", "list"
  end
end
