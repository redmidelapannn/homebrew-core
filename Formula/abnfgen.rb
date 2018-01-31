class Abnfgen < Formula
  desc "Quickly generate random documents that match an ABFN grammar"
  homepage "http://www.quut.com/abnfgen/"
  url "http://www.quut.com/abnfgen/abnfgen-0.18.tar.gz"
  sha256 "a4e568e529acb85ef93b91f8cea9590401deb2a2e0114ee356d5779449b9d974"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c1757fae2d0ab7ccc095882f26b691201a31421a44f37da6408fcf5b209db4fb" => :high_sierra
    sha256 "aeeaddecbca233e5148ad90deab851c2047d4fee59a2ec14a8dbe5c8a810f84e" => :sierra
    sha256 "3334426d2ce99d9ba09a013d1e82e78c042c28abf7f4497ce12a653ddd7b92a5" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"grammar").write 'ring = 1*12("ding" SP) "dong" CRLF'
    system "#{bin}/abnfgen", (testpath/"grammar")
  end
end
