class SwiftAbstractClass < Formula
  desc "Compile-time abstract class validation for Swift"
  homepage "https://github.com/uber/swift-abstract-class"
  url "https://github.com/uber/swift-abstract-class.git",
      :tag      => "v0.1.0",
      :revision => "66a1e878cb2d669b3139176902b7d997a92cc7cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "b419ebeadb73d572b2b048c0f7c31b4f785533fca93e1619cd292fb60e32fb3b" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abstractclassvalidator version")
  end
end
