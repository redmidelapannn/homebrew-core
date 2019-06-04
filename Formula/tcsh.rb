class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "ftp://ftp.astron.com/pub/tcsh/tcsh-6.21.00.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.21.00.tar.gz"
  sha256 "c438325448371f59b12a4c93bfd3f6982e6f79f8c5aef4bc83aac8f62766e972"

  bottle do
    rebuild 1
    sha256 "17ba2742718d6e6f236480a6adcc010a088b4605eafbdac0a378c58da1dcbf41" => :mojave
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
