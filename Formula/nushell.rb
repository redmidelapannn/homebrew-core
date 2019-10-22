class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.4.0.tar.gz"
  sha256 "7111d3067db3dabc6137e8a441670de0fae63deae522d1675fc77402948f2c67"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e75ddee50af90b36c2b315692ee933fee5f1e70bbe6797f5d98aed5ceab3ec41" => :catalina
    sha256 "9fbb7e2cb947af8a1feaeddb1c7625a1c28afecac4989a42330148be9581d0b8" => :mojave
    sha256 "636cc1f7a4f04fd8ccf44a98eb37c3897ba0fe672652f538f508bfb8c1f53640" => :high_sierra
  end

  depends_on "openssl@1.1"

  # Nu requires features from Rust 1.39 to build, so we can't use Homebrew's
  # Rust; picking a known-good Rust nightly release to use instead.
  resource "rust-nightly" do
    url "https://static.rust-lang.org/dist/2019-10-13/rust-nightly-x86_64-apple-darwin.tar.xz"
    sha256 "25608a9b37283fc567537637aca7c50744fed09c83f9db7807a47e2faf1cbd02"
  end

  def install
    resource("rust-nightly").stage do
      system "./install.sh", "--prefix=#{buildpath}/rust-nightly"
      ENV.prepend_path "PATH", "#{buildpath}/rust-nightly/bin"
    end
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"get-json.nu").write <<~EOS
      echo '{"foo": 1, "bar": "this very specific text"}' | from-json | get bar | echo $it
      exit
    EOS
    assert_match " this very specific text\n", shell_output("#{bin}/nu < get-json.nu")
  end
end
