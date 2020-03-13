class Pijul < Formula
  desc "Patch-based distributed version control system"
  homepage "https://pijul.org"
  url "https://pijul.org/releases/pijul-0.12.0.tar.gz"
  sha256 "987820fa2a6fe92a9f516f5e9b41ad59a597973e72cb0c7a44ca0f38e741a7e6"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "9d22e1060b7b24a43a439daa2ac4181611aa11fb0c212a09213733c7ee590c6f" => :catalina
    sha256 "acc6136b8c098e88b254f418f3746f6ccb22d5d329e63f4e0806ac9659a7a538" => :mojave
    sha256 "86a715b7b553524787c8dbf5dce559fb4a824c333590c9095d270e880c45a96f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "nettle"
  depends_on "openssl@1.1"

  def install
    # Applies a bugfix (0.20.7 -> 0.20.8) update to a dependency to fix compile.
    # Remove with the next version.
    system "cargo", "update", "-p", "thrussh", "--precise", "0.20.8"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    cd "pijul" do
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
