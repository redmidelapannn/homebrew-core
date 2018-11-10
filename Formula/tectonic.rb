class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.11.tar.gz"
  sha256 "e700dc691dfd092adfe098b716992136343ddfac5eaabb1e8cfae4e63f8454c7"
  revision 1

  bottle do
    sha256 "ccfee1f50fea4ec3d06fa46a4e93c9a6616a2937f0d8c63a6a7a76fdc1cccf0e" => :mojave
    sha256 "eaaeb741ba0a2004c14c67abcb4f45f7af6287f31f2e73cbd3af6d0d47c3f205" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "openssl"

  def install
    ENV.cxx11
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version # needed for CLT-only builds

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", "."
    pkgshare.install "tests"
  end

  test do
    system bin/"tectonic", "-o", testpath, pkgshare/"tests/xenia/paper.tex"
    assert_predicate testpath/"paper.pdf", :exist?, "Failed to create paper.pdf"
    assert_match "PDF document", shell_output("file paper.pdf")
  end
end
