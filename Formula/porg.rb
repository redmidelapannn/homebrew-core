class Porg < Formula
  desc "Source Code Package Organizer"
  homepage "http://porg.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/porg/porg-0.10.tar.gz"
  sha256 "48f8433193f92097824ed7a72c4babafb29dc2ffe60e7df3635664f59f09cedd"

  bottle do
    sha256 "cdb60808d4de553fb4b4ade8aaec12567084d2bb235e73698925c5d11601ad89" => :sierra
    sha256 "9c2fa4897f48486fdfde5d49d8bccf2c1da0131956e403d9265f9ee34bb1f209" => :el_capitan
    sha256 "d39ce9f4407be3badb0fd544c522db105593664681ceb0ec42b290cca0e4af3e" => :yosemite
  end

  option "without-gtkmm3", "Don't install Grop, which is the graphic interface of porg."

  depends_on "pkg-config" => :build
  depends_on "gtkmm3" => :recommended

  def install
    args = %W[--disable-silent-rules --prefix=#{prefix} --with-porg-logdir=#{var}/log/porg]

    args << "--disable-grop" if build.without? "gtkmm3"

    system "./configure", *args
    system "make", "install"
  end

  test do
    `porg -lp foo-1.0 'echo "hello world" > #{testpath}/foo.log'`

    $?.success? && `porg -a` =~ /foo/
  end
end
