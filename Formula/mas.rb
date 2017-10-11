class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas/archive/v1.3.1.tar.gz"
  sha256 "9326058c9e572dd38df644313307805757d7ea6dfea8626e0f41c373ecbd46b5"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "edff420ee09a395051e0a4a5852d2ccd201fb2b77709575a4810059214732e2c" => :high_sierra
    sha256 "0f6ec66b0d97e6cd9da5e81358c6f3efc426a7c500a72a8c72d747f77b93bfae" => :sierra
    sha256 "882b6026be3591b17ca90ef05daa1bd038230961eb133022b8e6be04f7c8327f" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "-project", "mas-cli.xcodeproj",
               "-scheme", "mas-cli",
               "-configuration", "Release",
               "SYMROOT=build"
    bin.install "build/mas"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
  end
end
