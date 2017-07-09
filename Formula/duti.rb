class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.3.tar.gz"
  sha256 "0e71b7398e01aedf9dde0ffe7fd5389cfe82aafae38c078240780e12a445b9fa"
  head "https://github.com/moretension/duti.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "42c996b6cc2d7e4d5bd46d664a0696de26284a7112e13ec6108aef9bb6aab75b" => :sierra
    sha256 "bb292780827b71f4f8c1646134a23f3c37fb648329ca1ad4a63a012a50372e58" => :el_capitan
    sha256 "cf083a81fdd4690ce399fae05217a52eb5362ef121b1d469114ea8bc1c5fd9ae" => :yosemite
  end

  depends_on "autoconf" => :build

  # Add hardcoded SDK path for El Capitan or later.
  if MacOS.version >= :el_capitan
    patch do
      url "https://github.com/moretension/duti/commit/7dbcae8.patch?full_index=1"
      sha256 "09ea9bec926f38beb217c597fc224fc19c972e44835783a57fe8a54450cb8fb6"
    end
  end

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "com.apple.TextEdit", shell_output("#{bin}/duti -l public.text"),
                 "TextEdit not found among the handlers for public.text"
  end
end
