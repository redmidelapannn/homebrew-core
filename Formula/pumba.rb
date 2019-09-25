class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.6.4.tar.gz"
  sha256 "099e12554997c216d8eaae69ead5ff27517fa12954017b6e222a186171a23464"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a37302da380e061ecc02779c56c0ae5adfcee414c8d748817701c6afe0697776" => :mojave
    sha256 "f93c59cebba2e389584b5541a4dd91d2d303043e9e8286a7ad214cd6f2913996" => :high_sierra
    sha256 "63d1cf28b335ca619c39e2af314bcc5e47fad98f757f80629d53bacd521ca8fe" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/alexei-led/pumba"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"pumba", "-ldflags",
             "-X main.Version=#{version}", "./cmd"
      prefix.install_metafiles
    end
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
