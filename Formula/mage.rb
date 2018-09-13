class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org/"
  url "https://github.com/magefile/mage.git",
      :tag => "v1.4.0",
      :revision => "49bafb86c808d73cabc5353d9ec040745dfab453"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c97b90d7addbe3f8ff16f88e3ba37e488fa785e3f62a54eb4022517b9b35988" => :mojave
    sha256 "039591aedcfe86d9f9869fe8475e148f6100f475fd0b85b638c93df17fc1ca16" => :high_sierra
    sha256 "313dcd02de522ef18c26dda3b52455b9a2334267a50b3d89911bd9798218c4ab" => :sierra
    sha256 "b373fb89aedcb2a1f36f5b52ebdcc98da6dee239a63b917e13437f8e9ab0d23a" => :el_capitan
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = prefix
    system "go", "run", "bootstrap.go"
  end

  test do
    assert_match /^Mage Build Tool v#{version}/, shell_output("#{bin}/mage --version 2>&1")

    (testpath/"magefile.go").write <<~EOS
      // +build mage

      package main
      import "fmt"
      func Build() {
        fmt.Println("hi build!")
      }
    EOS
    assert_match "hi build!", shell_output("#{bin}/mage build")
    assert_match "Targets:\n  build    \n", shell_output("#{bin}/mage -l")
  end
end
