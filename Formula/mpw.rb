class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://masterpasswordapp.com/"
  url "https://masterpasswordapp.com/mpw-2.6-cli-5-0-g344771db.tar.gz"
  version "2.6-cli-5"
  sha256 "954c07b1713ecc2b30a07bead9c11e6204dd774ca67b5bdf7d2d6ad1c4eec170"
  revision 1
  head "https://gitlab.com/MasterPassword/MasterPassword.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a15b43ca3818e054555ba39a0573a7618beae99d5ed98a8ab08eff587286e9a1" => :catalina
    sha256 "6eea62700df6de7aff7a513c9bb4a6fdbd1122d2a5eab833fdedfa5798c6166c" => :mojave
    sha256 "926b76edb0fdf017a8522088c76f1519596a4da3c4afdda78871159ec9a859c5" => :high_sierra
  end

  depends_on "json-c"
  depends_on "libsodium"
  depends_on "ncurses"

  def install
    cd "platform-independent/c/cli" if build.head?

    ENV["targets"] = "mpw"
    ENV["mpw_json"] = "1"
    ENV["mpw_color"] = "1"

    system "./build"
    system "./mpw-cli-tests"
    bin.install "mpw"
  end

  test do
    assert_equal "Jejr5[RepuSosp",
      shell_output("#{bin}/mpw -q -Fnone -u 'Robert Lee Mitchell' -M 'banana colored duckling' " \
                   "-tlong -c1 -a3 'masterpasswordapp.com'").strip
  end
end
