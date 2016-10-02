class Xtail < Formula
  desc "Watch growth of multiple files or directories (like `tail -f`)"
  homepage "https://www.unicom.com/sw/xtail"
  url "https://www.unicom.com/files/xtail-2.1.tar.gz"
  sha256 "75184926dffd89e9405769b24f01c8ed3b25d3c4a8eac60271fc5bb11f6c2d53"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7d3be5e52bdac7e233b0ae92658efb7ab624d47a4a69caedbcaae3d36acc9262" => :sierra
    sha256 "1fdd8c0662b91d3152690dd1666ec35f801f152199efd03d3c3622bfda34d1d2" => :el_capitan
    sha256 "63c21b0ee95d38591d98bf770bac3357930079acb0cc6d0b02002114e884f3bd" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    man1.mkpath
    bin.mkpath
    system "make", "install"
  end

  test do
    file1 = testpath/"file1"
    file2 = testpath/"file2"
    file1.write ""
    file2.write ""

    begin
      p = IO.popen("#{bin}/xtail file1 file2")
      # Give xtail a couple seconds before and after so that it could
      # relatively reliably pick up the changes.
      sleep 2
      file1.append_lines "hello\n"
      file2.append_lines "world\n"
      sleep 2
    ensure
      Process.kill "QUIT", p.pid
      Process.wait p.pid
    end

    output = p.read
    assert_match "hello", output
    assert_match "world", output
  end
end
