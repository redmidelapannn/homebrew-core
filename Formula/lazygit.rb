class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.15.2.tar.gz"
  sha256 "63c130e34f4ef5ad9af331ee78214fa0dfe266a61d0faf8d6b306bb11d16539d"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ae6b54940ca44611000d0032e44e5032cb3b800fbd4892b98e42dd9ac43c317" => :catalina
    sha256 "518c24781060e74a96feee4ebd2e2d38337a4e49dd8525d23a1d6c4983fe6f7f" => :mojave
    sha256 "f2a88a8ddfd00e382ab92835023eb49391bd180b6e1cea107f23754c0169524b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
