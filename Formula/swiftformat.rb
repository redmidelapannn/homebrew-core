class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.8.tar.gz"
  sha256 "910e867c14716238f7395f679b9e2b3c108af37b1c0aafee43512d004fb19827"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "ebd1c64a3044ad8aec82cc6d224080809a5866b4bf93552eabe6119a6184c3be" => :mojave
    sha256 "411494dd5a584d2ff6177b834ea24f3b9ce9f5a6a62977dd6297f608da056724" => :high_sierra
  end

  depends_on :xcode => ["9.3", :build]

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
