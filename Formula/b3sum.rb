class B3sum < Formula
  desc "The BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.2.0.tar.gz"
  sha256 "62aa27ef51f2cad6ffa49d311bf29d7d0e293f7a04f3cc07ce78bc6ad8e84db7"

  bottle do
    cellar :any_skip_relocation
    sha256 "df6b687ee32df5da06add62a430af470170fd64fc0003163ca5ce4fbe8014dce" => :catalina
    sha256 "a4b8d57e8dc4b65688451104456b7477f81124d465cb133e9b9a44eb2346e7d1" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./b3sum/"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
