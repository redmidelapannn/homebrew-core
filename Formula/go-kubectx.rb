class GoKubectx < Formula
  desc "Go-based kubectx alternative. 5x-10x faster"
  homepage "https://github.com/aca/go-kubectx"
  url "https://github.com/aca/go-kubectx/archive/v0.1.0.tar.gz"
  sha256 "9bcb7797a2581fd240a12141a129a8e62997ddc32ba75b4973563cafb995db2a"
  head "https://github.com/aca/go-kubectx.git"

  depends_on "go" => :build
  depends_on "fzf"

  conflicts_with "kubectx", :because => "kubectx also ships a kubectx binary"

  def install
    Dir.chdir "cmd/kubectx"
    system "go", "build", "-o", "#{bin}/kubectx"
    Dir.chdir "../kubens"
    system "go", "build", "-o", "#{bin}/kubens"
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}/kubectx -h 2>&1")
    assert_match "USAGE:", shell_output("#{bin}/kubens -h 2>&1")
  end
end
