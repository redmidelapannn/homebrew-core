class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.0.4.tar.gz"
  sha256 "007d887814361b8124b9c9030dfc1b8819a0ed91c91dd3b5a8580c419c589ad7"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eedaebb4684cf798e1dbdd014a14b7618b298b0bbd7772a43da914b70dfa6051" => :mojave
    sha256 "b7add7041151e2a943737ec4180656cde2c17d5361ff98a0af31b44a7c48f3e1" => :high_sierra
    sha256 "55fc48acbe254be3c7c808e1f66cbad03fd8db633fb0945ca3f62cd9c773780e" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/containous/yaegi"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"yaegi", "cmd/yaegi/yaegi.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "3 + 1", 0)
  end
end
