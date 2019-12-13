class Chicon < Formula
  desc "Command-line utility for modifying Finder thumbnail icons"
  homepage "https://github.com/okdana/chicon"
  url "https://github.com/okdana/chicon/archive/v0.3.0.tar.gz"
  sha256 "ccad1f028be8f5122a221c89267e7d188b032d23f3aff255ea7afafb26adf80f"
  head "https://github.com/okdana/chicon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce894c169547232036450aa0346437f4100bde480bb83e1678ba939f90f20b61" => :catalina
    sha256 "43c3c1105bf4a283e558b835a9bbca608f449e3ce16c6d3ff9ca07a8fc7e9edb" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

  def install
    system "make", "chicon"
    bin.install "./chicon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chicon  --version")

    File.write(testpath/"test-a.txt", "w")
    File.write(testpath/"test-b.txt", "w")
    system bin/"chicon", "--copy", testpath/"test-a.txt", testpath/"test-b.txt"
  end
end
