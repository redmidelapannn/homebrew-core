class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.1.tar.gz"
  sha256 "1e5a27ce43cdfc3f928ec2560ea0c02b818b9375a50abeb5b0c25d0340776659"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "58ca39786f249495d46342ba43f5bb137fd1145472c3affb48b527a4346aadfa" => :catalina
    sha256 "6abd703805c24fc0f6d46a2fb888e78d20c2f4026224c76c71b49399f24ae316" => :mojave
    sha256 "5845df981a65249bbd7b9ebb8a87e32c8a2161fffe1e0c0e8ff3f52504fab0c7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"yaegi", "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "3 + 1", 0)
  end
end
