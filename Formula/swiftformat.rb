class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.7.tar.gz"
  sha256 "5bb1e773b5b279c290845f8f7e7de04f86d1bd978a9068f23b385651fd0b4d38"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "dfc99984ccc544587437de7f7a9c988efef27e1926048b5d32c6035d98ad5a94" => :catalina
    sha256 "756cb8f8d8970bcd987a3b7283780ef6449df9dd03332ecf91f0a977f4c7656a" => :mojave
    sha256 "ba97f18be475519a1cc5d8a5b84d604876d402621199ddbd609d2e4f301e5fb6" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
