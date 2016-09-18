class Le < Formula
  desc "Text editor with block and binary operations"
  homepage "https://github.com/lavv17/le"
  url "http://lav.yar.ru/download/le/le-1.16.3.tar.xz"
  sha256 "0be61306efd1e6b511c86d35c128e482e277e626ad949a56cb295489ef65d7b9"

  bottle do
    rebuild 1
    sha256 "3a4e6a2d4d4d137947d86420b8ce97ccdfad3e44373653e101313c37f7a9b1d8" => :sierra
    sha256 "f11062802f273db94638dee33fbe9ca2d602ee240d88577d31c2093d876c0dbc" => :el_capitan
    sha256 "1c5dd5bae3c5e8049c5bfcd11593452095a498fe62c33c94e9269e391d97299f" => :yosemite
  end

  conflicts_with "logentries", :because => "both install a le binary"

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/le --help", 1)
  end
end
