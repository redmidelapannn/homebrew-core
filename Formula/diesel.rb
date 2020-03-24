class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v1.4.4.tar.gz"
  sha256 "e3f80fbc31d3233821f90f6830750373810ddb739f2300c94cf68b342e6bcacb"
  head "https://github.com/diesel-rs/diesel.git"

  bottle do
    cellar :any
    sha256 "b3b5402ac39b03bb607595f15338ba6f11b65a518c5a32a384fbd5d536ece706" => :catalina
    sha256 "01b749a5c151d7a1010bcc26e7b6051b3f88622d2c3be5615c1c54d2bcd0e69c" => :mojave
    sha256 "5af2a2e77977f2c595683c9375ca3d0470ed2fbd4b6168963e90702488b9c2db" => :high_sierra
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", "--root", prefix, "--path", "diesel_cli"

    system "#{bin}/diesel completions bash > diesel.bash"
    system "#{bin}/diesel completions zsh > _diesel"
    system "#{bin}/diesel completions fish > diesel.fish"

    bash_completion.install "diesel.bash"
    zsh_completion.install "_diesel"
    fish_completion.install "diesel.fish"
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
