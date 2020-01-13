class Grapple < Formula
  desc "Interruptible download accelerator, written in Rust"
  homepage "https://github.com/daveallie/grapple"
  url "https://github.com/daveallie/grapple/archive/v0.3.1.tar.gz"
  sha256 "eda7ca1bc01ee42e63d2ea3d55f4d6ec0d7d66fd6825aad1481d08a38cb64ae7"

  bottle do
    cellar :any_skip_relocation
    sha256 "d657780230e9bf45386ff24151432badbb57af002e1a0cd0fd32bd67431550ff" => :catalina
    sha256 "dcb21ee628b125416cb18bed01792b059f1d8ddb40e1497ef140c2ba62def551" => :mojave
    sha256 "4be7565b5002a6f935e31b3232427d62fc0a2cc7f6203bacc049337036099713" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/grapple --version")
    assert_equal "Grapple #{version}", output.strip

    shell_output("#{bin}/grapple -t2 http://i.imgur.com/z4d4kWk.jpg")
    assert_predicate testpath/"z4d4kWk.jpg", :exist?
  end
end
