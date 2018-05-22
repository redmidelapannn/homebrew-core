class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.11.4.tar.gz"
  sha256 "fb0d7d2558e2198d9224b44dc4220d4c62e1b5b0069312012306275be39b4ab9"
  revision 2

  head "https://github.com/innotop/innotop.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "27368f9e390ff6c615c9d3beb4ca78c81a4080bd65d4c539c1fec37fec2f1a47" => :high_sierra
    sha256 "594027db5b289f4387a134f347503bf34e3867fcb80ef70ce9cc73afb3b03cf7" => :sierra
    sha256 "08ddba3eb2de6b4354ccde85333fd851c919bdc4673b48675a20991a05df2ffe" => :el_capitan
  end

  depends_on "mysql"
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.636.tar.gz"
    sha256 "8f7ddce97c04b4b7a000e65e5d05f679c964d62c8b02c94c1a7d815bb2dd676c"
  end

  resource "TermReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.37.tar.gz"
    sha256 "4a9383cf2e0e0194668fe2bd546e894ffad41d556b41d2f2f577c8db682db241"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    inreplace "innotop", "#!/usr/bin/env perl", "#!/usr/bin/perl"

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
