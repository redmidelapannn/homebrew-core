class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v3.1.tar.gz"
  sha256 "293ef20ea4ecb6927f873591bb6d452979ebc31af80fdad48c173816b4ae6c6f"

  bottle do
    rebuild 1
    sha256 "bd6c39eba5ad89cb2e363a2e65bba9e383d73bea75338f97dc2d161f474e5588" => :high_sierra
    sha256 "3089847cc471143826ce760bdd8e01635e4fb195c1f131b31dff8eb9a3ec76af" => :sierra
    sha256 "d46f4625efbc0d5ecd085db1c22748d89bbbc8f9ce8ef557077faae04de25ef8" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    # NOTE: This uses Cargo to build from the next release.
    system "rustc", "shellharden.rs"
    bin.install "shellharden"
  end

  test do
    (testpath/"script.sh").write <<~EOS
      dog="poodle"
      echo $dog
    EOS
    system bin/"shellharden", "--replace", "script.sh"
    assert_match "echo \"$dog\"", (testpath/"script.sh").read
  end
end
