class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.0.8.tar.gz"
  version "1.0.8"
  sha256 "02b7c9b135e4fe033cedf59a4c465c0135b557d3d11b5248d02e5755247f0e08"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e6ec267c02bd68c3c8841afbc3204feb635e4f9fa0a687253809861388d7f80" => :sierra
    sha256 "99361cafb7cb33c60cb5573f570cbab0082427752f63ede6d12257829ca1ff97" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/DarthSim/overmind").install buildpath.children
    system "go", "build", "-o", "#{bin}/overmind", "-v", "github.com/DarthSim/overmind"
  end

  test do
    expected_message = "overmind: open ./Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}/overmind start 2>&1", 1)
    (testpath/"Procfile").write("test: echo 'test message'")
    expected_message = "inappropriate ioctl for device"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
