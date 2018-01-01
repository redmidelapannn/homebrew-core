class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.3.4.tar.gz"
  sha256 "b414a785e3954a305b63a70f58f8b4c9cd6d94d80228be8ebf88a0268cf0ab0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6760ee774acb972c84ffa2205d4c66528e2569c8310b05a45b34038f8ad49d7" => :high_sierra
    sha256 "adabba70188d09e44f73a7e56e084a1b6d7bb57d4c1fea1e2637fe944f4c88b6" => :sierra
    sha256 "6bcc76fbd5c18c794822c4b154d17fdf6ef8e916a03325d3dbc1ff8d03078532" => :el_capitan
  end

  depends_on :xcode => ["7.3", :build]

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 10)
  end
end
