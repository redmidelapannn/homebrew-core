class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.15.0.tar.gz"
  sha256 "b695713996fff2de8390fae42b81686eac85f1603554cc202edbbd8693f8a32e"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "51b8d4a2bd67d2db4ca661b4834262536f4abd1c911bfe6f18802066ac1ae02c" => :mojave
    sha256 "eb9ef7c1e15b71b24be8c6a6022cde639c0fe8fc488ccfa6291ac6b621ec5d64" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
