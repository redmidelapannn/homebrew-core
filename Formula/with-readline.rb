class WithReadline < Formula
  desc "Allow GNU Readline to be used with arbitrary programs"
  homepage "http://www.greenend.org.uk/rjk/sw/withreadline.html"
  url "http://www.greenend.org.uk/rjk/sw/with-readline-0.1.1.tar.gz"
  sha256 "d12c71eb57ef1dbe35e7bd7a1cc470a4cb309c63644116dbd9c88762eb31b55d"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "3a65c2288f4b8126aa2e0f38adff4d7e2654ab54aef0c1e3c6002fdc895f692d" => :sierra
    sha256 "92db79172ccda1fd5ef710fd0f75e3ffb666728cc1efff1c327249b07c96a223" => :el_capitan
    sha256 "6ff4675c86581f7bdedbab29fb84989e1e28506f45c96df2e2583c2da3fed444" => :yosemite
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/with-readline /usr/bin/expect", "exit", 0)
  end
end
