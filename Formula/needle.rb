class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      :tag      => "v0.9.1",
      :revision => "88a8a425221fa0a3a657dc301dc3561616ba8b36"

  bottle do
    cellar :any_skip_relocation
    sha256 "d118804ac0c7c21f8dd8a900b3ddf04925e9eb9b822f4e0be314402c1d27d709" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
