class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.9.3.tar.gz"
  sha256 "b95a258099aee9a56e620ccebcecabc246ee7f8390e3937ccedadd609c6d2dd0"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1d3a4411a4b4806eb10eb36fb2c9306cd8f898a295f72a3218f43fdea9bf3bea" => :mojave
    sha256 "e13a92a4fcb3b772eb39530e53acc711b6cded8041867c01a7ef76eca3902744" => :high_sierra
    sha256 "d9d38f30ef207e60076faaf6e6c5dfd0c791eb5fa6b1ec15fbd4faf8b1e15bbe" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "go", "run", "build.go"
    bin.install "restic"
  end

  test do
    mkdir testpath/"restic_repo"
    ENV["RESTIC_REPOSITORY"] = testpath/"restic_repo"
    ENV["RESTIC_PASSWORD"] = "foo"

    (testpath/"testfile").write("This is a testfile")

    system "#{bin}/restic", "init"
    system "#{bin}/restic", "backup", "testfile"

    system "#{bin}/restic", "restore", "latest", "-t", "#{testpath}/restore"
    assert compare_file "testfile", "#{testpath}/restore/testfile"
  end
end
