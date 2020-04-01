class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/v0.7.2.tar.gz"
  sha256 "8efd38c7641f94f0cf83f04ac4e6033c1794b93dbfdaca893c3403801afe7cc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "4014ba7e8b90f76a31b3087009b98879456b89289b0aae0e8283af17f878b86b" => :catalina
    sha256 "60b8217162989d199c66cf717dc52c88185296533c759a03457dd6c51f5e5c2b" => :mojave
    sha256 "96bf4655919701583139e34f0e30f85a9d95e02d7afb644146108aa353a39145" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
