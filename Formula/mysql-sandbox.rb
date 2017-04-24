class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.07.tar.gz"
  sha256 "26673773aee7e8b52615aad2b95b35c0e6aa00b8d67cb6c524ef2b43cc4894df"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2a0dcd249d95f53995a3439812bafa143c738955fe24babe5d5d355ecc2098f5" => :sierra
    sha256 "e84f1dcfcffc59efd62b5c606d07894f124fb7b0dffba92861a4dbff7dfd476f" => :el_capitan
    sha256 "b136a8757cfde7cf4027056b56a9022f79e8c79498070be558199024f35395e9" => :yosemite
  end

  def install
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5/site_perl"

    system "perl", "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "test", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/msandbox", 1)
  end
end
