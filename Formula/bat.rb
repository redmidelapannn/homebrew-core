class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.13.0.tar.gz"
  sha256 "f4aee370013e2a3bc84c405738ed0ab6e334d3a9f22c18031a7ea008cd5abd2a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "99c0c31296717a4c8d894d02b53eece585bbead988ad1ca7201d94b3596254c2" => :catalina
    sha256 "5b2cb26b9999afa792e0653dd1f718484b90d03171b289c6dfb72febeddf0d7c" => :mojave
    sha256 "b1610c6e9f1dfb3a378af8eca5f1fa40793076a1d3d9623da3e244307ca63d6d" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
