class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/0.4.3.tar.gz"
  sha256 "d3d463c36597158cc5a8ac327c1710a73825ae1a960ead707915d98de4dc8732"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd4dc4ec4c3b87b08d9e4f33e00d691c5c081505f53bf351ba6a9af2e0b6d9e5" => :mojave
    sha256 "821477edcefd45b44e0ff4f66ab948044ac883aa6abed158a351f3ae280fcc5c" => :high_sierra
    sha256 "97c79bd1b3887d258eff1377626026c659b1d757ff4920fd649c433b86ceb933" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
