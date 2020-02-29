class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.7.4.tar.gz"
  sha256 "06c6d0bc37d9361e916fe283061dcd9caa6078e4368ff65cbc8087d16aaa9236"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba464200d9514fcb3d9a58a18f5c55c01b9a1a7ffa471fdd775fb9d90ca6a845" => :catalina
    sha256 "71ff9b5f2b1fc467bac34f74c1eaf34fbcce528aced8703775955b5e896d0b55" => :mojave
    sha256 "26b49842501f57ec7dfc16031928f683c269ab9ade7939d3f86c7ed9487b841e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", "-o", "#{bin}/#{name}", "-trimpath", "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command:
      - bash
      workdir: /usr/src/app
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
