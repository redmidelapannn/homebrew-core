class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata-ids.org/"
  url "http://www.openinfosecfoundation.org/download/suricata-2.0.8.tar.gz"
  sha256 "7af6394cb81e464f5c1ac88a1444030e30940caab6e53688a6d9eb652226d1be"
  revision 1

  bottle do
    sha256 "86cbbdf70b8932e5a3d006cf7e235f5c57abe7a1a013229e9c9bd978caba05fb" => :el_capitan
    sha256 "2c9fc76cda6b9432f6614f18fb69990ae01fa2abc20f2cc2d9a6b4789178ed52" => :yosemite
    sha256 "2e19a5104f843a13088fe498d29f56e0dfe2c96ed676678b354e86df230940ad" => :mavericks
  end

  devel do
    url "http://www.openinfosecfoundation.org/download/suricata-2.1beta4.tar.gz"
    sha256 "12b3c98a7464ef6fb631884aa648b53a9cbb04279f754009fdc9ae2a6b605b95"
    version "2.1beta4"
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "libyaml"
  depends_on "pcre"
  depends_on "geoip" => :optional
  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on "jansson" => :optional

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha256 "b3a79a23d37b5a02faa550b92cbbbebeb4aa1d77e649c3eb39c19abf5262da04"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/source/s/simplejson/simplejson-3.6.5.tar.gz"
    sha256 "2a3189f79d1c7b8a2149a0e783c0b4217fad9b30a6e7d60450f2553dc2c0e57e"
  end

  def install
    # bug raised https://redmine.openinfosecfoundation.org/issues/1470
    ENV.deparallelize

    libnet = Formula["libnet"]
    libmagic = Formula["libmagic"]

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-libnet-includes=#{libnet.opt_include}
      --with-libnet-libs=#{libnet.opt_lib}
      --with-libmagic-includes=#{libmagic.opt_include}
      --with-libmagic-libraries=#{libmagic.opt_lib}
    ]

    args << "--enable-lua" if build.with? "lua"
    args << "--enable-luajit" if build.with? "luajit"

    if build.with? "geoip"
      geoip = Formula["geoip"]
      args << "--enable-geoip"
      args << "--with-libgeoip-includes=#{geoip.opt_include}"
      args << "--with-libgeoip-libs=#{geoip.opt_lib}"
    end

    if build.with? "jansson"
      jansson = Formula["jansson"]
      args << "--with-libjansson-includes=#{jansson.opt_include}"
      args << "--with-libjansson-libraries=#{jansson.opt_lib}"
    end

    system "./configure", *args
    system "make", "install-full"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # Leave the magic-file: prefix in otherwise it overrides a commented out line rather than intended line.
    inreplace etc/"suricata/suricata.yaml", %r{magic-file: /.+/magic}, "magic-file: #{libmagic.opt_share}/misc/magic"
  end

  test do
    assert_match(/#{version}/, shell_output("#{bin}/suricata --build-info"))
  end
end
