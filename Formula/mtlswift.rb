class Mtlswift < Formula
  desc "Swift code-generator for your Metal shaders"
  homepage "https://github.com/s1ddok/mtlswift"
  url "https://github.com/s1ddok/mtlswift.git", :tag => "0.9.0"
  head "https://github.com/s1ddok/mtlswift.git"
  version "0.9.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb731917d87817b55f7ca4e94d61e596b6353730c15f126e741f6f16226f8203" => :catalina
    sha256 "b4216c18888e536d21c30ea21abdf32b676210022e7c2139a4ddde3256919673" => :mojave
  end

  depends_on :xcode => "11.1"

  def install
     system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/mtlswift" "help"
  end
end
