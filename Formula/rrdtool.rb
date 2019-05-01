class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/index.en.html"
  url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.7.1/rrdtool-1.7.1.tar.gz"
  sha256 "989b778eda6967aa5192c73abafe43e7b10e6100776971a7e79d249942781aae"

  bottle do
    sha256 "e6f1fd95257f096c803ea6a09f52d48085cf04f39c9e805a37775b73d28e28b4" => :mojave
    sha256 "b701dfc41e538f6d4489685709c33f66feb7b0b94e52048853e060e3cdb90a6b" => :high_sierra
    sha256 "0dca8fedfa1c8b3cc41ae953d7c2739efe79d6b32bff4d554ef319be2aea7e59" => :sierra
  end

  head do
    url "https://github.com/oetiker/rrdtool-1.x.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "pango"
  depends_on "perl"

  def install
    # fatal error: 'ruby/config.h' file not found
    ENV.delete("SDKROOT")

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-tcl
      --with-tcllib=/usr/lib
      --with-perl-options='PREFIX=#{prefix}'
      --enable-ruby-site-install
    ]

    # Ha-ha, but sleeping is annoying when running configure a lot
    inreplace "configure", /^sleep 1$/, "#sleep 1"

    system "./bootstrap" if build.head?
    system "./configure", *args

    # Needed to build proper Ruby bundle
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}", "install"
    prefix.install "bindings/ruby/test.rb"
  end

  test do
    system "#{bin}/rrdtool", "create", "temperature.rrd", "--step", "300",
      "DS:temp:GAUGE:600:-273:5000", "RRA:AVERAGE:0.5:1:1200",
      "RRA:MIN:0.5:12:2400", "RRA:MAX:0.5:12:2400", "RRA:AVERAGE:0.5:12:2400"
    system "#{bin}/rrdtool", "dump", "temperature.rrd"
  end
end
