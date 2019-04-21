class Tcptraceroute < Formula
  desc "Traceroute implementation using TCP packets"
  homepage "https://github.com/mct/tcptraceroute"
  revision 2
  head "https://github.com/mct/tcptraceroute.git"

  stable do
    url "https://github.com/mct/tcptraceroute/archive/tcptraceroute-1.5beta7.tar.gz"
    sha256 "57fd2e444935bc5be8682c302994ba218a7c738c3a6cae00593a866cd85be8e7"

    # Call `pcap_lib_version()` rather than access `pcap_version` directly
    # upstream issue: https://github.com/mct/tcptraceroute/issues/5
    patch do
      url "https://github.com/mct/tcptraceroute/commit/3772409867b3c5591c50d69f0abacf780c3a555f.patch?full_index=1"
      sha256 "c08e013eb01375e5ebf891773648a0893ccba32932a667eed00a6cee2ccf182e"
    end
  end

  bottle do
    cellar :any
    sha256 "fe4f94b434014e1c06982530025484d133068b026995f1bd39bc5984f4e912cb" => :mojave
    sha256 "e38c2b5c8ed1f9d3aa3dd911438ccacaaeb0525bde8211976a1c112b0ca99642" => :high_sierra
    sha256 "433c171935d7a5b76589d10be04ff95110bb7c69ebe5a78e95fb87debcb5fa41" => :sierra
  end

  depends_on "libnet"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  def caveats; <<~EOS
    tcptraceroute requires root privileges so you will need to run
    `sudo tcptraceroute`.
    You should be certain that you trust any software you grant root privileges.
  EOS
  end

  test do
    output = shell_output("#{bin}/tcptraceroute --help 2>&1", 1)
    assert_match "Usage: tcptraceroute", output
  end
end
