class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.3.4.tar.gz"
  sha256 "c950560292984d135ed5c92c87a2969a7b2b2d3ab97c5d4d5f66075edbc95169"
  head "https://github.com/jmacdonald/amp.git"

  bottle do
    sha256 "76c56fce963c2162c8c122332b03b09a5ad18dd0701ee34423c4d642d9eb0a8d" => :high_sierra
    sha256 "4169c788e04f82549d4d59eea021875e2d781badbae9ec47d2f1df62169a0215" => :sierra
    sha256 "7561f3016672413ce39d92269e28015b5d71a564a733c54b0cb3baf5d540f3bf" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "openssl"

  def install
    # Ensure we link against openssl@1.0, not openssl@1.1.
    ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl"].opt_include
    ENV["OPENSSL_LIB_DIR"] = Formula["openssl"].opt_lib

    system "cargo", "build", "--release"
    bin.install "target/release/amp"
  end

  test do
    ENV["TERM"] = "xterm"

    # Setup a path to which Amp will write data.
    amp_file_path = testpath/"amp_file"

    (testpath/"test.exp").write <<~EOS
      spawn "#{bin}/amp" "#{amp_file_path}"
      interact timeout 1 return

      # switch to insert mode and add data
      send "i"
      send "test data"

      # escape to normal mode, save the file, and quit
      send "\x1b"
      send "s"
      send "Q"
      expect eof
    EOS

    # Run Amp using expect and verify that it writes the correct data.
    system "expect", "-f", "test.exp"
    assert_match "test data\n", IO.read(amp_file_path)
  end
end
