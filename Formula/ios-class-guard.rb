class IosClassGuard < Formula
  desc "Objective-C obfuscator for Mach-O executables"
  homepage "https://github.com/Polidea/ios-class-guard/"
  url "https://github.com/Polidea/ios-class-guard/archive/0.8.tar.gz"
  sha256 "4446993378f1e84ce1d1b3cbace0375661e3fe2fa1a63b9bf2c5e9370a6058ff"
  head "https://github.com/Polidea/ios-class-guard.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "16b3b8fe86a49c513fc842670b1138628f3d04c249449d6f7d900497d77143a5" => :mojave
    sha256 "023424dbc73ff9ccdef181742ba774025b4f6496399883c432d27054cc2ccd0d" => :high_sierra
    sha256 "f65bde4180476bee4fc413f72b35b606272bba1cd9c2e281ee108b54d80ab6ee" => :sierra
  end

  depends_on :xcode => :build
  depends_on :macos => :mavericks

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
