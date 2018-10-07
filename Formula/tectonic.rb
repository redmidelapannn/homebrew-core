class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.10.tar.gz"
  sha256 "4b7c65692e97704dd3ffee3f4b3aaa57f3e478a2a5c6689dc9347be23ab65897"

  bottle do
    sha256 "f60dd13d87a072e28fd310b72a3c631339769417f9bb3833e34f660a5d2f825d" => :mojave
    sha256 "3fbbf127e6e3ba23cc04e8f74a919669902fba3aa6cf3236eadf28b752419ca9" => :high_sierra
    sha256 "3b81335c343fd6d66a19e731a567b0c41625fc36e58cca351cf46be3227146eb" => :sierra
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
