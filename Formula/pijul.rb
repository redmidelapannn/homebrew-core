class Pijul < Formula
  desc "Patch-based distributed version control system"
  homepage "https://pijul.org"
  url "https://pijul.org/releases/pijul-0.10.0.tar.gz"
  sha256 "da3fcba4ab39a4371cda7273691364c2355c9b216bb7867d92dae5812ebb71d2"

  bottle do
    rebuild 1
    sha256 "95465c9894da95d24f9cefca31f24e3a983054836af259e4bb9cde5ca3d44b9e" => :mojave
    sha256 "0558519189f2668cb5543916943b54b761aa230a556f062fde5e55833d106978" => :high_sierra
    sha256 "aaa3221cd5b1332d422a95dab60b1e052a015014970bd17e5862375ae05c733b" => :sierra
    sha256 "b91ff77607076dbfcf53a84e65a2abd49b42c0a9aad212fa2499105564e766f8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "openssl"

  def install
    # Ensure that the `openssl-sys` crate picks up the intended library.
    # (If we're not careful, LibreSSL or OpenSSL 1.1 gets used instead.)
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    cd "pijul" do
      system "cargo", "install", "--root", prefix, "--path", "."
    end
  end

  test do
    system bin/"pijul", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"pijul", "add", "haunted", "house"
    system bin/"pijul", "record", "--all",
                                  "--message='Initial Patch'",
                                  "--author='Foo Bar <baz@example.com>'"
    assert_equal "haunted\nhouse\n", shell_output("#{bin}/pijul ls")
  end
end
