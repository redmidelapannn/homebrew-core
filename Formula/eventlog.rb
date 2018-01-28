class Eventlog < Formula
  desc "Replacement for syslog API providing structure to messages"
  homepage "https://my.balabit.com/downloads/eventlog/"
  url "https://my.balabit.com/downloads/syslog-ng/sources/3.4.3/source/eventlog_0.2.13.tar.gz"
  sha256 "7cb4e6f316daede4fa54547371d5c986395177c12dbdec74a66298e684ac8b85"

  bottle do
    cellar :any
    rebuild 1
    sha256 "891e3da55ec1a415cdfdd199d3eb32e00b17089ab8b69cea8c08474a5ee14ccb" => :high_sierra
    sha256 "c23f2de39fa79efc13d6625e31c412f37af848d853c2b8f0926798a06b082706" => :sierra
    sha256 "46f317eecdb6fc02db013a8c387b3c32b258de873870c1b4a5462bbdfc837976" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
