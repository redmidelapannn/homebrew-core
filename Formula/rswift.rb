class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag      => "v5.0.2",
      :revision => "7d79ec7ffe6b5c42aad1960e8f31623f68ebedbf"
  head "https://github.com/mac-cain13/R.swift.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "438e662d49b9624d95baff913a2213ebca2b34aaa3380bbf194b06309f0a0cf4" => :mojave
    sha256 "5c6d4b4d92f96d77a6bb5d816a9661901f3f61be696ea3bfc3aff7507b318c34" => :high_sierra
  end

  depends_on :xcode => "10.0"

  def install
    system "swift", "build", "--disable-sandbox",
                             "-c",
                             "release",
                             "-Xswiftc",
                             "-static-stdlib",
                             "-Xswiftc",
                             "-target",
                             "-Xswiftc",
                             "x86_64-apple-macosx10.11"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
  end
end
