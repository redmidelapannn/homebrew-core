class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://masterpasswordapp.com/"
  url "https://masterpasswordapp.com/mpw-2.6-cli-5-0-g344771db.tar.gz"
  version "2.6-cli-5"
  sha256 "954c07b1713ecc2b30a07bead9c11e6204dd774ca67b5bdf7d2d6ad1c4eec170"
  revision 1
  head "https://github.com/Lyndir/MasterPassword.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "17a1dc09f000bfd2f45b4c74f3b3ea0a58016f80e726ae5c7fb10392da4a8815" => :mojave
    sha256 "723eb3f761e2711472980ecb3de7ef218dc5bea25c8aee95e9c156c97b4527a6" => :high_sierra
    sha256 "3f3e4c272be0858dce668f338d71cbed4542accc2f5956805eae04e8b351ccf7" => :sierra
    sha256 "23c11d9f7e070dd3c1caf677a7b5106ef72d2813f38a7c8ebd577601494fe11c" => :el_capitan
  end

  depends_on "json-c"
  depends_on "libsodium"
  depends_on "ncurses"

  def install
    cd "platform-independent/cli-c" if build.head?

    ENV["targets"] = "mpw"
    ENV["mpw_json"] = "1"
    ENV["mpw_color"] = "1"

    system "./build"
    system "./mpw-cli-tests"
    bin.install "mpw"
  end

  test do
    assert_equal "Jejr5[RepuSosp",
      shell_output("#{bin}/mpw -q -Fnone -u 'Robert Lee Mitchell' -M 'banana colored duckling' -tlong -c1 -a3 'masterpasswordapp.com'").strip
  end
end
