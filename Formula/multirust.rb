class Multirust < Formula
  desc "Manage multiple Rust installations"
  homepage "https://github.com/brson/multirust"
  # Use the tag instead of the tarball to get submodules
  url "https://github.com/brson/multirust.git",
    :tag => "0.8.0",
    :revision => "8654d1c07729e961c172425088c451509557ef32"
  revision 1

  head "https://github.com/brson/multirust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f58b68e086a4942516a3c48dc1692f1ad5b6faff6f02bde3c7e86bd052858f73" => :el_capitan
    sha256 "ec7eefd2f4c172059ce22acb5460c5bdb5192b0b90613879222ff8cef6b359d4" => :yosemite
    sha256 "0ee26b2836581ec14bf52753b9f92010d86a1b23ab4f9460f32bcf73fe009acf" => :mavericks
  end

  depends_on :gpg => [:recommended, :run]

  conflicts_with "rust", :because => "both install rustc, rustdoc, cargo, rust-lldb, rust-gdb"

  def install
    system "./build.sh"
    system "./install.sh", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/multirust", "show-default"
  end
end
