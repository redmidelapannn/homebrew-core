class Rpl < Formula
  desc "Text replacement utility"
  homepage "http://www.laffeycomputer.com/rpl.html"
  url "https://web.archive.org/web/20170106105512/downloads.laffeycomputer.com/current_builds/rpl-1.4.1.tar.gz"
  sha256 "291055dc8763c855bab76142b5f7e9625392bcefa524b796bc4ddbcf941a1310"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ec3adfa5362b967eac3ed560cd8424aac209b6c55e3416575530040e5eb6b98f" => :mojave
    sha256 "053f178710998562d7845a8e6fc87070ab79068984ce74b093e405a80a78effa" => :high_sierra
    sha256 "784127edd04b294d4ba1ef82168d2d5bb3b4f4cd4714251ef96322d724b222f7" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system "#{bin}/rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
