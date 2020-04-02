class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.59.tar.gz"
  sha256 "4eb33136ee4d0daaf5aeb6eba410181ddeed946cce6942796083e7218d520070"

  bottle do
    cellar :any
    sha256 "d52a8befd1a61cef6324b237836dc8ec5d22ea7dac7a3fe6aa26f2308de2c262" => :catalina
    sha256 "d06ae2b47cddb3eed9ce5df8a98567e00ca4b96a3078cb2e64442f394cb85df2" => :mojave
    sha256 "e9b2f8f51f4496421dc1a0cbf8d2c6d460447bdc81c03e5b2f0824a83f081581" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/0.10.19/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    bash_completion.install "contrib/completions/ffsend.bash"
    fish_completion.install "contrib/completions/ffsend.fish"
    zsh_completion.install "contrib/completions/_ffsend"
  end

  test do
    system "#{bin}/ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
