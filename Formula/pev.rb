class Pev < Formula
  desc "PE analysis toolkit"
  homepage "http://pev.sf.net/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.70/pev-0.70.tar.gz"
  sha256 "250396a06930d60a92e9bc86d7afb543d899ba12c007d1be5d09802a02908202"
  revision 1

  head "https://github.com/merces/pev.git"

  bottle do
    cellar :any
    revision 1
    sha256 "768dc9179edc0ea786c417046198e0f610553e4644a8c3631bf10ed0d2f3a046" => :el_capitan
    sha256 "1a390f6d630deac8e37ab3d833108bf542acb3535ed8eaaed0447c15d61eb602" => :yosemite
    sha256 "50aa3b02360fb76456f18321aa615bb5830e482d9303766d65cb02c845cfff55" => :mavericks
  end

  depends_on "pcre"
  depends_on "openssl"

  def install
    inreplace "src/Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "SHAREDIR", share
      s.change_make_var! "MANDIR", man
    end

    inreplace "lib/libpe/Makefile", "/usr", prefix

    system "make", "CC=#{ENV.cc}"
    system "make", "install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
