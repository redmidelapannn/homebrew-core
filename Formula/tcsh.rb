class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://web.archive.org/web/20170609182511/www.tcsh.org/Home"
  url "ftp://ftp.astron.com/pub/tcsh/tcsh-6.20.00.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.20.00.tar.gz"
  sha256 "b89de7064ab54dac454a266cfe5d8bf66940cb5ed048d0c30674ea62e7ecef9d"

  bottle do
    rebuild 1
    sha256 "4d1dd813938a755fc8914aa1f9b217ce7b9de2f01c46d7632592b4e21d0aec10" => :mojave
    sha256 "88b84715940b0d3a98a2f1a82fc6d3996af771ed4183f53d981c6314f0841e3f" => :high_sierra
    sha256 "1b7bbd9d5b42a2b6290156a17436bb1084603fbbbfa26e369e8a0ee4bc80af6c" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath/"test.csh").write <<~EOS
      #!#{bin}/tcsh -f
      set ARRAY=( "t" "e" "s" "t" )
      foreach i ( `seq $#ARRAY` )
        echo -n $ARRAY[$i]
      end
    EOS
    assert_equal "test", shell_output("#{bin}/tcsh ./test.csh")
  end
end
