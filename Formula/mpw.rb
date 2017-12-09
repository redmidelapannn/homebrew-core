class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://ssl.masterpasswordapp.com/"
  url "https://ssl.masterpasswordapp.com/mpw-2.6-cli-4-0-gf8043ae1.tar.gz"
  version "2.6-cli-4"
  sha256 "90480c0994cccdaa6637cc311e2092e5b6f2fdc751b58d218a6bd61e4603b2a0"
  revision 1
  head "https://github.com/Lyndir/MasterPassword.git"

  bottle do
    cellar :any
    sha256 "27d5ade109a212aa3f136221e616f047adc4fa1e964d84effc3759ddd6dbd06a" => :high_sierra
    sha256 "d3082ff5c9f4e74ef67528f14f94b8adf750eb8b88ee95f23b2b54b84af9b4a6" => :sierra
    sha256 "1fe5907a47736ade16c500cf0aeaba8b887275360e227ac1b6540bb280f8541b" => :el_capitan
  end

  option "without-json-c", "Disable JSON configuration support"
  option "without-ncurses", "Disable colorized identicon support"

  depends_on "libsodium"
  depends_on "json-c" => :recommended
  depends_on "ncurses" => :recommended

  def install
    cd "platform-independent/cli-c" if build.head?

    ENV["targets"] = "mpw"
    ENV["mpw_json"] = build.with?("json-c") ? "1" : "0"
    ENV["mpw_color"] = build.with?("ncurses") ? "1" : "0"

    system "./build"
    system "./mpw-cli-tests"
    bin.install "mpw"
  end

  test do
    assert_equal "Jejr5[RepuSosp",
      shell_output("#{bin}/mpw -q -Fnone -u 'Robert Lee Mitchell' -M 'banana colored duckling' -tlong -c1 -a3 'masterpasswordapp.com'").strip
  end
end
