class IosClassGuard < Formula
  desc "Objective-C obfuscator for Mach-O executables"
  homepage "https://github.com/Polidea/ios-class-guard/"
  url "https://github.com/Polidea/ios-class-guard/archive/0.8.tar.gz"
  sha256 "4446993378f1e84ce1d1b3cbace0375661e3fe2fa1a63b9bf2c5e9370a6058ff"
  head "https://github.com/Polidea/ios-class-guard.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8621db34c7f4a4c7797093420ce0e75ab275913e2d57c6bb80954bd28ac0eec1" => :mojave
    sha256 "9785672c2cd7fedb31fffa523cc7aedbc192af1b8a0f216ad7cdf81b57349939" => :high_sierra
    sha256 "307141066643a0710a800609cf12dd47d831dab1366bad4f3b693559d6af2426" => :sierra
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-workspace", "ios-class-guard.xcworkspace",
               "-scheme", "ios-class-guard",
               "-configuration", "Release",
               "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
    bin.install "build/Release/ios-class-guard"
  end

  test do
    (testpath/"crashdump").write <<~EOS
      1   MYAPP                           0x0006573a -[C03B setR02:] + 42
    EOS
    (testpath/"symbols.json").write <<~EOS
      {
        "C03B" : "MyViewController",
        "setR02" : "setRightButtons"
      }
    EOS
    system "#{bin}/ios-class-guard", "-c", "crashdump", "-m", "symbols.json"
  end
end
