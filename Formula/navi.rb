class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.0.2.tar.gz"
  sha256 "f32cb110c1255d3b8f17a59fccc51aa92e842ff731c004c2cecf66234c1a8c3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "64869734a263a73342e5223eacafa8aef908338fc2ad126bba3f1d915f3df42e" => :catalina
    sha256 "c1f991df1656f303063b3227c4db275d9679f4a1e102f5b8a4f76ab17129f698" => :mojave
    sha256 "8a9f86c3f20818f7c8f565cc70b348f359c994ee0357576d76933b5f0a0c36b8" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    (libexec/"cheats").install Dir["cheats/*"]
    (libexec/"shell").install Dir["shell/*"]
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar", shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats best foo")
  end
end
